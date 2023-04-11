#!/bin/bash

# Load script
source ../data-infrastructure.sh

nameFW="AFWCloud"
vmname="cloud-vma3"

echo -e $green
echo "Adding network rule to allow outbound Internet traffic"
echo -e $resetcolor
privateIPvm=$(az vm list-ip-addresses -g ${RGS[1,rgName]} -n $vmname | jq -r '.[0].virtualMachine.network.privateIpAddresses[0]')
az network firewall policy rule-collection-group collection add-filter-collection \
    -g ${RGS[1,rgName]} \
    --policy-name FWPolicy \
    --rule-collection-group-name "DefaultNetworkRuleCollectionGroup" \
    --name "AllowOutboundHTTP" \
    --action Allow \
    --rule-name "OutboundHTTP" \
    --rule-type NetworkRule \
    --destination-addresses '*' \
    --source-addresses $privateIPvm \
    --destination-ports 80 443 \
    --ip-protocols TCP \
    --collection-priority 200
echo "--------------------------------"
echo ""

echo -e $green
echo "Test your outbound Internet connection from 'cloud-vma3' trying to connect http://www.google.com."
echo "You must connect to Google with no problem."
echo -e $resetcolor