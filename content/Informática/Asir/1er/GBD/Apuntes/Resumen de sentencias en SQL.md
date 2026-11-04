# Creación y manipulación de tablas

- `CREATE TABLE`: Define una nueva tabla con columnas y tipos de datos.
- ``PRIMARY KEY``: Clave primaria para identificar registros únicos.
- `AUTOINCREMENT`: Aumenta secuencialmente un campo entero por cada sentencia.
- ``INSERT INTO``: Añade filas a la tabla con valores específicos.

## Ejemplo

```sql
-- Crear tabla con clave primaria autoincremental
CREATE TABLE personas (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nombre VARCHAR(50),
	apellido VARCHAR(50),
	edad INTEGER
);

-- Insertar una fila
INSERT INTO personas (nombre, apellido, edad) VALUES
	('Ana', 'Saénz', 17);

-- Insertar múltiples filas
INSERT INTO personas (nombre, apellido, edad) VALUES
	('Luis', 'Martínez', 25),
	('María', 'Gómez', 30),
	('Carlos', 'López', 22);
```

---
# Filtros y selección de datos

- ``SELECT``: Extrae datos de una o varias tablas.
- ``WHERE``: Condiciones para filtrar filas.
- ``AND / OR``: Combinar condiciones.
- ``BETWEEN``: Para rangos (fechas, números).
- ``LIKE``: Búsqueda con patrones, usando "\%" para varios caracteres y "\_" para uno solo.
- ``DISTINCT``: Muestra valores únicos sin repetir.

## Ejemplo

```sql
-- Seleccionar personas mayores de 20 años
SELECT * FROM personas WHERE edad > 20;

-- Seleccionar personas con nombre que empieza con 'A'
SELECT * FROM personas WHERE nombre LIKE 'A%';

-- Seleccionar edades únicas
SELECT DISTINCT edad FROM personas ORDER BY edad ASC;
```

---
# Ordenamiento y límite

- ``ORDER BY``: Ordena el resultado por una o más columnas.
- ``ASC``: para ascendente (por defecto)  
- ``DESC``: para descendente  
- ``LIMIT``: Limita el número de filas resultantes (no mostrado en tus ejemplos, pero útil)  

## Ejemplo

```sql
-- Ordenar por edad ascendente
SELECT nombre, edad FROM personas ORDER BY edad ASC;

-- Obtener las 2 personas más jóvenes
SELECT nombre, edad FROM personas ORDER BY edad ASC LIMIT 2;
```

---
# Funciones numéricas y de fecha

- Funciones numéricas:  
	- ``ROUND(valor, decimales)``: redondea.
	- Operaciones básicas: +, -, *, /.
	- ``SQRT(valor)``: raíz cuadrada.
- Funciones de fecha:  
	- ``YEAR(fecha)``, ``MONTH(fecha)``, ``DAY(fecha)``: para extraer partes de la fecha.
	- ``CURDATE()``: para la fecha actual.
	- Comparaciones con fechas (por ejemplo, para encontrar nacimientos en un rango o signo zodiacal).

## Ejemplo

```sql
-- Calcular la edad basada en el año de nacimiento
SELECT nombre, (YEAR(CURDATE()) - YEAR(fecha_nacimiento)) AS edad FROM personas;

-- Seleccionar personas nacidas en mayo
SELECT nombre FROM personas WHERE MONTH(fecha_nacimiento) = 5;
```

---
# Manipulación de texto ``VARCHAR``

- Funciones comunes:  
	- ``LENGTH(campo)``: longitud del texto.
	- ``CONCAT(a, b, c)``: concatenar textos.
	- ``SUBSTRING(campo, inicio, longitud)``: extraer parte de un texto.
	- ``UPPER()``, ``LOWER()``: mayúsculas/minúsculas.
	- ``LIKE '%letra%'``: buscar texto que contenga una letra.

## Ejemplo

```sql
-- Seleccionar nombres en mayúsculas
SELECT UPPER(nombre) FROM personas;

-- Concatenar nombre completo
SELECT CONCAT(nombre, ' ', apellido) AS nombre_completo FROM personas;

-- Extraer las primeras 3 letras del apellido
SELECT SUBSTRING(apellido, 1, 3) FROM personas;
```

## Apuntes sobre el `like`

Posiblemente, la sentencia ``like`` sea de las más poderosas a la hora de hacer búsquedas, pues permite de forma sencilla el manejo de la expresiones regulares. Estas son sus propiedades:

