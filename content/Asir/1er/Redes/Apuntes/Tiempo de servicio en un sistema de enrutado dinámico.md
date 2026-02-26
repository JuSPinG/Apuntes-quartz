Un router tarda en transmitir $p$ bits a una velocidad de $v-c$ bits/s, donde $v$ es la velocidad de transmisión y $c$ es el caudal previamente ocupado del router, una cantidad $t_s$ de segundos. Así se expresa en la siguiente fórmula:

$$t_s=\frac{p}{v-c}$$

Por lo que la latencia que una trama sufre al pasar de un router a otro se calcula mediante un sumatorio:

$$T_{\text{total}}=\sum^{n}_{i=1}\frac{p}{v_i-c_i}$$

Mas la latencia del enlace teórica normalmente se corresponde con el valor de $v_i-c_i$ más bajo, pues, por ejemplo, si un caudal muy ancho pasa por un río, y de repente las paredes se estrechan sobremanera, el agua que pasará a partir de ese momento no será más que la que el estrechez permitió, independientemente de los ulteriores ensanches.

Por último, el tiempo de servicio medio equivale a la siguiente fórmula:

$$\bar t_s=\frac{\sum^n_{i=1}c_i\cdot t_i}{\sum^n_{i=1}t_i}$$

Además, esto coincide con la definición de media ponderada.