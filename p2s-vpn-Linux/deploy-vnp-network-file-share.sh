# Variables
region="westeurope"
resourceGroupName="RG01"
virtualNetworkName="vNetRG01"
vpnName="vNetGwRG01"
publicIpAddressName="$vpnName-PublicIP"
rootCertName="P2SRootCertLinux"
rootCertificate="rootCert.pem"
installDir="/etc/"
username="client"
password="12345678"
mystorageaccount="saecj00"
myfileshare="data-ecj"
myPrivateEndPoint="pep-ecj"

# Create CA
echo "Creating CA"
ipsec pki --gen --outform pem > rootKey.pem
ipsec pki --self --in rootKey.pem --dn "CN=$rootCertName" --ca --outform pem > rootCert.pem

ipsec pki --gen --size 4096 --outform pem > "clientKey.pem"
ipsec pki --pub --in "clientKey.pem" | \
    ipsec pki \
        --issue \
        --cacert rootCert.pem \
        --cakey rootKey.pem \
        --dn "CN=$username" \
        --san $username \
        --flag clientAuth \
        --outform pem > "clientCert.pem"

openssl pkcs12 -in "clientCert.pem" -inkey "clientKey.pem" -certfile rootCert.pem -export -out "$username.p12" -password "pass:$password"
echo "--------------------------------"
echo ""

# Login to Azure account
echo "Login to Azure"
az login --use-device-code
echo "--------------------------------"
echo ""

echo "Creating ResourceGroup"
az group create -l $region -n $resourceGroupName
echo "--------------------------------"
echo ""

echo "Creating VirtualNetwork"
virtualNetwork=$(az network vnet create \
    --resource-group $resourceGroupName \
    --name $virtualNetworkName \
    --location $region \
    --address-prefixes "10.10.0.0/16" \
    --query "newVNet.id" | tr -d '"')
echo "--------------------------------"
echo ""

echo "Creating ServiceEndpointSubnet"
serviceEndpointSubnet=$(az network vnet subnet create \
    --resource-group $resourceGroupName \
    --vnet-name $virtualNetworkName \
    --name "ServiceEndpointSubnet" \
    --address-prefixes "10.10.0.0/24" \
    --service-endpoints "Microsoft.Storage" \
    --query "id" | tr -d '"')
echo "--------------------------------"
echo ""

echo "Creating privateEndpointSubnet"
privateEndpointSubnet=$(az network vnet subnet create \
    --resource-group $resourceGroupName \
    --vnet-name $virtualNetworkName \
    --name "PrivateEndpointSubnet" \
    --address-prefixes "10.10.1.0/24" \
    --query "id" | tr -d '"')
echo "--------------------------------"
echo ""

echo "Creating gatewaySubnet"
gatewaySubnet=$(az network vnet subnet create \
    --resource-group $resourceGroupName \
    --vnet-name $virtualNetworkName \
    --name "GatewaySubnet" \
    --address-prefixes "10.10.2.0/24" \
    --query "id" | tr -d '"')
echo "--------------------------------"
echo ""

echo "Deploying Virtual Network Gateway"
echo ""
echo "Step 1"
publicIpAddress=$(az network public-ip create \
    --resource-group $resourceGroupName \
    --name $publicIpAddressName \
    --location $region \
    --sku "Basic" \
    --allocation-method "Dynamic" \
    --query "publicIp.id" | tr -d '"')
echo "--------------------------------"
echo ""

echo "Step 2"
az network vnet-gateway create \
    --resource-group $resourceGroupName \
    --name $vpnName \
    --vnet $virtualNetworkName \
    --public-ip-addresses $publicIpAddress \
    --location $region \
    --sku "VpnGw1" \
    --gateway-typ "Vpn" \
    --vpn-type "RouteBased" \
    --address-prefixes "172.16.201.0/24" \
    --client-protocol "IkeV2" > /dev/null
echo "--------------------------------"
echo ""

echo "Step 3"
az network vnet-gateway root-cert create \
    --resource-group $resourceGroupName \
    --gateway-name $vpnName \
    --name $rootCertName \
    --public-cert-data $rootCertificate \
    --output none
