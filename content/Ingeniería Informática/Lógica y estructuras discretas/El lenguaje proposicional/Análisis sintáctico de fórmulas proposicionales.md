En la sección anterior se fijó, por definición, que si se recibe una fórmula (garantizada como tal) se debe considerar producida por las reglas de generación. Pero esta seguridad formal aún deja una pregunta abierta: 

+ ¿Se puede obtener la misma fórmula $X$ por aplicaciones distintas de las reglas de generación?

Si fuera así, su descomposición en componentes, su análisis sintáctico, no produciría un resultado único. 

# Descomposición única

De cualquier fórmula $X$, basta considerar si su descomposición inmediata es única: es decir, si el último paso en su formación sólo puede haber ocurrido de una forma.

Si $X$ es una fórmula proposicional entonces se encuentra en uno y *sólo uno* de estos siete casos:

+ Es una fórmula atómica.
+ Existe una única fórmula $Y$ tal que $X$ es $(\neg Y)$.
+ Existen dos únicas fórmulas $Y$ y $Z$, así como una única conectiva binaria $\ast$ en $\{\land,\lor,\to,\leftrightarrow\}$,  tales que $X$ es $(Y\ast Z)$.

Intuitivamente parece un resultado trivial, pero debe demostrarse inductivamente para este esquema de generación. Hay otros procesos de producción que generan una misma expresión con un paso final o con otro alternativo. En el siguiente ejemplo esto ocurre por la ausencia de paréntesis.

El siguiente proceso de generación produce expresiones aritméticas que suman o multiplican reiteradamente tres dígitos, de 1 a 3:

$$A ::= 1 \mid 2 \mid 3 \mid A + A \mid A\times A$$

En una fórmula como $3+2\times 2+1$ no se puede detectar qué operación aritmética, suma o producto, se ha utilizado en su último paso de composición. Esta fórmula se puede haber construido por suma de $3$ y de $2\times 2+1$. O bien por producto de $3+2$ y $2+1$. O bien por suma de $3+2\times 2$ y de $1$.

## Conectiva principal

La {prf:ref}`propo-prop-descomposicion-sintactica-unica` afirma que cualquier fórmula $X$ es asignable a un único tipo de fórmula, de entre 6 posibles. Y en la definición de cada tipo aparece a lo sumo una determinada conectiva. La detección de esta conectiva en $X$ decide el tipo de fórmula que es. A esta conectiva se la conoce como *conectiva principal* de la fórmula. Intuitivamente, es la conectiva que introdujo el último paso de su generación.


> [!info] Conectiva principal
> Sea $X$ una fórmula proposicional.
> 	Si $X$ es una fórmula atómica no tiene conectiva principal.
> 	$X$ es una fórmula del tipo $(\neg Y)$ tiene a esa negación inicial como conectiva principal.
> 	Si $X$ es del tipo $(Y\ast Z)$ tiene esa conectiva binaria $\ast$, una entre $\{\land,\lor,\to,\leftrightarrow\}$, como conectiva principal.

Existe un procedimiento para detectar la conectiva principal de cualquier fórmula $X$, y por tanto, el tipo de fórmula que es $X$ conforme a la proposición sobre descomposición única. Este procedimiento asume que toda fórmula proposicional tiene sus paréntesis correctamente anidados y balanceados (en pares apertura-cierre). Así, la detección sistemática de la conectiva principal sigue este proceso:

+ Si la fórmula no tiene un paréntesis inicial es una fórmula atómica y no tiene conectiva principal
+ Si se recorre cualquier fórmula no atómica llevando el recuento de los paréntesis abiertos menos los cerrados, la conectiva principal es a la que se llega con *todos los paréntesis cerrados menos uno*, el inicial de la fórmula.



> [!example] En la siguiente fórmula se han etiquetado numéricamente algunos paréntesis: la etiqueta muestra el resultado en ese punto de los paréntesis abiertos menos los que se van cerrando:
> $$\biggl(\, \Bigl(^{2} \neg \, \bigl( \, (^{4} \, ( p_3 \vee (^{6} \neg p_2) ) \leftrightarrow (^{5} p_1\wedge p_3) \, )^{3}\, \rightarrow\, (^{4} p_2\rightarrow p_4 )^{3} \ \bigr) \ \Bigr)^{1} \ \wedge\ \Bigl(\ p_3\vee(\neg p_1)\, \Bigr)\, \biggr)$$
Se llega con un único paréntesis abierto a la última de las conectivas conjuntivas que aparecen en la fórmula. Esta es la conectiva principal de la fórmula, que resulta ser de tipo $(Y\land Z)$.

