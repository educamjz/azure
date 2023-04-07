# Contenido
Este script genera dos máquina virtuales, una en la región **"East US 2"** y otra en la región **"Central US"**.

A la primera máquina, en el proceso de creación, le asignamos la IP pública creada en el capítulo 1, mientras que a la segunda le asignamos una IP pública por defecto para luego recuperar el nombre del recurso y asignarle el nombre DNS de la máquina.

En la primera desplegamos IIS y comprobamos que podemos acceder al mismo. También le añadimos un segundo disco de 4GB de capacidad.

Creamos también un conjunto de disponibilidad donde se asigna la segunda máquina creada.

Para ambas máquina abrimos los puertos 80 y 443.

Podemos crear de nuevo toda la infrastructura que se crea en el capítulo 1 ejecutando este script ya que incluye a través del comando "source" al principio del mismo el contenido del script de ese capítulo.
