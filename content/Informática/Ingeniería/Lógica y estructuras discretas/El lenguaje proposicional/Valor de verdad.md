En la sección anterior se consideró el valor de verdad de fórmulas $(p\ast q)$ o $(\neg p)$, dependiente del valor asignado en cada caso a las fórmulas atómicas $p$ y $q$. Para ello se partía de la interpretación en lenguaje natural de varios ejemplos. Como generalización de esos resultados, esta sección define el valor de verdad de fórmulas $(Y\ast Z)$ o $(\neg Y)$ donde $Y$ y $Z$ son fórmulas tan complejas como se necesite.

# Semántica de las conectivas

En una disyunción $X=(Y\lor Z)$, si sus componentes no son atómicas, no se puede utilizar una función asignación para fijar el valor de verdad de las mismas. Sin embargo, $Y$ y $Z$, como fórmulas proposicionales, tendrán un valor de verdad 0 o 1 aunque todavía no se conozca cómo y a partir de qué calcularlo.

Tan sólo hay 4 variaciones posibles sobre los valores que presentan conjuntamente $Y$ y $Z$: o bien ambas fórmulas se consideran verdaderas, o bien falsas, o bien una sí y otra no (y viceversa). Ante cada uno de esos casos hay que decidir cómo se acepta el valor de verdad de $(Y\lor Z)$, que dependerá de los valores de verdad de $Y$ y de $Z$.

Como ya ocurría con esta misma decisión sobre fórmulas $(p\lor q)$, la disyunción se considera siempre verdadera salvo cuando ambas componentes sean falsas. La {numref}`figura %s <fig-prop-semant-arbol-Y-o-Z>` representa este comportamiento semántico de la disyunción.

:::figure
![Valor de verdad de una disyunción compleja](img/arbol-Y-o-Z.svg)
*El valor de verdad de $X=(Y\lor Z)$ respecto al valor de verdad de $Y$ y el de $Z$*
:::

La siguiente definición fija cómo debe evaluarse una fórmula $(Y\ast Z)$ o $(\neg Y)$ respecto a los valores que presentan sus componentes $Y$ y $Z$.

:::definition
**Semántica de las conectivas proposicionales**
*Semántica de las conectivas binarias*. La siguiente tabla define la dependencia del valor de verdad de una fórmula binaria respecto al valor de sus dos componentes.

$$
\begin{array}{cc|cccc}
Y  & Z & (Y\land Z)  & (Y\lor Z)  &    (Y\to Z)  & (Y\leftrightarrow Z) \\ \hline
1  & 1 &  \mathbf{1} &     1      &        1     &          1           \\
1  & 0 &   0         &     1      & \mathbf{0}   &          \mathbf{0}  \\
0  & 1 &   0         &     1      &        1     &          \mathbf{0}  \\
0  & 0 &   0         & \mathbf{0} &        1     &          1           \\
\end{array}$$

*Semántica de la negación*. En el caso de las negaciones $X:\,(\neg Y)$, la fórmula $X$ se debe evaluar como falsa cuando su componente $Y$ se haya reconocido como verdadera. Y se debe evaluar como verdadera cuando su componente $Y$ se haya aceptado como falsa.

La notación en la cabecera de la tabla se ha relajado para que fuera más legible. No es lo mismo la fórmula $(Y\lor Z)$ que el valor de verdad de esa fórmula, que se notará como $I(Y\lor Z)$. En cada fila, el valor de verdad $I(Y\ast Z)$ depende de los valores $I(Y)$ y $I(Z)$ en esa fila.

El valor de verdad de una fórmula binaria $X=(Y\ast Z)$, fijado en su columna respectiva en la definición anterior, se presenta de forma resumida en la siguiente tabla.

**Semántica de las conectivas**

|                        |                                   |                                                            |
| ---------------------- | --------------------------------- | ---------------------------------------------------------- |
| $(Y\land Z)$           | sólo es **verdadera** en un caso: | cuando $(Y,Z)$ es $(1,1)$                                  |
| $(Y\lor Z)$            | sólo es **falsa** en un caso:     | cuando $(Y,Z)$ es $(0,0)$                                  |
| $(Y\to Z)$             | sólo es **falso** en un caso:     | cuando $(Y,Z)$ es $(1,0)$                                  |
| $(Y\leftrightarrow Z)$ | sólo es **falso** en dos casos:   | cuando $(Y,Z)$ es $(1,0)$ o bien cuando $(Y,Z)$ es $(0,1)$ |

# Cálculo del valor de verdad

