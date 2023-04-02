# Conexión Point-To-Site a un **File Share** de un **Storage Account** de Azure desde Ubuntu Linux usando una VPN.
## Notas
Este prueba de concepto se basa en lo descrito en https://learn.microsoft.com/en-us/azure/storage/files/storage-files-configure-p2s-vpn-linux

Hay que instalar previamente en la máquina Ubuntu Linux los siguientes paquetes:

```
sudo apt update
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
sudo apt install strongswan strongswan-pki libstrongswan-extra-plugins curl libxml2-utils libtss2-tcti-tabrmd0 strongswan-swanctl libcharon-extra-plugins cifs-utils unzip
```

## Procedimiento
Crear primero la CA usando 'createRootCA.sh'. A continuación ejecutar 'despliegue-red-vnp-file-share.sh', esperar a que se cree la infrastructura y se descarge el client VPN, descomprimir el fichero 'vpnClient.zip' generado y descargado por el script anterior, y finalmente ejecutar el script 'config-vpn-linux.sh'.

Una vez hecho esto hacer.
```
ipsec restart
ipsec up azure
```
Esto debería levantar el túnel VPN contra Azure.