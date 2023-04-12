# Contenido
Con este conjunto de scripts creamos un ***"Azure Firewall"*** y practicamos con el uso de diferentes características del mismo (Reglas DNAT, de red, de aplicación, y "threat Intelligence"), incluidas las características ***"Premium"***.

Podemos crear de nuevo toda la topología creada en los capítulos 1 y 2, que es la necesaria para desplegar el ***Azure Firewall***, ejecutando el primer script ya que incluye a través del comando "source" al principio del mismo el contenido del script del capítulo 2.

Empezaremos con el ejercicio 1, ejecutando el script ***"chapter7-ex1-1-building-firewall.sh"***, que como su nombre indica nos ayudará a construir el ***"Firewall"***, seguiremos con la ejecución del script ***"chapter7-ex1-2-allow-RDP-from-FWPubIP.sh"***, que nos permitirá recuperar a través de una regla DNAT la conexión RDP que hemos perdido contra la máquina ***"cloud-vma3"*** al construir con el primer script el ***"Firewall"***, y por último ejecutaremos el script ***"chapter7-ex1-3-allow-outbound-traffic.sh"***, que nos permitirá desde dentro de la máquina ***"cloud-vma3"*** acceder con el navegador a https://www.google.com.

**NOTA: El capítulo aún no está concluido**.
