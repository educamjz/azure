#!/bin/bash

# Load script chapter 2
source ../chapter2/chapter2.sh

echo -e $green
echo "Identifying ID for ${vNets[0,vNetName]}"
echo -e $resetcolor
idVNEtCloud=$(az network vnet show \
    --resource-group ${RGS[0,rgName]} \
    --name ${vNets[0,vNetName]} \
    --query id \
    --out tsv)
echo $idVNEtCloud
echo "--------------------------------"
echo ""

echo -e $green
echo "Identifying ID for ${vNets[1,vNetName]}"
echo -e $resetcolor
idvNetOnPrem=$(az network vnet show \
  --resource-group ${RGS[1,rgName]} \
  --name ${vNets[1,vNetName]} \
  --query id \
  --out tsv)
echo $idvNetOnPrem
echo "--------------------------------"
echo ""

echo -e $green
echo "Creasting network peering from ${vNets[0,vNetName]} to ${vNets[1,vNetName]}"
echo -e $resetcolor
az network vnet peering create \
  --name "PeeringTovNetOnPrem" \
  --resource-group ${RGS[0,rgName]} \
  --vnet-name ${vNets[0,vNetName]} \
  --remote-vnet $idvNetOnPrem \
  --allow-vnet-access
echo "--------------------------------"
echo ""

echo -e $green
echo "Creasting network peering from ${vNets[1,vNetName]} to ${vNets[0,vNetName]}"
echo -e $resetcolor
az network vnet peering create \
  --name "PeeringToVNETCloud" \
  --resource-group ${RGS[1,rgName]} \
  --vnet-name ${vNets[1,vNetName]} \
  --remote-vnet $idVNEtCloud \
  --allow-vnet-access
echo "--------------------------------"
echo ""