echo "--------------------------------"
echo ""

echo "Downloading VPN Client"
vpnClient=$(az network vnet-gateway vpn-client generate \
    --resource-group $resourceGroupName \
    --name $vpnName \
    --authentication-method EAPTLS | tr -d '"')

curl $vpnClient --output vpnClient.zip

unzip vpnClient.zip

vpnServer=$(xmllint --xpath "string(/VpnProfile/VpnServer)" Generic/VpnSettings.xml)
vpnType=$(xmllint --xpath "string(/VpnProfile/VpnType)" Generic/VpnSettings.xml | tr '[:upper:]' '[:lower:]')
routes=$(xmllint --xpath "string(/VpnProfile/Routes)" Generic/VpnSettings.xml)

cp "${installDir}ipsec.conf" "${installDir}ipsec.conf.backup"
cp "Generic/VpnServerRoot.cer_0" "${installDir}ipsec.d/cacerts"
cp "${username}.p12" "${installDir}ipsec.d/private" 

tee -a "${installDir}ipsec.conf" <<EOF
conn azure
    keyexchange=$vpnType
    type=tunnel
    leftfirewall=yes
    left=%any
    leftauth=eap-tls
    leftid=%client
    right=$vpnServer
    rightid=%$vpnServer
    rightsubnet=$routes
    leftsourceip=%config
    esp=aes256gcm16,aes128gcm16!
    auto=add
EOF

echo ": P12 $username.p12 '$password'" | tee -a "${installDir}ipsec.secrets" > /dev/null

echo "Connecting VPN"
# Restar VPN
ipsec restart

echo "Wait ..."
sleep 30

# Up tunel "azure"
ipsec up azure
echo "--------------------------------"
echo ""

my_public_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)

echo "Creating Storage Account"
az storage account create -n $mystorageaccount -g $resourceGroupName -l $region --sku Standard_GRS --default-action Deny
echo "--------------------------------"
echo ""

echo "Allowing access from my public IP to storager account"
az storage account network-rule add --resource-group $resourceGroupName --account-name $mystorageaccount --ip-address $my_public_IP
echo "--------------------------------"
echo ""

echo "Wait ..."
sleep 30
echo "--------------------------------"
echo ""

echo "Creating File Shared Storage Account"
storage_conn_string=$(az storage account show-connection-string -n $mystorageaccount -g $resourceGroupName --query 'connectionString' -o tsv)
az storage share create --name $myfileshare --connection-string $storage_conn_string
echo "--------------------------------"
echo ""

echo "Creating Private Point"
storage_id=$(az storage account show --resource-group $resourceGroupName --name $mystorageaccount | jq -r .id)

az network private-endpoint create \
    --name $myPrivateEndPoint \
    --resource-group $resourceGroupName  \
    --vnet-name $virtualNetworkName \
    --subnet "PrivateEndpointSubnet" \
    --private-connection-resource-id $storage_id \
    --group-id file \
    --connection-name "pep-ecj-nic"
echo "--------------------------------"
echo ""

echo "Mounting File Share"

if [ ! -d "/mnt/$myfileshare" ]; then
mkdir /mnt/$myfileshare
fi

if [ ! -d "/etc/smbcredentials" ]; then
mkdir /etc/smbcredentials
fi

key=$(az storage account keys list -g $resourceGroupName -n $mystorageaccount  --query [0].value -o tsv)

if [ ! -f "/etc/smbcredentials/$mystorageaccount.cred" ]; then
    echo "username=$mystorageaccount" >> /etc/smbcredentials/$mystorageaccount.cred
    echo "password=$key" >> /etc/smbcredentials/$mystorageaccount.cred
fi
chmod 600 /etc/smbcredentials/$mystorageaccount.cred

PEP_IP_Address=$(az network private-endpoint show --resource-group $resourceGroupName --name $myPrivateEndPoint | jq -r .customDnsConfigs[0].ipAddresses[0])

mount -t cifs //$PEP_IP_Address/$myfileshare /mnt/$myfileshare -o credentials=/etc/smbcredentials/$mystorageaccount.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30
echo "--------------------------------"
echo "END"
