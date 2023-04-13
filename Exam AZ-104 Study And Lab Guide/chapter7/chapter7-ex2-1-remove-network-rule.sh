#!/bin/bash

# Load script
source ../data-infrastructure.sh

nameFW="AFWCloud"
vmname="cloud-vma3"
publicIPFW=$(az network public-ip list -g ${RGS[1,rgName]} --query "[?ddosSettings.protectionMode=='VirtualNetworkInherited']" | jq -r '.[0].ipAddress')

echo -e $green
echo "Deleting network rule to allow outbound Internet traffic"
echo -e $resetcolor
az network firewall policy rule-collection-group collection rule remove \
    --collection-name "AllowOutboundHTTP" \
    --name  "OutboundHTTP" \
    --policy-name FWPolicy \
    --rcg-name "DefaultNetworkRuleCollectionGroup" \
    --resource-group ${RGS[1,rgName]}
echo "--------------------------------"
echo ""

echo -e $green
echo "Deleting network rule collection"
echo -e $resetcolor
az network firewall policy rule-collection-group collection remove \
    --name "AllowOutboundHTTP" \
    --policy-name  FWPolicy \
    --rcg-name "DefaultNetworkRuleCollectionGroup" \
    --resource-group ${RGS[1,rgName]}
echo "--------------------------------"
echo ""

echo -e $green
echo "Removing Rule Collection Group (Network type)"
echo -e $resetcolor
az network firewall policy rule-collection-group delete \
    --name "DefaultNetworkRuleCollectionGroup" \
    --policy-name FWPolicy \
    --resource-group ${RGS[1,rgName]}
echo "--------------------------------"
echo ""

echo -e $green
echo "Now connect using RDP to the IP $publicIPFW and test your outbound Internet connection trying to connect http://www.google.com."
echo "You must obtain in your browser a message like ..."
echo -e $resetcolor
echo "            'Action: Deny. Reason: No rule matched. Proceeding with default action.'"
echo -e $green
echo "Excute the script 'chapter7-ex2-2-allow-outbound-traffic-through-app-rule.sh'"
echo -e $resetcolor