Con ayuda del árbol sintáctico de una fórmula $X$, se puede ya calcular el valor de verdad que necesariamente debe reconocerse a $X$ cuando se evalúa el mundo desde una determinada perspectiva: desde una asignación concreta a sus fórmulas atómicas.

![Valor de verdad de una fórmula compleja](img/arbol-propagacion-formulas-y-conectivas.*)
*Valor de verdad de $X:\,(( (q \to (\neg \top)) \land (\neg (p \lor q)) ))$ respecto a la asignación $(p,q)=(0,1)$*

La {numref}`figura %s <fig-prop-semant-arbol-propagacion>` muestra, de abajo arriba, el cálculo del valor de verdad de una fórmula $X$ determinada cuando se ha escogido como asignación inicial $asign(p,q)=(0,1)$. La explicación de este cálculo por propagación **hacia arriba** se desarrolla en el siguiente ejemplo.

**Asignación a las fórmulas atómicas**. La fórmula $X$ evaluada tan sólo contiene $p$, $q$ y $\top$ como componentes atómicas. Se ha escogido la asignación $asign_{01}$ entre las cuatro posibles, de forma que $asign_{01}(p,q)=(0,1)$. Y puesto que se ha fijado que el valor de $q$ es 1, debe presentar este valor en sus dos apariciones en la fórmula. Respecto a la proposición constante $\top$, en cualquier asignación el valor de $\top$ es 1.

**Resultado final**. Respecto a esta asignación $asign_{01}$, el valor de verdad de $X$ resulta 0. Respecto a otra posible asignación (de las 4 distintas para $p$ y $q$), el valor de $X$ podría ser 1.

**Resultados intermedios**. El valor de la subfórmula condicional tiene que ser 0 porque su antecedente ($q$) tenía el valor 1 por asignación directa y su consecuente $(\neg \top)$ tiene el valor 0. Esto último es así porque $(\neg \top)$ debe tener el valor opuesto a su componente $\top$. Y el valor de $\top$ es 1 en esta y en toda asignación.

Por otro lado, la fórmula disyuntiva es verdadera porque al menos una de sus componentes (q) es verdadera. Y la fórmula que niega esta disyunción debe ser por tanto falsa. Así se llega a tener evaluadas las dos subfórmulas inmediatas de la fórmula conjuntiva final, que debe evaluarse como falsa porque al menos una componente es falsa (y en este caso, ambas lo son).

El cálculo sobre el árbol sintáctico se puede resolver de forma similar (ahora, desde dentro hacia afuera) sobre la expresión de la fórmula. Como ocurre sobre el árbol sintáctico, primero hay que evaluar las fórmulas menos complejas, aquéllas delimitadas por los paréntesis más internamente anidados.

Por ejemplo, sobre la fórmula $X:\,(p\land (q\to r))$ con asignación $(p,q,r)=(1,0,1)$ se evaluaría primero la subfórmula $(q\to r)$, cuyo valor de verdad resulta ser 1. Y la conjunción más externa, con ambas componentes verdaderas, resulta verdadera.

# La función *valor de verdad*


**Contenido ampliatorio**

El contenido de este apartado "La función *valor de verdad*" es teórico y se puede omitir en una primera lectura.
- De forma práctica, basta saber calcular el valor de verdad de una fórmula como propagación de una asignación sobre su árbol sintáctico.
- En este apartado se define de forma recursiva la función $I_{k}$, que devuelve el valor de verdad de una fórmula respecto de una asignación $asign_{k}$.

La subfunción de semántica para una fórmula de lenguaje proposicional es una aplicación que asigna a cada fórmula su valor de verdad. Dado un conjunto $asign_k$ para las fórmulas atómicas de un lenguaje proposicional, y dada una fórmula compleja $X$, el valor de verdad de $X$ en $asign_k$ es el valor que le reconoce $I_k$.

**Por inducción** en la complejidad de $X$, el valor de verdad de una fórmula se obtiene con la función de semántica de la forma siguiente:

- Caso base (fórmulas atómicas): si $X=p_i$, entonces $I_k(p_i)=k(p_i)$.
- Fórmulas negadas: $X=(\neg Y) \to I_k(X)=1$ si $I_k(Y)=0$, e $I_k(X)=0$ si $I_k(Y)=1$.
- Fórmulas conjuntivas: $X=(Y\land Z)$ se evalúa como verdadera si ambas componentes son verdaderas. En caso contrario, se evalúa como falsa.

En fórmulas complejas, la función $I_k$ se va evaluando hacia afuera de cada par de paréntesis en la expresión $X$.
