Con `ls -all` podemos ver los permisos asociados a los distintos usuarios.

Con `chmod {numeritos} {archivo/carpeta}`, se usa 777 para obtener los máximos permisos. En la siguiente imagen, se ha ejecutado `chmod 777 recursos`.

![[Ejemplo ls -l.png]]

Los permisos se dividen cada 3 caracteres que pueden ser los siguiente: `r`, de lectura; `w`, de escritura; `x`, de ejecución y entrada al directorio. El primer grupo de caracteres se refieren a creador de la carpeta, el segundo, se refiere al grupo al que pertenece la carpeta, por último, el tercero refiere a el resto de usuarios.