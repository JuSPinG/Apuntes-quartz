# Introducción

La capa de enlace de datos se encarga de la transimisón de los datos dentro de una red local.

Tenemos que hacer que la capa de enlace conecte los datos entre todos los dispositivos. Entre una capa y otra, se necesitan PDUs (Protocol Data Unit), que son los datos que se envían entre las capas.

El proceso suele ser el siguiente:

- El ordenador crea un paquete.
- Dicho paquete se mete en una trama de Ethernet para eviarsela al router.
- Ahora, supongamos, que ese routes se lo envía a otro routes.
- Que finalmente, lo manda por fibra óptica al servisdor.

# Diferentes capas

- Subcapa de control de acceso al medio
- Subcapa de control del enlace lógico (LLC)

El protocolo TCP/IP es único, pero interfaces NIC hay un montón, por eso se requiere un control de acceso.