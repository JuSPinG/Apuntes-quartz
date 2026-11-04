La informática intenta representar los elementos de la realidad mediante los datos. El sonido de una campana es imposible de replicar de forma exacta, como nuestros sentidos no son perfectos, las aproximaciones informáticas bastan para engañar al sujeto.

A la hora de crear una base de datos, los ficheros que se guardan son:

- Secuenciales.
	- Se usaba antiguamente.
	- Se podía guardar en texto.
	- Su secuencialidad le obliga a ir elementos por elemento; para ir a la canción 3, hay que pasar por la 1 y la 2.
	- No se permite el retroceso, para volver a atrás hay que reiniciar el sistema.
	- El acceso es monousuario, de uno en uno.
	- Para añadir o editar un registro, hay que reescribir los demás.
	- Muy eficiente en el uso del espacio.
- Acceso aleatorio.
	- Aparece en sistemas con disquetes y discos duros.
	- Todos los archivos **deben** ocupar lo mismo.
	- Todos los datos almacenados del mismo tipo deben ocupar lo mismo (en bytes); "Nombre: 20 caracteres", si no, se «trunca» el dato.
	- Cálculo de la posición del registro:
		- $Pos = NumRegistro \cdot LongitudRegistro$
		- En un sistema de 230 bytes, el 4º registro se encuentra en la posición 920.
	- Permite el multiusuario.
	- Fácil borrado de registros.
	- Registros de longitud fija.
- Archivos indexados.