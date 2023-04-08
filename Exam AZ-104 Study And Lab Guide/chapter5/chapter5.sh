#!/bin/bash

# Load script chapter 4
source ../chapter4/chapter4.sh

echo -e $green
echo "Creating Bastion Subnet"
echo -e $resetcolor
az network vnet subnet create \
    --resource-group ${RGS[0,rgName]} \
    --vnet-name ${vNets[0,vNetName]} \
    --name "AzureBastionSubnet" \
    --address-prefixes "10.1.8.0/24"
echo "--------------------------------"
echo ""

echo -e $green
# Create Bastion Public IP
bastionPublicIP="VNETCloud-ip"
echo "Creating Bastion Public IP"
echo -e $resetcolor
az network public-ip create \
    --resource-group ${RGS[0,rgName]} \
    --name $bastionPublicIP \
    --location ${RGS[0,region]} \
    --sku "Standard" \
    --tier "Regional" \
    --zone "1"
echo "--------------------------------"
echo ""

echo -e $green
echo "Wait ..."
sleep 30
echo -e $resetcolor

echo -e $green
# Create Bastion Public IP
echo "Creating Bastion"
echo -e $resetcolor
az network bastion create --name "ABH" \
    --public-ip-address $bastionPublicIP \
    --resource-group ${RGS[0,rgName]} \
    --vnet-name ${vNets[0,vNetName]}
echo "--------------------------------"
echo ""

# Updating rule to access from Bastion
echo -e $green
echo "Updating rule to access from Bastion"
echo -e $resetcolor
sourceIPs=$(az network public-ip list -g ${RGS[0,rgName]} |  jq -r '.[1] | .ipAddress')
az network nsg rule update --name "InboundRDPAllow" \
    --resource-group ${RGS[0,rgName]} \
    --nsg-name $MyNsg \
    --source-address-prefixes $sourceIPs
echo "--------------------------------"
echo ""
