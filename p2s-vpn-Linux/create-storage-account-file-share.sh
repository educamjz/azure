region="westeurope"
resourceGroupName="RG01"
mystorageaccount="saecj00"
myfileshare="data-ecj"
virtualNetworkName="vNetRG01"
vpnName="vNetGwRG01"

my_public_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)

az login --use-device-code

echo "Creating Storage Account"
az storage account create -n $mystorageaccount -g $resourceGroupName -l $region --sku Standard_GRS --default-action Deny
echo " --------------------------------"
echo ""

echo "Allowing access from my public IP to storager account"
az storage account network-rule add --resource-group $resourceGroupName --account-name $mystorageaccount --ip-address $my_public_IP
echo " --------------------------------"
echo ""

echo "Wait ..."
sleep 30
echo " --------------------------------"
echo ""

echo "Creating File Shared Storage Account"
storage_conn_string=$(az storage account show-connection-string -n $mystorageaccount -g $resourceGroupName --query 'connectionString' -o tsv)
az storage share create --name $myfileshare --connection-string $storage_conn_string
echo " --------------------------------"
echo ""
