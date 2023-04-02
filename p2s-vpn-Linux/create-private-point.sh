region="westeurope"
resourceGroupName="RG01"
virtualNetworkName="vNetRG01"
vpnName="vNetGwRG01"
publicIpAddressName="$vpnName-PublicIP"
rootCertName="P2SRootCertLinux"
rootCertificate="./rootCert.pem"
mystorageaccount="saecj00"
myfileshare="data-ecj"
myPrivateEndPoint="pep-ecj"

az login --use-device-code

storage_id=$(az storage account show --resource-group $resourceGroupName --name $mystorageaccount | jq -r .id)

az network private-endpoint create \
    --name $myPrivateEndPoint \
    --resource-group $resourceGroupName  \
    --vnet-name $virtualNetworkName \
    --subnet "PrivateEndpointSubnet" \
    --private-connection-resource-id $storage_id \
    --group-id file \
    --connection-name "pep-ecj-nic"