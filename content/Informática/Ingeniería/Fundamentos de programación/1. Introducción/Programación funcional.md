Enlace: [[Fundamentos de programación.pdf#page=25]].

Este tipo de programación se caracteriza por el uso único de funciones para programar. Sobre todo funciones matemáticas. Un ejemplo de esto:

![[Ejemplo programación funcional.png]]

Entonces, una operación compuesta podría verse tal que así:

$$\text{Suma}(\text{Producto}(2, 4), \text{Diferencia}(7, 3))$$

Hay varias metodologías a la hora de programar de este modo. Mediante el proceso de cómputo llamado "reducción", se reemplaza cada función por el resultado de la misma, creando más pasos:

![[Reducción programación funcional.png]]

Por otro lado, se pueden definir nuevas fórmulas, como por ejemplo:

$$\texttt{Cuadrado (x) ::= Producto(x, x)}$$

Esta sería una fórmula compleja, pero mediante la reescritura, se podría retornar a la definición para usarla:

![[Reescritura programación funcional.png]]

