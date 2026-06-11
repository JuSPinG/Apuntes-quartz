---
aliases:
  - Modelo de programación declarativa
---
Enlace: [[Fundamentos de programación.pdf#page=28]].

Básicamente, se trata de un paradigma de programación en el que, en lugar de dar instrucciones detalladas sobre cómo resolver un problema (como en programación imperativa), el programador define **hechos y reglas** que describen el problema, y después consulta el sistema para que él mismo deduzca la respuesta.

Los hechos consisten en lo que el programador sabe y puede aportar como información, mientras que las reglas son sus relaciones lógicas. A partir de aquí, es el ordenador el que intenta dar una respuesta.

Un ejemplo de dichas sentencias sería el siguiente:

```
Hijo(Juan, Luis)
```

Mientras que el fragmento anterior es un hecho, la estructura, es decir `Hijo(x, y)`, es la regla que ha sido usada.

![[Ejemplo programación lógica.png]]

En este caso, la lista de hechos sería la siguiente:

- `Hijo(Felipe, Luis)`.
- `Hijo(Juan, Luis)`.
- `Hijo(Sonia, Luis)`.
- `Hijo(Felipe, Ana)`.
- `Hijo(Juan, Ana)`.
- `Hijo(Sonia, Ana)`.

Para extraer información de dichas relaciones de hecho, se usa el siguiente método:

```
Entrada:

Hijo(x, Ana)

---

Salida:

x = Felipe
x = Juan
x = Sonia
```

Donde `x` nos marca por qué elementos puede ser sustituida, en función de los hechos dados.

A partir de aquí, se pueden generar relaciones entre las reglas, de la siguiente forma:

```
Padre(x, y) :- Hijo(y, x)
Hermano(x, y) :- Hijo(x, z), Hijo(y, z)
```

Con el operador `:-` definimos una nueva regla.

```
Entrada:

Padre(x, Sonia)
Hermano(x, Felipe)

---

Salida:

x = Luis
x = Ana
---
x = Felipe
x = Juan
x = Sonia
```

Dada la definición de `Hermano` anterior, es lógico hallar la respuesta de que Felipe es hermano de Felipe. Para evitar esto, se ha de reformular la regla.

```
Hermano(x, y) :- Hijo(x, z), Hijo(y, z), != (x, y)
```

Y así, alguien no puede ser hermano de si mismo.