#!/bin/bash

# Load script chapter 3
source ../chapter3/chapter3.sh

echo "Creating NSG Cloud"
MyNsg="NSGCloud"
az network nsg create -g ${RGS[0,rgName]} -n $MyNsg
echo "--------------------------------"
echo ""

echo "Associating NSG Cloud to Web-Subnet"
az network vnet subnet update -g ${RGS[0,rgName]} -n ${subnets[0,name]} --vnet-name ${vNets[0,vNetName]} --network-security-group $MyNsg
echo "--------------------------------"
echo ""

echo "Creating inbound rule in NSG Cloud for RDP"
az network nsg rule create --name "InboundRDPAllow" \
                        --nsg-name $MyNsg \
                        --priority 100 \
                        --resource-group ${RGS[0,rgName]} \
                        --access Allow \
                        --destination-port-ranges 3389 \
                        --direction Inbound \
                        --protocol Tcp
echo "--------------------------------"
echo ""

echo "Creating inbound rule in NSG Cloud for HTTP"
az network nsg rule create --name "InboundHTTPAllow" \
                        --nsg-name $MyNsg \
                        --priority 110 \
                        --resource-group ${RGS[0,rgName]} \
                        --access Allow \
                        --destination-port-ranges 80 \
                        --direction Inbound \
                        --protocol Tcp
echo "--------------------------------"
echo ""

echo "Creating inbound rule in NSG Cloud for HTTP"
az network nsg rule create --name "InboundHTTPSAllow" \
                        --nsg-name $MyNsg \
                        --priority 120 \
                        --resource-group ${RGS[0,rgName]} \
                        --access Allow \
                        --destination-port-ranges 443 \
                        --direction Inbound \
                        --protocol Tcp
echo "--------------------------------"
echo ""
