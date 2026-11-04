# Introducción, de *Hub* 

Cuanto más grande se hacían las redes, más al colapso tendía. Entre el cable coaxial y el UTP se usaba un aparatito llamado *bridge*, lo que acabó evolucionando en un Swithc, y se acabaron usando para unir cableado y transito de datos. El Switch mantiene aislado los dominios de conexión, y con el tiempo, se le fueron implementando más puertos.

# El proceso de la tabla

Cada vez que un Switch recive una trama, apunta su respectiva dirección MAC y la asocia con su puerto, luego, cuando otro dispositivo envía otro dato, el Switch puede ser más rápida reenviándola. Ahora, si un dispositivo envía una trama al Switch y este no tiene apuntado la MAC, lo reenvía a todos los puertos, excepto a los que tiene apuntado en la tabla. Los dispotivos que reciven tramas que no le corresponden, las deniegan, y el dispositivo que responda, será apuntado por el Switch.

# Ventajas y desventajas del uso de la tabla

De esta forma, el proceso del enrutamiento y procesamiento de tramas, se hace más sencillo, eficiente, el ancho de banda no se reparte, los dispotivos se vuelven *full duplex*, y se reducen los dominios de colisión.

De todas formas, hay una desventaja clave. La tabla es finita, y si se llena, puede causar severos problemas. Más tarde se explicará cómo se solucionan dichos problemas.