installDir="/etc/1"
rootCertName="P2SRootCertLinux"
username="client"
password="12345678"

vpnServer=$(xmllint --xpath "string(/VpnProfile/VpnServer)" Generic/VpnSettings.xml)
vpnType=$(xmllint --xpath "string(/VpnProfile/VpnType)" Generic/VpnSettings.xml | tr '[:upper:]' '[:lower:]')
routes=$(xmllint --xpath "string(/VpnProfile/Routes)" Generic/VpnSettings.xml)

sudo cp "${installDir}ipsec.conf" "${installDir}ipsec.conf.backup"
sudo cp "Generic/VpnServerRoot.cer_0" "${installDir}ipsec.d/cacerts"
sudo cp "${username}.p12" "${installDir}ipsec.d/private" 

sudo tee -a "${installDir}ipsec.conf" <<EOF
conn azure
    keyexchange=$vpnType
    type=tunnel
    leftfirewall=yes
    left=%any
    leftauth=eap-tls
    leftid=%client
    right=$vpnServer
    rightid=%$vpnServer
    rightsubnet=$routes
    leftsourceip=%config
    esp=aes256gcm16,aes128gcm16!
    auto=add
EOF

echo ": P12 $username.p12 '$password'" | sudo tee -a "${installDir}ipsec.secrets" > /dev/null