## Subfórmulas inmediatas

La detección de la conectiva principal de una fórmula $X$ decide el tipo de la fórmula, entre los seis posibles. Y en la definición de cada tipo aparecen a lo sumo dos fórmulas componentes de $X$. A estas fórmulas componentes de $X$ se las conoce como *subfórmulas inmediatas* de $X$. Intuitivamente son las que se utilizaron como componentes en el último paso de generación de la fórmula en cuestión.


> [!info] Subfórmulas inmediatas
Sea $X$ una fórmula proposicional.
Si $X$ es una fórmula atómica entonces no tiene Subfórmulas inmediatas.
 Si $X$ es una fórmula del tipo $(\neg Y)$ tiene a $Y$ como subfórmula inmediata. 
 Si $X$ es una fórmula del tipo $(Y\ast Z)$ tiene a $Y$ y $Z$ como subfórmulas inmediatas.

# Árboles sintácticos


A partir de una fórmula $X$ dada se puede ejecutar el siguiente proceso de análisis:

+ *Descomposición de $X$*. Se puede determinar cuál es la última conectiva utilizada en su producción, así como las subfórmulas inmediatas utilizadas en ese paso.
+ *Análisis de las subfórmulas inmediatas de $X$*. Estas subfórmulas inmediatas de $X$ son a su vez fórmulas, susceptibles de ser analizadas de la misma manera: detectando su conectiva principal y sus componentes inmediatas.
+ *Análisis de cada subcomponente encontrada*. Lo mismo ocurre con cada componente que se va detectando en este proceso de descomposición, a cualquier nivel: es una nueva fórmula que admite este mismo análisis.
+ Este proceso, que finaliza en todas sus líneas de descomposición, se conoce como *análisis sintáctico* de la fórmula $X$.


La {numref}`figura %s <fig-ej-arbol-sintactico>` muestra gráficamente el análisis  sintáctico de la fórmula $X=((q\to \neg r)\land (\neg(p\lor q)))$. La subfigura izquierda presenta, de arriba abajo, el proceso de detección de subfórmulas inmediatas.

En la subfigura de la derecha se han reetiquetado los nodos (salvo los atómicos) con la conectiva principal de la fórmula de ese nodo.

La fórmula $X$ inicial es siempre una expresión finita. Y esta propiedad garantiza que el análisis sintáctico finaliza siempre. Esto ocurre porque las subfórmulas inmediatas de cada fórmula siempre constan de menos símbolos que la fórmula que componen. Así, este proceso acaba en todas sus líneas de análisis porque se llega necesariamente a componentes atómicas, donde se finaliza la descomposición.

:::{figure} img/arbol-sintactico-y-conectivas.svg

Árbol sintáctico de la fórmula $((p_{2}\to \neg p_{3})\land (\neg(p_{1}\lor p_{2})))$

Esta representación gráfica, en forma de árbol invertido, aparece al describir cualquier sistema compuesto de bloques dentro de otros bloques. Así, se puede hablar, por ejemplo, del árbol de directorios en un ordenador. Para la navegación por esta estructura genérica de árbol se usa la siguiente notación.

## Notación utilizada en la navegación por un árbol

Utilizando la {numref}`figura %s <fig-ej-arbol-sintactico>` como referencia, se describe la notación usual para la navegación por un árbol:


+ *Nodo raíz y nodos hoja*: la fórmula $X$ original es la raíz del árbol y cada una de las fórmulas atómicas inferiores es una hoja del árbol.
+ *Nodos del árbol*: cada una de las fórmulas que aparecen en ese árbol está situada en un nodo del árbol, desde el nodo raíz hasta los nodos hoja, pasando por los nodos intermedios.
+ *Ramas del árbol*: cada uno de los caminos de nodos que empieza en el nodo raíz y finaliza en un nodo hoja, inclusive ambos, se denomina rama del árbol.
+ *Subárbol*: cada nodo se puede considerar a su vez como raíz de su propio árbol. Así, el árbol sintáctico de una fórmula $X=(Y\ast Z)$ enlazaría el nodo raíz $X$ con los respectivos árboles que tienen por raíz tanto $Y$ como $Z$.

