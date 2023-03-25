region="westeurope"
resourceGroupName="RG01"
virtualNetworkName="vNetRG01"
vpnName="vNetGwRG01"
publicIpAddressName="$vpnName-PublicIP"
rootCertName="P2SRootCertLinux"
rootCertificate="rootCert.pem"

az login

echo "Creating ResourceGroup"
az group create -l $region -n $resourceGroupName
echo " --------------------------------"
echo ""

echo "Creating VirtualNetwork"
virtualNetwork=$(az network vnet create \
    --resource-group $resourceGroupName \
    --name $virtualNetworkName \
    --location $region \
    --address-prefixes "10.10.0.0/16" \
    --query "newVNet.id" | tr -d '"')
echo " --------------------------------"
echo ""

echo "Creating ServiceEndpointSubnet"
serviceEndpointSubnet=$(az network vnet subnet create \
    --resource-group $resourceGroupName \
    --vnet-name $virtualNetworkName \
    --name "ServiceEndpointSubnet" \
    --address-prefixes "10.10.0.0/24" \
    --service-endpoints "Microsoft.Storage" \
    --query "id" | tr -d '"')
echo " --------------------------------"
echo ""

echo "Creating privateEndpointSubnet"
privateEndpointSubnet=$(az network vnet subnet create \
    --resource-group $resourceGroupName \
    --vnet-name $virtualNetworkName \
    --name "PrivateEndpointSubnet" \
    --address-prefixes "10.10.1.0/24" \
    --query "id" | tr -d '"')
echo " --------------------------------"
echo ""

echo "Creating gatewaySubnet"
gatewaySubnet=$(az network vnet subnet create \
    --resource-group $resourceGroupName \
    --vnet-name $virtualNetworkName \
    --name "GatewaySubnet" \
    --address-prefixes "192.168.2.0/24" \
    --query "id" | tr -d '"')
echo " --------------------------------"
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
echo " --------------------------------"
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
echo " --------------------------------"
echo ""

echo "Step 3"
az network vnet-gateway root-cert create \
    --resource-group $resourceGroupName \
    --gateway-name $vpnName \
    --name $rootCertName \
    --public-cert-data $rootCertificate \
    --output none
echo " --------------------------------"
echo ""

echo "Downloading VPN Client"
vpnClient=$(az network vnet-gateway vpn-client generate \
    --resource-group $resourceGroupName \
    --name $vpnName \
    --authentication-method EAPTLS | tr -d '"')

curl $vpnClient --output vpnClient.zip
