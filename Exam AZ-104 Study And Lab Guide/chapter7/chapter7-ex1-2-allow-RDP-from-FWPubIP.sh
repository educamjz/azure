#!/bin/bash

# Load script
source ../data-infrastructure.sh

nameFW="AFWCloud"
vmname="cloud-vma3"

echo -e $green
echo "Adding DNAT Rule to allow inbound RDP traffic"
echo -e $resetcolor
publicIPFW=$(az network public-ip list -g ${RGS[1,rgName]} --query "[?ddosSettings.protectionMode=='VirtualNetworkInherited']" | jq -r '.[0].ipAddress')
privateIPvm=$(az vm list-ip-addresses -g ${RGS[1,rgName]} -n $vmname | jq -r '.[0].virtualMachine.network.privateIpAddresses[0]')
az network firewall policy rule-collection-group collection add-nat-collection \
    --collection-priority 300 \
    --ip-protocols TCP \
    --name "AllowInboundInternet" \
    --policy-name FWPolicy \
    --rcg-name "DefaultDnatRuleCollectionGroup" \
    --resource-group ${RGS[1,rgName]} \
    --action DNAT \
    --dest-addr $publicIPFW \
    --destination-ports 3389 \
    --rule-name "AllowInboundRDP" \
    --source-addresses "*" \
    --translated-address $privateIPvm \
    --translated-port 3389
echo "--------------------------------"
echo ""

echo -e $green
echo "Now connect using RDP to the IP $publicIPFW and test your outbound Internet connection trying to connect http://www.google.com."
echo "You must obtain in your browser a message like ..."
echo -e $resetcolor
echo "            'Action: Deny. Reason: No rule matched. Proceeding with default action.'"
echo -e $green
echo "Excute the script 'chapter7-ex1-3-allow-outbound-traffic.sh'"
echo -e $resetcolor
