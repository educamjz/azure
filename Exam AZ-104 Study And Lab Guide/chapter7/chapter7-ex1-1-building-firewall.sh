#!/bin/bash

# Load script chapter 5
source ../chapter5/chapter5.sh

# Create Firewall Subnet
echo -e $green
echo "Creating Firewall Subnet"
echo -e $resetcolor
az network vnet subnet create \
    --resource-group ${RGS[1,rgName]} \
    --vnet-name ${vNets[1,vNetName]} \
    --name "AzureFirewallSubnet" \
    --address-prefixes "192.168.10.0/24"
echo "--------------------------------"
echo ""

# Create Firewall
nameFW="AFWCloud"
echo -e $green
echo "Creating Firewall"
echo -e $resetcolor
az network firewall create \
    --name $nameFW \
    --resource-group ${RGS[1,rgName]} \
    --tier Premium \
    --location ${RGS[1,region]}
echo "--------------------------------"
echo ""

# Create Firewall Policy
echo -e $green
echo "Creating Firewall Policy"
echo -e $resetcolor
az network firewall policy create --name "FWPolicy" \
    --resource-group ${RGS[1,rgName]}
echo "--------------------------------"
echo ""

# Create Firewall Public IP
echo -e $green
echo "Creating Firewall Public IP"
echo -e $resetcolor
az network public-ip create \
    --name FWPIP \
    --resource-group ${RGS[1,rgName]} \
    --location ${RGS[1,region]} \
    --allocation-method static \
    --sku standard
echo "--------------------------------"
echo ""

# Create Firewall Configuration
echo -e $green
echo "Creating Firewall Configuration"
echo -e $resetcolor
az network firewall ip-config create \
     --firewall-name $nameFW \
     --name FWPIP \
     --public-ip-address FWPIP \
     --resource-group ${RGS[1,rgName]} \
     --vnet-name ${vNets[1,vNetName]}

az network firewall update \
    --name $nameFW \
    --resource-group ${RGS[1,rgName]} \
    --firewall-policy FWPolicy
echo "--------------------------------"
echo ""

echo -e $green
echo "Creating route table RT-OPS"
echo -e $resetcolor
routeTable="RT-OPS"
az network route-table create --name $routeTable \
    --resource-group ${RGS[1,rgName]} \
    --disable-bgp-route-propagation no \
    --location ${RGS[1,region]}
echo "--------------------------------"
echo ""

echo -e $green
echo "Adding route to Internet in route table RT-OPS"
echo -e $resetcolor
fwprivaddr="$(az network firewall ip-config list -g ${RGS[1,rgName]} -f $nameFW --query "[?name=='FWPIP'].privateIpAddress" --output tsv)"
az network route-table route create --name "RouteToInternet" \
    --resource-group ${RGS[1,rgName]} \
    --route-table-name $routeTable \
    --address-prefix "0.0.0.0/0" \
    --next-hop-ip-address $fwprivaddr \
    --next-hop-type VirtualAppliance
echo "--------------------------------"
echo ""

echo -e $green
echo "Associating table route RT-OPS with subnet OnPrem-Subnet"
echo -e $resetcolor
az network vnet subnet update --name ${subnets[3,name]} \
    --resource-group ${RGS[1,rgName]} \
    --vnet-name ${vNets[1,vNetName]} \
    --route-table $routeTable
echo "--------------------------------"
echo ""

echo -e $green
echo "Creating Rule Collection Group (DNAT type)"
echo -e $resetcolor
az network firewall policy rule-collection-group create --name "DefaultDnatRuleCollectionGroup" \
     --policy-name FWPolicy \
     --priority 300 \
     --resource-group ${RGS[1,rgName]}
echo "--------------------------------"
echo ""

echo -e $green
echo "Creating Rule Collection Group (Network type)"
echo -e $resetcolor
az network firewall policy rule-collection-group create --name "DefaultNetworkRuleCollectionGroup" \
     --policy-name FWPolicy \
     --priority 200 \
     --resource-group ${RGS[1,rgName]}
echo "--------------------------------"
echo ""

echo -e $green
echo "Now, try to connect using RDP to the public IP of 'cloud-vma3'."
echo "You could see that you cannot connect."
echo "Excute the script 'chapter7-ex1-2-allow-RDP-from-FWPubIP.sh'."
echo -e $resetcolor