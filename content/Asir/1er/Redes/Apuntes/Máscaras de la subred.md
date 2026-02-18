Todos los equipos con IP, también tienen una máscara. Una máscara tiene siempre el siguiente formato:

$$\texttt{XXXX.YYYY.ZZZZ.0000}$$

Donde X, Y y Z puede ser 0 o 1.

Por eso, a menudo, se representan las IPs a las que les sigue una barra lateral idicando cuántos unos tiene: `192.168.1.42/24` (24 unos).

La IPv4 127.*.*.* y la IPv6 ::1 son las únicas direcciones IP que no tienen una máscara, son las locales del equipo. Es decir, hay 16 millonoes de IPsv4 que sirven para designarnos a nosotros mismos.

Por lo tanto, tenemos `localhost`, dispositivos en la misma red, y dispositivos en otra red. Para conectarnos a otra red, necesitamos un *default gateway*. Para que todo esto funciones bien, se requiere que el *router* tenga una tabla de enrutamiento.