A esta analogía con los árboles físicos se añade la analogía con la descendencia familiar entre nodos:

+ *Nodo padre y nodos hijos*: un nodo puede tener varios descendientes inmediatos (en este caso, sus subfórmulas inmediatas) que son sus nodos hijo. Estos nodos hijo, que se denominan nodos hermanos entre sí, tiene en común un único nodo padre.
+ *Ascendientes y descendientes de un nodo*: los ascendientes o antecesores de un nodo se encuentra en el camino desde ese nodo hasta el nodo raíz. Los descendientes o sucesores de un nodo se encuentran en el árbol que considera a ese nodo como raíz.

# Definiciones recursivas

La definición de función recursiva se expondrá más adelante. En este punto se avanza informalmente porque ayuda a definir de forma concisa conceptos o medidas sobre árboles sintácticos. Tan sólo como ejemplo introductorio, se comienza definiendo de forma recursiva la función que devuelve el número de nodos de un árbol sintáctico.

## Número de nodos

A cada fórmula $X$ le corresponde un árbol sintáctico y este árbol sintáctico tiene un determinado número de nodos en total. Así, se puede considerar la función $\text{Nod}(X)$, que hace corresponder a cada fórmula con el total de nodos de su árbol sintáctico.

Puesto que existe un procedimiento para detectar la conectiva principal de $X$, si se preguntara a la fórmula cuántos nodos va a producir se podría obtener una respuesta parcial como la siguiente: 

+ *"Puesto que sé que soy una fórmula de tipo $(Y\ast Z)$, mi total de nodos es 1 (el mío) más los nodos de la fórmula $Y$ más los nodos de la fórmula $Z$"*.

Una fórmula de tipo $(\neg Y)$ daría una respuesta ligeramente distinta, pero de nuevo parcial: 

+ *"mi nodo más los nodos que desarrolle $Y$"*. 

En ambos casos, para calcular $\text{Nod}(X)$ hay que volver a calcular la misma función pero ahora de sus componentes: $\text{Nod}(Y)$ y $\text{Nod}(Z)$. Este tipo de cálculo se denomina recursivo. En este caso no tiene una profundidad infinita porque se llega necesariamente a componentes atómicas que aportan 1 nodo, sin referencia a la aportación de otras fórmulas.

$$\text{Nod}(X) = \begin{cases}


1 + \text{Nod}(Y) + \text{Nod}(Z)    & \text{ si } X=(Y*Z) \\


1 + \text{Nod}(Y)                    & \text{ si } X=(\neg Y) \\


1                                    & \text{ si } X \text{ es atómica } \\


\end{cases}$$


> [!example]
> Se considera la fórmula $X:\,((p_{2}\to \neg p_{3})\land (\neg(p_{1}\lor p_{2})))$ cuyo árbol sintáctico se representa en la {numref}`figura %s <fig-ej-recursividad-subarboles>`. Conforme a la definición de la función $\text{Nod}$, el cálculo de $\text{Nod}(X)$ se desarrolla, de arriba abajo y recursivamente, como sigue:$$\begin{align*}\text{Nod}(X) & = 1 +  \text{Nod}(X_{1}) + \text{Nod}(X_{2})  \\
& = 1 + \Big(1 + \text{Nod}(X_{11}) + \text{Nod}(X_{12})\Big) + \Big(1 + \text{Nod}(X_{21})\Big)\\
& = 1 + \Big(1 + 1 + \big(1 + \text{Nod}(X_{121})\big)\Big) + \Big(1 + \big(1 + \text{Nod}(X_{211}) + \text{Nod}(X_{212})\big)\Big)\\
& = 1 + \Big(1 + 1 + \big(1 + 1\big)\Big) + \Big(1 + \big(1 + 1 + 1\big)\Big)\\
& = 9\\
\end{align*}$$


:::{figure} img/recursividad-subarboles.svg
Árbol sintáctico de la fórmula $((q\to \neg r)\land (\neg(p\lor q)))$

## Conjunto de subfórmulas


Cada nodo del árbol sintáctico de una fórmula $X$ está etiquetado con una fórmula, la correspondiente al nodo. Todas esas fórmulas se han ido utilizando por las reglas de generación para producir $X$. Todas esas fórmulas deberían aparecer en una secuencia de generación de $X$, incluida la propia fórmula final $X$.


