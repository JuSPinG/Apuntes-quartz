# Entidades

Las entidades (persona, coche...) poseen atributos que se especifican en este tipo de diagramas (nombre, marca...).

- Persona:
  - Nombre.
  - DNI.
- Coche:
  - Marca.
  - Matrícula.

Además, pueden existir atributos clave "`(c)`". Así se vería un diagrama plano:

- E Persona: DNI (c), nombre.
- E Coche: Matrícula (c), marca.

# Atributos

- Tipos de atributos:
  - Ordinarios.
  - Identificador.
  - Identificador alternativo.
  - Opcional.
  - Compuesto (de los anteriores).

# Relaciones

"La **persona** *conduce* un **coche**", entidad (`E`) relación (`R`) entidad (`E`).

![[Ejemplo entidad-relación.png]]

Relaciones entre entidades, que a su vez pueden estar relacionadas con otros atributos.

![[Ejemplo entidad-relación.svg]]

# Correspondencia o cardinalidad

![[Ejemplo cabinación.png]]

Para un conductor ¿Cuántos coches puedo conducir?

Se añade un paréntesis con 2 valores, uno el máximo y otro el mínimo. En el ejemplo, un coche como mínimo debe de ser conducido por una persona "`(1, N)`" y luego el máximo no se especifica usando N. Otro ejemplo:

![[Ejemplo de cabinación 2.png]]

Una sala está en un y solo un edificio.

# Relaciones recursivas

Es posible que exsita una relación entre dos instancias de una misma entidad, como puede ser la relación padre-hujo: un padre puede tener o no tener varios hijos, pero un hijo solo tiene un padre, siempre y como mínimo mínimo uno.

![[Ejemplo relación recursiva.png]]

Otro ejemplo sería la amistad, en una relación refleja: yo soy amigo de alguien y esa persona es mi amiga. O como la supervisión en un empleo: yo soy supervisor de alguien y esa persona es mi subordinado.

# Relaciones de diferentes grados

En esta misma clase, profesor, módulo y alumno se relacionan mediante la relación de impartir.

![[Ejemplos relaciones grado N.png]]

Estaría una relación de grado 3.

Para un profesor y un módulo, se le puede dar clase a $N$ alumnos, mientras que el mínimo es solo uno.

# Entidades débiles

Si existe un edificio, una sala necesariamente debe de existir. La sala depende del edificio. A esto se le  llama una relación de entidad débil.

# Herencia y especializaciones

![[Ejemplo herencia.png]]

Representa una especie de jerarquía entre entidades. Un vehículo cumple con las propiedades de un objeto que le viene herado, pero también hereda su información a un coche que pasa su información a un modelo.

Esto se podría entender como:

- Entidades globales a la sección.
  - Entidad que hereda 1.
  - Entidad que hereda 2.
  - ...

## La especialización total y no total

La total consiste en que un padre que no puede ser seleccionado. Por ejemplo, un vehículo en si no puede ser elegido, pero un coche, que hereda sus propiedades, sí puede existir.

Por otro lado, se puede carecer de una especialización total. Donde por ejemplo dentro de la clase "Ventana", pueden existir las abatibles y las no abatibles, pero aun así no niegan la existencia *per se* de la ventana.

Si es total, se usa una pequeña circunferencia entre la entidad padre y el triángulo para referenciar dicha propiedad.

## Exclusivas y no exclusivas

Esto refiere a si uno de los elementos hijo puede, además, ser otro hijo. [[Ejemplo herencia.png|En la imagen anterior]], por ejemplo, sería exclusiva si un vehículo pudiese ser camión y autobús al mismo tiempo, que no es el caso, por lo que la especialización es no exclusiva.

Si es exclusiva, se usa una semicircunferencia después del triángulo para referenciar dicha propiedad.