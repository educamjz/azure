#!/bin/bash

# Load script chapter 2
source ../chapter2/chapter2.sh

echo "Creating DNS Zone"
az network dns zone create -g ${RGS[0,rgName]} -n "cyberteach.site"
echo "--------------------------------"
echo ""

echo "Adding an A new record to the DNS Zone"
vmname="cloud-vma1"
publicIP=$(az vm list-ip-addresses -g ${RGS[0,rgName]} -n $vmname | jq -r '.[0].virtualMachine.network.publicIpAddresses[0].ipAddress')
az network dns record-set a add-record -g ${RGS[0,rgName]} -z cyberteach.site --record-set-name www --ipv4-address $publicIP
echo "--------------------------------"
echo ""
