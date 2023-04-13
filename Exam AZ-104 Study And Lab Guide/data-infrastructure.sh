#!/bin/bash

# Colors
green='\033[32m'
resetcolor='\033[0m'

# Declare data structure using multidimensional arrays
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

