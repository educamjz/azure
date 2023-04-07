#!/bin/bash
green='\033[32m'
resetcolor='\033[0m'

# Load data infrastructure
source ../data-infrastructure.sh

# Login to Azure account
echo "Login to Azure"
az login --use-device-code
echo ""

# Loop to create Resource Groups
for ((i=0; i<$numRGS; i++))
do
  echo -e $green
  echo "Creating resource group '${RGS[$i,rgName]}' at ${RGS[$i,region]} region."
  echo -e $resetcolor
  az group create -l ${RGS[$i,region]} -n ${RGS[$i,rgName]}
done
echo ""

# Loop to create Virtual Networks
for ((i=0; i<$numVNets; i++))
do
  echo -e $green
  echo "Creating virtual network '${vNets[$i,vNetName]}' in resource group '${vNets[$i,rg]}' at ${vNets[$i,region]} region"
    echo -e $resetcolor
  az network vnet create --resource-group ${vNets[$i,rg]} \
    --name ${vNets[$i,vNetName]} \
    --location ${vNets[$i,region]} \
    --address-prefixes ${vNets[$i,cidr]}
done
echo ""

# Loop to create Subnets
for ((i=0; i<$numSubnets; i++))
do
  echo -e $green
  echo "Creating subnet '${subnets[$i,name]}' in resource group '${subnets[$i,rg]}' in ${subnets[$i,vnet]} virtual network"
  echo -e $resetcolor
  az network vnet subnet create --resource-group ${subnets[$i,rg]} \
    --vnet-name ${subnets[$i,vnet]} \
    --name ${subnets[$i,name]} \
    --address-prefixes ${subnets[$i,cidr]}
done

# Create Public IP
echo -e $green
echo "Creating Public IP"
echo -e $resetcolor
az network public-ip create \
    --resource-group ${RGS[0,rgName]} \
    --name "sipa" \
    --location ${RGS[0,region]} \
    --dns-name "cloud-vma1" \
    --sku "Standard" \
    --tier "Regional" \
    --zone "1"
echo "--------------------------------"
echo ""
