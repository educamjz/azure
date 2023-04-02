region="westeurope"
resourceGroupName="RG01"
mystorageaccount="saecj00"
myfileshare="data-ecj"
virtualNetworkName="vNetRG01"
vpnName="vNetGwRG01"

my_public_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)

az login --use-device-code

az storage account create -n $mystorageaccount -g $resourceGroupName -l $region --sku Standard_GRS --default-action Deny
az storage account network-rule add --resource-group $RESOURCE_GROUP --account-name $mystorageaccount --ip-address $my_public_IP
storage_conn_string=$(az storage account show-connection-string -n $mystorageaccount -g $resourceGroupName --query 'connectionString' -o tsv)
az storage share create --name $myfileshare --connection-string $storage_conn_string