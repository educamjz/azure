resourceGroupName="RG01"
mystorageaccount="saecj00"
myfileshare="data-ecj"
myPrivateEndPoint="pep-ecj"

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

echo "//$PEP_IP_Address/$myfileshare /mnt/$myfileshare cifs nofail,credentials=/etc/smbcredentials/$mystorageaccount.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30" >> /etc/fstab
mount -t cifs //$PEP_IP_Address/$myfileshare /mnt/$myfileshare -o credentials=/etc/smbcredentials/$mystorageaccount.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30
