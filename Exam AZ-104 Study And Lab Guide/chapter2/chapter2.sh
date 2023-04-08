#!/bin/bash

# Load script chapter 1
source ../chapter1/chapter1_v1.sh

echo -e $green
echo "Creating VM cloud-vma1"
echo -e $resetcolor
vmname="cloud-vma1"
username="AdminAccount"
password="Pa55w.rd12345"
az vm create \
    --resource-group ${RGS[0,rgName]} \
    --name $vmname \
    --image Win2019Datacenter \
    --location ${RGS[0,region]} \
    --size Standard_DS2_v2 \
    --admin-username $username \
    --admin-password $password  \
    --vnet-name ${vNets[0,vNetName]} \
    --subnet ${subnets[0,name]} \
    --public-ip-address "sipa" \
    --zone 1
echo "--------------------------------"
echo ""

echo -e $green
echo "Installing IIS in cloud-vm1"
echo -e $resetcolor
az vm run-command invoke -g ${RGS[0,rgName]} \
   -n $vmname \
   --command-id RunPowerShellScript \
   --scripts "Install-WindowsFeature -name Web-Server -IncludeManagementTools"
echo "--------------------------------"
echo ""

echo -e $green
echo "Opening TCP ports 80 and 443"
echo -e $resetcolor
az vm open-port --port 80,443 --resource-group ${RGS[0,rgName]} --name $vmname
echo "--------------------------------"
echo ""

echo -e $green
echo "Attaching a new disk"
echo -e $resetcolor
az vm disk attach \
   -g ${RGS[0,rgName]} \
   --vm-name $vmname \
   --sku StandardSSD_LRS \
   --name ddcloud2 \
   --lun 2 \
   --new \
   --size-gb 4
echo "--------------------------------"
echo ""

echo -e $green
echo "Creating availability set"
echo -e $resetcolor
az vm availability-set create --name ASCloud \
                              --resource-group ${RGS[1,rgName]} \
                              --location ${RGS[1,region]} \
                              --platform-fault-domain-count 2 \
                              --platform-update-domain-count 5
echo "--------------------------------"
echo ""

echo -e $green
echo "Creating VM cloud-vma3"
echo -e $resetcolor
vmname="cloud-vma3"
username="AdminAccount"
password="Pa55w.rd12345"
az vm create \
    --resource-group ${RGS[1,rgName]} \
    --name $vmname \
    --image Win2019Datacenter \
    --location ${RGS[1,region]} \
    --size Standard_DS2_v2 \
    --admin-username $username \
    --admin-password $password  \
    --vnet-name ${vNets[1,vNetName]} \
    --subnet ${subnets[3,name]} \
    --availability-set ASCloud
echo "--------------------------------"
echo ""

echo -e $green
echo "Opening TCP ports 80 and 443 for host $vmname"
echo -e $resetcolor
az vm open-port --port 80,443 --resource-group ${RGS[1,rgName]} --name $vmname
echo "--------------------------------"
echo ""

echo -e $green
echo "Assign DNS name public IP for host $vmname"
echo -e $resetcolor
publicIPNameVm=$(az vm list-ip-addresses -g ${RGS[1,rgName]} -n $vmname | jq -r '.[0].virtualMachine.network.publicIpAddresses[0].name')
az network public-ip update -g ${RGS[1,rgName]} -n $publicIPNameVm --dns-name $vmname
echo "--------------------------------"
echo ""
