# Instalación

Instalamos con:

```sh
sudo apt install redis-server -y
sudo systemctl start redis-server.service 
sudo systemctl enable redis-server.service 
sudo systemctl status redis-server.service 
```

Accedemos con:

```sh
redis-cli
```

Comprobamos la conexión:
```sql
ping
```

Seleccionar una base de datos específia:
```sql
exit
redis-cli -n 1
```

Salimos y entramos en la 1, vaya.

# Gestión de datos
## Simple

Crear una clave y asignarle un valor:
```sql
SET raul_valle 40
```

Y para cargar el dato:
```sql
GET raul_valle
```

Y podemos eliminarlo con `DEL`:

```sql
DEL raul_valle
```

Veremos que nos devuelve un 1, es decir, se ha eliminado exitosamente.

Y ahora podemos comprobar si existe:
```sql
EXISTS raul_valle
```

Veremos que nos devuelve un 0, es decir, no existe.

También podemos crear variables que expiren:
```sql
SETEX sancha 20 "Amigo"
```

Con:
```sql
TTL sancha
```

Podemos ver cuánto tiempo le queda antes de desaparecer, como hemos elegido 20 segundos, puede que ya sea demasiado tarde.

También renombrar el nombre de una variable:
```sql
RENAME sancha gerardo
```

## Compuesta
### Listas

Las listas se manejan con las siguientes instrucciones:

```sql
LPUSH amigos "gerardo"
```

Eso mete los elementos a la izquierda ("L" de _left_). Para meterlos a la derecha podemos usar `RPUSH`. Podemos obtener subconjuntos de dicha lista:

```sql
LRANGE amigos 0 -1
```

Indexarla, vaya. Esto equivale en [[Python]] a `amigos[0:-1]`.

Con `LPOP` o `RPOP` obtenemos y eliminamos el elementos seleccionado. Recuerda un poco a la gestión de memoria de Rust:

```sql
LPOP amigos
```

Por último, con `LLEN` obtenemos la cantidad de elementos en la lista:

```sql
LLEN amigos
```

### Otros tipos

Hay varios, como:

1. Sets (conjuntos).
2. Hashes.

# Gestión de la base

Podemos cambiar de base de datos con:

```sql
SELECT {número}
```

Y con:

```sql
KEYS *
```

Podemos ver su contenido rápidamente. Con:

```sql
FLUSHDB
```

Borramos todo. Con `INFO` o `MONITOR` podemos ver estadísticas de la base de datos. Con `CONFIG GET/SET` obtenemos o modificamos las variables de entorno. 

Por último:

 Para forzar la creación de un _snapshot_:

```sql
SAVE
```

 Y para realizar una copia asincrónica:

```sql
BGSAVE
```