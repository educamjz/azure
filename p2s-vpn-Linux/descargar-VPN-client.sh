region="westeurope"
resourceGroupName="RG01"
virtualNetworkName="vNetRG01"
vpnName="vNetGwRG01"
publicIpAddressName="$vpnName-PublicIP"
rootCertName="P2SRootCertLinux"
rootCertificate="rootCert.pem"

az login

vpnClient=$(az network vnet-gateway vpn-client generate \
    --resource-group $resourceGroupName \
    --name $vpnName \
    --authentication-method EAPTLS | tr -d '"')

curl $vpnClient --output vpnClient.zip