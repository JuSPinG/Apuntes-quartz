# Estandarización

A igual que en todos los lenguajes, hay que seguir unas normas para pasar de datos a información: de bits a carácteres, de caracteres a palabras que se convertirán en órdenes.

![[Encapsulamiento.png]]

Para esto hay que seguir un formateo y un encapsulamiento concreto. A igual que cuando mandamos un correo empezamos con uno saludo, seguimos con el mensaje que se quiere dar y se termina con una despedida; en redes, pasa lo mismo. El mensaje se debe de tratar y se le debe de dar ciertos parámetros extra para que no haya problema con el envío ¿A dónde irá esa caerta sin destinatario?

Por otro lado la velocidad es un factor clave. Los paquetes que se envían muy a menudo son demsiado grandes para enviarlos directamente, por lo que se debe de dividir dicho mensaje  en paquetes más pequeños. Esto se llama fragmentación.

Además, es importante establecer a quién o quienes se le envía el mensaje, a esto se le llama *unicast*: si es a una persona; *multicast*: si es a varias; *broadcast*: si va dirigido a todo el que escuche.

# *Suites* de protocolos

Son conjuntos de protocolos que se ayudan unos a otros para poder establecer una conexión eficiente. Normalmente se usa el *suite* de TCP/IP. Esta *suite* está compuesta por las siguientes capas:

- Aplicación:
  - HTTP.
  - DNS.
  - DHCP.
  - FTP.
- Transporte:
  - TPC.
  - UPD.
- Internet.
  - IPv4.
  - IPv6.
  - ICMPv4.
  - ICMPv6.
- Acceso a la red:
  - Ethernet.
  - ARP.
  - WLAN.