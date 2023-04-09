# Contenido
En este script creamos dos tablas de rutas, una la asociaremos a la ***Web-Subnet*** y otra a la ***DB-Subnet***.

Crearemos también una nueva VM en la ***DMZ-Subnet*** que usaremos como pivote (habilitaremos **IP Forwarding** en su interfaz de red privada)entre las dos subredes Web y DB gracias a dos rutas que también crearemos, respectivamente, en las tablas de rutas creadas previamente usando como **Next hop address** en ambos casos la IP de esta VM. Para que todo funcione correctamente deberemos habilitar en esta VM ***IP Forwarding*** cosa que haremos ejecutando el comando ***PowerShell** siguiente: **"Get-NetAdapter | Set-NetIPInterface -Forwarding Enabled"**.

Podemos crear de nuevo toda la topología creada en los capítulos 1, 2, 3, 4 y 5 ejecutando este script ya que incluye a través del comando "source" al principio del mismo el contenido del script del capítulo 5.