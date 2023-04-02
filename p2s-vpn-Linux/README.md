# Conexión Point-To-Site a un File Share de un Storage Account de Azure desde Ubuntu Linux
## Notas
Este prueba de concepto se basa en lo descrito en https://learn.microsoft.com/en-us/azure/storage/files/storage-files-configure-p2s-vpn-linux

Hay que instalar previamente en la máquina Ubuntu Linux los siguientes paquetes:

```
sudo apt update
sudo  apt install strongswan strongswan-pki libstrongswan-extra-plugins curl libxml2-utils libtss2-tcti-tabrmd0 strongswan-swanctl libcharon-extra-plugins cifs-utils unzip
```