# Contenido
Este script genera dos grupos de recursos en la región **"East US 2"**, en el primero de ellos, llamado **"RGCloud"**, creamos una red virtual (**"VNETCloud"**) con el ámbito ***10.1.0.0/16*** y tres subredes, la primera ("**Web-Subnet**") con el ámbito ***10.1.1.0/24***, la segunda (**"DB-Subnet"**) con el ámbito ***10.1.2.0/24***, y la tercera (**"DMZ-Subnet"**) con el ámbito ***10.1.3.0/24***. También creamos una IP pública llamada **"sipa"**.


El segundo grupo de recursos en la región **"Central US"**, llamado **"RGOnPrem"**, creamos una red virtual (**"VNetOnPrem"**) con el ámbito ***192.168.0.0/16***, que contiene una subred (**"OnPrem-Subnet"**) con el ámbito ***192.168.1.0/24***.

Recordemos que la región **"East US 2"** tiene como par a la región **"Central US"**.

El script v0 es una versión secuencial de la creación de los recursos mientras que el script v1 es una versión optimizada donde se define en unos arrays multidimensionales la topología que se quiere crear para luego crearla usando bucles "for".