1. Búsquedas con "%": Este signo permite especifica que hay, al menos, un carácter ocupando esa posición. Equivale a "aquí hay cualquier cosa, pero haber la hay".
2. Búsquedas con carácteres concretos: Colocar dentro de las comillas un carácter establece que la búsqueda cumpla con la contención de este, según la posición especificada.
3. Búsquedas con "\_": Especifica que en esa posición hay un  carácter, aunque no se establece cual.
4. Búsquedas con "\[": Especifica un conjunto donde como mínimo uno de sus elementos cumple la restricción.
5. Búsquedas con "^" o "NOT LIKE": Niega elementos del filtro del búsqueda, o niega el filtro de búsqueda (para hacer búsquedas invertidas) en su totalidad.
6. Búsquedas con "-": Establece un rango, principalmente de carácteres.

| Ejemplos |                 ``%``                 |                   `e`                   |                        `_`                         |                          `[]`                          |                           `^`                            |                      `-`                      |
| -------: | :-----------------------------------: | :-------------------------------------: | :------------------------------------------------: | :----------------------------------------------------: | :------------------------------------------------------: | :-------------------------------------------: |
|      `%` |        `%%`:  cualquier cadena        |   `%e`:  cadenas que terminan en "e"    | `%_`:  cadenas que terminan con cualquier carácter |             `%[ae]%`:  contienen "a" o "e"             |            `%[^ae]%`:  no contiene "a" o "e"             |   `%[a-z]%`:  contienen cualquier minúscula   |
|      `a` |  `a%`: cadenas que empiezan con "a"   |      `ae`:  solo coincide con "ae"      |      `a_`:  dos caracteres, empezando con "a"      |            `[ae]%`:  empiezan con "a" o "e"            | `[^ae]%`:  cualquier cadena que no empieza con "a" o "e" | `[a-e]%`:  empiezan con letra entre "a" y "e" |
|      `_` | `_%`:  cadenas con más de un carácter | `_e`:  2 caracteres, terminando con "e" |          `__`:  dos caracteres cualquiera          |                      Sin sentido                       |                       Sin sentido                        |                  Sin sentido                  |
|     `[]` |              Sin sentido              | `[ae]`:  Devuelve strings con "a" o "e" |                    Sin sentido                     |                      Sin sentido                       |                       Sin sentido                        |                  Sin sentido                  |
|      `^` |              Sin sentido              | `^e`:  cualquier cadena que no sea "e"  |     `^_`: cualquier char que no sea el primero     |                      Sin sentido                       |                       Sin sentido                        |    `[^a-z]`:  contiene cualquier mayúscula    |
|      `-` |              Sin sentido              |               Sin sentido               |                    Sin sentido                     | `[a-z]`:  coincide con cualquier letra entre "a" y "z" |                       Sin sentido                        |                  Sin sentido                  |

---
# Actualizaciones y modificaciones

- ``UPDATE``: Cambia datos de filas existentes.
- Uso de condiciones para modificar solo ciertos registros.

## Ejemplo

```sql
-- Actualizar la edad de una persona
UPDATE personas SET edad = 26 WHERE nombre = 'Luis';

-- Incrementar la edad en 1 para todos
UPDATE personas SET edad = edad + 1;
```

---
# Funciones de agregación y cálculos en resultados

- No aparecen explícitas funciones agregadas (``SUM``, ``COUNT``, etc.) en los ejercicios que diste, pero son básicas en SQL.
- Uso de cálculos directos en ``SELECT``:  

## Ejemplo

```sql
-- Contar cuántas personas hay
SELECT COUNT(*) FROM personas;

-- Calcular la edad promedio
SELECT AVG(edad) FROM personas;

-- Edad mínima y máxima
SELECT MIN(edad), MAX(edad) FROM personas;
```

---

# Alias y renombramiento

- ``AS``: para cambiar el nombre que aparece en los resultados (alias).

## Ejemplo

```sql
-- Renombrar columnas en el resultado
SELECT nombre AS Nombre, apellido AS Apellido FROM personas;
```

---
# Consultas con condiciones complejas

- Combinar condiciones con paréntesis para controlar la lógica.
- Uso de operadores lógicos con ``AND`` y ``OR``.

## Ejemplo

```sql
-- Seleccionar personas con condiciones combinadas
SELECT nombre FROM personas
WHERE (edad > 20 AND apellido LIKE 'M%') OR (edad < 25 AND apellido LIKE 'L%');
```

---
# Orden lógico para resolver problemas complejos

Cuando te den un problema con condiciones y filtros:

1. Identifica qué datos se necesitan (columnas).
2. Determina las condiciones para filtrar (``WHERE``).
3. Aplica transformaciones o cálculos (funciones).
4. Ordena y limita resultados si es necesario (`ORDER BY`, `LIMIT`).
5. Renombra columnas con alias para claridad.
6. Realiza actualizaciones si el ejercicio lo requiere.