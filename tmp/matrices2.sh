#!/bin/bash
green='\033[32m'
resetcolor='\033[0m'

# Data structures defining resources that must be created
numRGS=2
declare -A RGS=(
  [0,rgName]="RGCloud"
  [0,region]="eastus2"
  [1,rgName]="RGOnPrem"
  [1,region]="centralus"
)

numVNets=2
declare -A vNets=(
  [0,rg]=${RGS[0,rgName]}
  [0,region]=${RGS[0,region]}
  [0,vNetName]="VNETCloud"
  [0,cidr]="10.1.0.0/16"
  [1,rg]=${RGS[1,rgName]}
  [1,region]=${RGS[1,region]}
  [1,vNetName]="vNetOnPrem"
  [1,cidr]="192.168.0.0/16"
)

numSubnets=4
declare -A subnets=(
  [0,rg]=${RGS[0,rgName]}
  [0,vnet]=${vNets[0,vNetName]}
  [0,name]="Web-Subnet"
  [0,cidr]="10.1.1.0/24"
  [1,rg]=${RGS[0,rgName]}
  [1,vnet]=${vNets[0,vNetName]}
  [1,name]="DB-Subnet"
  [1,cidr]="10.1.2.0/24"
  [2,rg]=${RGS[0,rgName]}
  [2,vnet]=${vNets[0,vNetName]}
  [2,name]="DMZ-Subnet"
  [2,cidr]="10.1.3.0/24"
  [3,rg]=${RGS[1,rgName]}
  [3,vnet]=${vNets[1,vNetName]}
  [3,name]="OnPrem-Subnet"
  [3,cidr]="192.168.1.0/24"
)

# Bucle creating resouce groups
for ((i=0; i<$numRGS; i++))
do
  echo -e $green
  echo "Creating resource group '${RGS[$i,rgName]}' at ${RGS[$i,region]} region."
  echo -e $resetcolor
  echo  "az group create -l ${RGS[$i,region]} -n ${RGS[$i,rgName]}"
done
echo ""

# Bucle creating virtual networks
for ((i=0; i<$numVNets; i++))
do
  echo -e $green
  echo "Creating virtual network '${vNets[$i,vNetName]}' in resource group '${vNets[$i,rg]}' at ${vNets[$i,region]} region"
    echo -e $resetcolor
  echo "az network vnet create --resource-group ${vNets[$i,rg]} --name ${vNets[$i,vNetName]} --location ${vNets[$i,region]} --address-prefixes ${vNets[$i,cidr]}"
done
echo ""

# Bucle creating subnets
for ((i=0; i<$numSubnets; i++))
do
  echo -e $green
  echo "Creating subnet '${subnets[$i,name]}' in resource group '${subnets[$i,rg]}' in ${subnets[$i,vnet]} virtual network"
  echo -e $resetcolor
  echo "az network vnet subnet create --resource-group ${subnets[$i,rg]} --vnet-name ${subnets[$i,vnet]} --name ${subnets[$i,name]} --address-prefixes ${subnets[$i,cidr]}"
done
