# Estándares abiertos

Fomentan la competitividad y el progreso entre las marcas. Estas marcas generan sus estándares de internet que poco a poco la gente decide seguir para la buena compatibilidad entre dispositivos.

Para esto, además, existen unos estándares que promueven y mejoran los protocolos de internet ya existentes. Aquí destacan el IETF (para el mejoramiento) y el IRTF (para las investigaciones del futuro), el ICANN (para la gestión de los nombres de dominio) y el IANA (para la asignación de protocolos IP).

![[Ejemplo estándares de la red.png]]

Por otro lado lado, el IEEE  (Institute of Electrical and Electronics Engineers) es una organización que promueve la innovación y organiza estándares. Los ejemplos siguen y siguen...

# Modelos de capa

Se cuenta con 2, principalmente:

- Modelo OSI (Output System Interconnection).
- Modelo TCP/IP.

![[Ejemplo modelo multicapa.png]]

# Segmentación del mensaje

Los mensajes deben segmentarse para que puedan ser enviados por la red. Esto se hace mediante el protocolo TCP. Además, esto acelera la velocidad de envío y su fiabilidad, pues si un trocito del mensaje falla, no hace falta rehacer todo el envío, si no solo el trocito que falló.

El servidor, además, debe de contar con un sistema de secuenciación que le permita saber el orden en el que llegan los mensajes. Esto también se hace mediante el protocolo TCP.