> [!info] Conjunto de subfórmulas de una fórmula proposicional.
> Informalmente, el conjunto de subfórmulas de una fórmula $X$ es el conjunto de todas las fórmulas que aparecen en su árbol sintáctico, incluida $X$. De forma más precisa, dada una fórmula $X$, su subconjunto de fórmulas $Subf(X)$ se define recursivamente como:$$Subf(X) = \begin{cases}
\{X\} \cup Subf(Y) \cup Subf(Z) & \text{ si } X=(Y*Z) \\
\{X\} \cup Subf(Y)               & \text{ si } X=(\neg Y) \\
\{X\}                            & \text{ si } X \text{ es atómica } \\
\end{cases}$$


Para la fórmula $X$ raíz de la {numref}`figura %s <fig-ej-recursividad-subarboles>`, basta recorrer sus nodos para componer el conjunto de sus subfórmulas:


$$\text{Subf}(X)=\{p_{1},p_{2},p_{3},(\neg p_{3}),(p_{2}\to (\neg p_{3})),(p_{1}\lor p_{2}),(\neg(p_{1}\lor p_{2})),((p_{2}\to (\neg p_{3}))\land (\neg(p_{1}\lor p_{2})))\}$$

Este conjunto se puede obtener recursivamente como sigue:

$$
\begin{align*}
\text{Subf}(X) &= \{X\} \cup \text{Subf}(X_{1}) \cup \text{Subf}(X_{2}) \\
               &= \{X\} \cup \Big(\{X_{1}\}\cup \text{Subf}(X_{11}) \cup \text{Subf}(X_{12})\Big) \cup  \Big(\{X_{2}\}\cup \text{Subf}(X_{21})\Big) \\
               &= \{X\} \cup \Big(\{X_{1}\}\cup \{X_{11}\} \cup (\{X_{12}\}\cup \text{Subf}(X_{121})\Big) \cup  \Big(\{X_{2}\}\cup ( \{X_{21}\} \cup \text{Subf}(X_{211}) \cup \text{Subf}(X_{212})) \Big) \\
               &= \{X\} \cup \Big(\{X_{1}\}\cup \{X_{11}\} \cup (\{X_{12}\}\cup \{X_{121}\}\Big) \cup  \Big(\{X_{2}\}\cup ( \{X_{21}\} \cup \{X_{211}\} \cup \{X_{212})\} \Big) \\
\end{align*}$$

## Rango de un árbol

Con un adecuado anidamiento de sus componentes, se puede conseguir que una rama sea bastante más larga que otras del mismo árbol sintáctico. Dada una fórmula $X$, la función $Rango(X)$ devuelve 'el tamaño' de esta rama o ramas máximas. En particular, en cada rama se puede medir el número de transiciones desde cada nodo al siguiente. Y $Rango(X)$ devuelve el máximo de estas medidas sobre las ramas del árbol.


> [!info] Rango del árbol sintáctico de una fórmula proposicional
> La función $Rango(X)$ se define recursivamente como:
> $$Rango(X) = \begin{cases}
max(Rango(Y),Rango(Z))+1         & \text{ si } X=(Y*Z) \\
Rango(Y) + 1                     & \text{ si } X=(\neg Y) \\
0                                & \text{ si } X \text{ es atómica } \\
\end{cases}$$

Sobre el árbol de la {numref}`figura %s <fig-ej-recursividad-subarboles>` se puede apreciar que hay tres ramas máximas. En cada una de ellas, el número de transiciones desde un nodo al siguiente es 3. Luego, para esta fórmula $X$ debe ocurrir que $Rango(X)=3$:

$$\begin{align*}
Rango(X) &= max\Big(Rango(X_{1}),                 & Rango(X_{2})\Big) + 1 \\
               &= max\Big( max \big(Rango(X_{11}), Rango(X_{12})\big) + 1,& Rango(X_{21})+1 \Big) + 1 \\
               &= max\Big( max \big(0, Rango(X_{121}) + 1 \big) + 1,& max\big( Rango(X_{211}), Rango(X_{212})) +  1 \big) + 1 \Big) + 1 \\
               &= max\Big( max \big(0, 0 + 1 \big) + 1,& max\big( 0 , 0 +  1 \big) + 1 \Big) + 1 \\
               &= max\Big( 1 + 1,& 1 + 1 \Big) + 1 \\
               &= 3
\end{align*}$$