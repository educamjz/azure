# Conexión Point-To-Site a un **File Share** de un **Storage Account** de Azure desde Ubuntu Linux usando una VPN.
## Notas
Esta prueba de concepto se basa en lo descrito en https://learn.microsoft.com/en-us/azure/storage/files/storage-files-configure-p2s-vpn-linux y https://learn.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-linux?tabs=smb311.

Tenemos que instalar previamente en la máquina Ubuntu Linux los siguientes paquetes:

```
sudo apt update
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
sudo apt install -y strongswan strongswan-pki libstrongswan-extra-plugins curl libxml2-utils libtss2-tcti-tabrmd0 strongswan-swanctl libcharon-extra-plugins cifs-utils unzip jq
```
Como se puede apreciar en el script ***"deploy-vnp-network-file-share.sh"***, usamos ***StrongSwan*** como VPN en Linux, y hacemos que el **File Share** solo sea accesible desde la IP pública que tenga nuestra máquina Linux.

El script está pensado para ser ejecutado con el usuario "root".

## Procedimiento
Ajustar la variables del script ***"deploy-vnp-network-file-share.sh"*** y ejecutarlo. Al final debe quedar montado el "file share" usando la conexión VPN definida.