#!/bin/bash

RG1="RGCloud"
region1="eastus2"
VNet1="VNETCloud"
ScopeVNet1="10.1.0.0/16"
VNet1SNet1="Web-Subnet"
ScopeVNet1SNet1="10.1.1.0/24"
VNet1SNet2="DB-Subnet"
ScopeVNet1SNet2="10.1.2.0/24"
VNet1SNet3="DMZ-Subnet"
ScopeVNet1SNet3="10.1.3.0/24"
PubIP1="sipa"

RG2="RGOnPrem"
region2="centralus"
VNet2="VNetOnPrem"
ScopeVNet2="192.168.0.0/16"
VNet2SNet1="OnPrem-Subnet"
ScopeVNet2SNet1="192.168.1.0/24"

# Login to Azure account
echo "Login to Azure"
# az login --use-device-code
echo "--------------------------------"
echo ""

echo "Creating Resource Group Cloud"
az group create -l $region1 -n $RG1
echo "--------------------------------"
echo ""

echo "Creating Cloud Virtual Network"
az network vnet create \
    --resource-group $RG1 \
    --name $VNet1 \
    --location $region1 \
    --address-prefixes $ScopeVNet1
echo "--------------------------------"
echo ""

echo "Creating Web Subnet"
az network vnet subnet create \
    --resource-group $RG1 \
    --vnet-name $VNet1 \
    --name $VNet1SNet1 \
    --address-prefixes $ScopeVNet1SNet1
echo "--------------------------------"
echo ""

echo "Creating DB Subnet"
az network vnet subnet create \
    --resource-group $RG1 \
    --vnet-name $VNet1 \
    --name $VNet1SNet2 \
    --address-prefixes $ScopeVNet1SNet2
echo "--------------------------------"
echo ""

echo "Creating DMZ Subnet"
az network vnet subnet create \
    --resource-group $RG1 \
    --vnet-name $VNet1 \
    --name $VNet1SNet3 \
    --address-prefixes $ScopeVNet1SNet3
echo "--------------------------------"
echo ""

echo "Creating Public IP"
az network public-ip create \
    --resource-group $RG1 \
    --name $PubIP1 \
    --location $region1 \
    --dns-name "cloud-vma1" \
    --sku "Standard" \
    --tier "Regional" \
    --zone "1"
echo "--------------------------------"
echo ""

echo "Creating Resource Group Cloud"
az group create -l $region2 -n $RG2
echo "--------------------------------"
echo ""

echo "Creating On-Premise Virtual Network"
az network vnet create \
    --resource-group $RG2 \
    --name $VNet2 \
    --location $region2 \
    --address-prefixes $ScopeVNet2
echo "--------------------------------"
echo ""

echo "Creating OnPrem Subnet"
az network vnet subnet create \
    --resource-group $RG2 \
    --vnet-name $VNet2 \
    --name $VNet2SNet1 \
    --address-prefixes $ScopeVNet2SNet1
echo "--------------------------------"
echo ""
