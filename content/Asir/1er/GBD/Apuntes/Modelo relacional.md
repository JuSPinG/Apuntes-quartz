Consiste en pasar de un [[Diagramas entidad-relación]] a un concepto abstracto que se pueda introducir en un Sistema de Base de Datos.

Por ejemplo, este [[Ejemplo entidad-relación 2.png]] se pasaría de la siguiente manera, de:

![[Ejemplo entidad-relación 2.png]]

A:

![[Ejemplo modelo relacional.png]]

Existen varias transformaciones, aquí, estamos ante un caso **1:N**. Hay muchos más, por lo que crearé la siguiente tabla para comentar todas las transformaciones:


|   Relación    |   Tipo    |         Generación de tabla          |                         Excepción                         |
| :-----------: | :-------: | :----------------------------------: | :-------------------------------------------------------: |
| (1, 1):(1, 1) |  Directo  |             No se genera             |       Una entidad se queda la PK de la otra como FK       |
| (1, 1):(0, 1) |  Directo  |             No se genera             |         (1, 0) se queda la PK de la otra como FK          |
| (0, 1):(0, 1) |  Directo  | Sí se genera, con el nombre original |                       Sin excepción                       |
|      N:1      |  Directo  |   Sí genera, con nombre compuesto    |                     FK1 va para el N                      |
|      N:M      |  Directo  | Sí se genera, con el nombre original |                       Sin excepción                       |
|      1:1      | Reflexivo |             No se genera             |                  Tiene una PK como su FK                  |
|      N:1      | Reflexivo | Sí se genera, con el nombre original | PF,FK1 es equivalente a FK2, y ambas apuntan a la entidad |
|      N:N      | Reflexivo | Sí se genera, con el nombre original |      La relación duplica la PK como FK (id_1, id_2)       |

