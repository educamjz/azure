#!/bin/bash

# Load script chapter 2
source ../chapter2/chapter2.sh

echo -e $green
echo "Creating DNS Zone"
echo -e $resetcolor
az network dns zone create -g ${RGS[0,rgName]} -n "cyberteach.site"
echo "--------------------------------"
echo ""

echo -e $green
echo "Adding an A new record to the DNS Zone"
echo -e $resetcolor
vmname="cloud-vma1"
publicIP=$(az vm list-ip-addresses -g ${RGS[0,rgName]} -n $vmname | jq -r '.[0].virtualMachine.network.publicIpAddresses[0].ipAddress')
az network dns record-set a add-record -g ${RGS[0,rgName]} -z cyberteach.site --record-set-name www --ipv4-address $publicIP
echo "--------------------------------"
echo ""
