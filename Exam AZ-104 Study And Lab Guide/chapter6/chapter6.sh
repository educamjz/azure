#!/bin/bash

# Load script chapter 5
source ../chapter5/chapter5.sh

# Create a new VM in DB-Subnet
echo -e $green
echo "Creating VM cloud-vma2"
echo -e $resetcolor
vmname="cloud-vma2"
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
   --subnet ${subnets[1,name]} \
   --public-ip-address "" \
   --zone 1
echo "--------------------------------"
echo ""

# Create a new VM myvm-nva
echo -e $green
echo "Creating VM myvm-nva"
echo -e $resetcolor
vmname="myvm-nva"
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
    --subnet ${subnets[2,name]} \
    --public-ip-address "" \
    --zone 1
echo "--------------------------------"
echo ""

echo -e $green
echo "Enabling IP Forwarding in Azure for VM myvm-nva"
echo -e $resetcolor
vmname="myvm-nva"
nicIds=$(az vm nic list --resource-group ${RGS[0,rgName]} --vm-name $vmname |  jq -r '.[0] | .id')
az network nic update --ids $nicIds --ip-forwarding true
echo "--------------------------------"
echo ""

echo -e $green
echo "Enabling IP Forwarding in VM myvm-nva using a PowerShell Command"
echo -e $resetcolor
az vm run-command create --resource-group ${RGS[0,rgName]} \
    --location ${RGS[0,region]} \
    --async-execution false \
    --run-as-password $password \
    --run-as-user $username \
    --script "Get-NetAdapter | Set-NetIPInterface -Forwarding Enabled" \
    --timeout-in-seconds 3600 \
    --run-command-name "Enable-IP-Forwarding" \
    --vm-name $vmname
echo "--------------------------------"
echo ""

echo -e $green
echo "Creating route table RT-WS"
echo -e $resetcolor
routeTable="RT-WS"
az network route-table create --name $routeTable \
    --resource-group ${RGS[0,rgName]} \
    --disable-bgp-route-propagation no \
    --location ${RGS[0,region]}
echo "--------------------------------"
echo ""

echo -e $green
echo "Adding route in route table RT-WS"
echo -e $resetcolor
privateIpDMZvm=$(az vm show -g ${RGS[0,rgName]} -n $vmname -d --query privateIps -o tsv)
az network route-table route create --name "RouteToDBSubnet" \
    --resource-group ${RGS[0,rgName]} \
    --route-table-name $routeTable \
    --address-prefix ${subnets[1,cidr]} \
    --next-hop-ip-address $privateIpDMZvm \
    --next-hop-type VirtualAppliance
echo "--------------------------------"
echo ""

echo -e $green
echo "Associating table route RT-WS with subnet Web-Subnet"
echo -e $resetcolor
az network vnet subnet update --name ${subnets[0,name]} \
    --resource-group ${RGS[0,rgName]} \
    --vnet-name ${vNets[0,vNetName]} \
    --route-table $routeTable
echo "--------------------------------"
echo ""

echo -e $green
echo "Creating route table RT-DS"
echo -e $resetcolor
routeTable="RT-DS"
az network route-table create --name $routeTable \
    --resource-group ${RGS[0,rgName]} \
    --disable-bgp-route-propagation no \
    --location ${RGS[0,region]}
echo "--------------------------------"
echo ""

echo -e $green
echo "Adding route in route table RT-DS"
echo -e $resetcolor
privateIpDMZvm=$(az vm show -g ${RGS[0,rgName]} -n $vmname -d --query privateIps -o tsv)
az network route-table route create --name "RouteToWebSubnet" \
    --resource-group ${RGS[0,rgName]} \
    --route-table-name $routeTable \
    --address-prefix ${subnets[0,cidr]} \
    --next-hop-ip-address $privateIpDMZvm \
    --next-hop-type VirtualAppliance
echo "--------------------------------"
echo ""

echo -e $green
echo "Associating table route RT-DS with subnet DB-Subnet"
echo -e $resetcolor
az network vnet subnet update --name ${subnets[1,name]} \
    --resource-group ${RGS[0,rgName]} \
    --vnet-name ${vNets[0,vNetName]} \
    --route-table $routeTable
echo "--------------------------------"
echo ""
