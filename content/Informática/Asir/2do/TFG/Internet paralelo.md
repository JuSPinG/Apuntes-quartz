# Historia

El Gobierno del INGSOC ha instaurado una dictadura terrible. Un grupo de rebeldes ha decidido montar una revista filosófica para desestabilizar el gobierno, pero ha decidido ocultarla para saltarse la censura.

# Esquema de la red
## Ejemplo hipotético de conexión

Un cliente quiere entrar a la página web [filosofiaprohibida.rebel](filosofiaprohibida.rebel), para ello, ha configurado un DNS primario alternativo. En vez de usar los típicos oficiales como los de su ISP, 8.8.8.8 o 1.1.1.1, ha especificado otra IP distinta.

Al hacerlo, y al buscar dicha página web, en vez de acceder directamente al servidor donde se alojan, pregunta a este DNS alternativo que, gracias a un registro A, le indica que la web que está buscando se encuentra en otra red distinta. Y una vez que llega, puede acceder a la web de [filosofiaprohibida.rebel](filosofiaprohibida.rebel), que se aloja en una DMZ (evidentemente) junto con un Windows Server 2019 que posee roles de DHCP y DNS. Debajo de esta DMZ se encuentran algunos equipos de la organización.

Aunque no lo sabemos muy bien, puede que el servidor DNS alternativo, que también se encuentre en una DMZ, comparta red junto con un servidor VPN, al que únicamente los clientes de la otra DMZ podrán conectarse para administrar dicho DNS.
## Esquema topográfico

1. "Cliente Externo" se conecta a "Internet 1" (público).
	1. "Router 1".
	2. "Firewall 1".
	3. "DMZ 1".
		1. "Servidor VPN".
		2. "Servidor DNS 1".
2. "Cliente externo" se conecta al nuevo espacio de nombres de "Internet 2" (oculto) por petición del DNS.
	1. "Router 2.1".
	2. "Firewall 2".
	3. "DMZ 2".
		1. "Servidor Web": presenta la página web prohibida.
		2. "Windows server 2019".
			1. "Servidor DHCP".
			2. "Servidor DNS 2".
	4. "Switch 2.1".
	5. "Router 2.2": Entrada en la LAN.
	6. "Switch 2.2".
		1. "Cliente 1": con posibilidad de conectarse a la "Servidor VPN".
		2. "Cliente N".

![[Esquema de red para una doble DMZ.png]]

En realidad, Internet solo hay uno, los espacios de nombres, al crear una nueva capa abstracta, es posible subdividir los accesos tantas veces como nos de la gana.