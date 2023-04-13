#!/bin/bash

# Load script
source ../data-infrastructure.sh

nameFW="AFWCloud"
vmname="cloud-vma3"
publicIPFW=$(az network public-ip list -g ${RGS[1,rgName]} --query "[?ddosSettings.protectionMode=='VirtualNetworkInherited']" | jq -r '.[0].ipAddress')
privateIPvm=$(az vm list-ip-addresses -g ${RGS[1,rgName]} -n $vmname | jq -r '.[0].virtualMachine.network.privateIpAddresses[0]')

echo -e $green
echo "Creating Rule Collection Group (Application type)"
echo -e $resetcolor
az network firewall policy rule-collection-group create --name "DefaultApplicationRuleCollectionGroup" \
     --policy-name FWPolicy \
     --priority 300 \
     --resource-group ${RGS[1,rgName]}
echo "--------------------------------"
echo ""

echo -e $green
echo "Adding application rule to allow outbound Internet traffic"
echo -e $resetcolor
az network firewall policy rule-collection-group collection add-filter-collection \
    --collection-priority 300 \
    --name "OutboundInternet" \
    --policy-name FWPolicy \
    --rcg-name "DefaultApplicationRuleCollectionGroup" \
    --resource-group ${RGS[1,rgName]} \
    --action Allow \
    --enable-tls-insp false \
    --protocols Http=80 Https=443 \
    --rule-name "OutboundHTTP" \
    --rule-type ApplicationRule \
    --source-addresses $privateIPvm \
    --target-fqdns '*'
echo "--------------------------------"
echo ""

echo -e $green
echo "Test your outbound Internet connection from 'cloud-vma3' trying to connect http://www.google.com."
echo "You must connect to Google with no problem."
echo -e $resetcolor
