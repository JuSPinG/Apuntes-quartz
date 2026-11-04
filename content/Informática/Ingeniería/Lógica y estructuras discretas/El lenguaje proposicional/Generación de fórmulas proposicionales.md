# El alfabeto proposicional


El alfabeto reserva símbolos para representar proposiciones sobre el mundo. Así, los enunciados *'Llueve'* y *'Es martes'* se pueden representar respectivamente como $p_{2}$ y como $p_{5}$. Por otro lado, en lenguaje natural se encuentran enunciados compuestos como son *'Es martes y llueve'* o *'Si es martes entonces llueve'*. El alfabeto proposicional facilita algunas conectivas para construir, en este lenguaje formal, unas proposiciones compuestas a partir de otras. Con estas conectivas se producen expresiones como $(p_{5}\land p_{2})$ o como $(p_{5}\to p_{2})$.

El alfabeto proposicional $A_{prop}$ facilita los siguientes símbolos:

+ Un conjunto ilimitado de proposiciones $\{p_{1},p_{2}, p_{3}, p_{4},\ldots\}$
+ Proposiciones constantes $\{\bot, \top\}$ y conectivas $\{\neg, \wedge, \vee, \rightarrow, \leftrightarrow \}$ 
+ Paréntesis de apertura y de cierre.

$$A_{prop}=\{p_1,p_2,p_3,p_4,\ldots,\bot,\top, \neg, \wedge, \vee, \rightarrow, \leftrightarrow\}$$

# Expresiones y fórmulas. Conectivas binarias y monaria

- *Expresiones*. Las secuencias de símbolos del alfabeto se denominan *expresiones* o *cadenas de caracteres*. Tanto $\bot\bot)p_{3}\land$ como $((p_{3}\land p_{5})\lor \bot)$ son expresiones. Para las tareas ejecutables sobre este sistema lógico resultará útil la segunda expresión pero no la primera, que se puede descartar.
- *Fórmulas proposicionales*. Las expresiones de interés lo son porque mantienen cierto orden relativo entre proposiciones y conectivas. En este texto, las expresiones que respetan esas restricciones sintácticas, aún por determinar, se denominarán *fórmulas proposicionales*. En los textos clásicos de lógica se encuentran definidas como *fórmulas bien formadas (fbf) proposicionales*.
- *Lectura de las conectivas*. La {numref}`tabla %s <tabla-prop-lectura-conectivas>` presenta cinco expresiones que se reconocerán como fórmulas proposicionales. Cada una de ellas utiliza una de las conectivas del alfabeto y se adjunta su lectura. Todas las conectivas presentadas, salvo la negación, enlazan dos proposiciones y se denominan *conectivas binarias*. La negación es, sintácticamente, una *conectiva monaria*.

| Conectiva       | Fórmula ejemplo                | Lectura                          |
| --------------- | ------------------------------ | -------------------------------- |
| *Negación*      | $(\neg p_{2})$                 | *"no $p_{2}$"*                   |
| *Conjunción*    | $(p_{2}\land p_{5})$           | *"$p_{2}$ y $p_{5}$"*            |
| *Disyunción*    | $(p_{2}\lor p_{5})$            | *"$p_{2}$ o $p_{5}$"*            |
| *Condicional*   | $(p_{2}\to p_{5})$             | *"si $p_{2}$ entonces $p_{5}$"*  |
| *Bicondicional* | $(p_{2}\leftrightarrow p_{5})$ | *"$p_{2}$ si y sólo si $p_{5}$"* |

*Notación*. Se utilizará el símbolo $\ast$ de forma generalizada para referir a cualquiera de las conectivas binarias. Es decir, en futuros ejemplos y definiciones una expresión como $(p_{3}\ast p_{5})$ se entenderá como cualquiera de las cuatro opciones donde $\ast$ es una conectiva a escoger entre $\{\land,\lor,\to,\leftrightarrow\}$.

# La producción de fórmulas

## Reglas de generación

El siguiente conjunto de reglas permite construir nuevas expresiones a partir de una o dos expresiones previas, añadiendo paréntesis y conectivas. Si las expresiones componentes se aceptaron como fórmulas, la expresión compuesta se debe admitir como fórmula.

Cualquier expresión producida por aplicación de las siguientes reglas es una fórmula proposicional:

1. Si $X$ es un símbolo proposicional ($\bot$,$\top$ o $p_k$) entonces $X$ es ya una fórmula
2. Si $X$ es una fórmula entonces $(\neg X)$ es una fórmula
3. Si $X$ e $Y$ son fórmulas entonces $(X\land Y)$, $(X\lor Y)$, $(X\to Y)$ y $(X\leftrightarrow Y)$ son fórmulas

Cualquier fórmula producida puede ser posteriormente considerada como componente de una nueva fórmula, generada por otra aplicación de estas reglas. 

+ Tanto $p_{4}$ como $\top$ o $p_{8}$ se reconocen directamente como fórmulas por la regla 1. 
+ A partir de cualquiera de estas tres fórmulas mínimas se pueden obtener otras. Por ejemplo, por aplicación de la regla 2 se obtienen $(\neg p_{8})$ o $(\neg \top)$. 
+ Escogiendo dos fórmulas entre las ya citadas, se pueden generar nuevas fórmulas por la regla 3 como, por ejemplo, $X$ e $Y$ tales que: 

$$X=((\neg p_{8})\to p_{4})\qquad\qquad Y=(p_{8}\leftrightarrow \top)$$

De nuevo, cualquiera de las fórmulas anteriores puede servir para generar una fórmula negándola, por la regla 2. O bien se pueden combinar dos fórmulas, por la regla 3, interponiendo entre ellas $\land$, $\lor$, $\to$ o $\leftrightarrow$. Por ejemplo, con las fórmulas $X$ e $Y$ obtenidas anteriormente, se puede producir la fórmula:

$$(\, (\: (\neg p_{8})\to p_{4} \: ) \land (\: \neg (p_{8}\leftrightarrow \top ) \: ) \, )$$

El proceso de generación descrito requiere la existencia de fórmulas previas para producir otras, más complejas. Pero este proceso no sería realizable sin una base de partida: se necesita disponer de unas fórmulas iniciales, cuya construcción no dependa de otras.

La regla 1 ya reconocía directamente como fórmula cualquier símbolo $p_{k}$ del alfabeto, o la constante $\bot$ o la constante $\top$. Estas fórmulas, generadas por la regla 1, se denominan fórmulas atómicas. 

## Una notación más compacta

La siguiente notación, de tipo Backus-Naur, presenta la producción de *fórmulas proposicionales* de forma similar a las reglas de generación.

$$F ::= p_{k} \mid \top \mid \bot \mid (\neg F) \mid (F\land F) \mid (F\lor F) \mid (F\to F) \mid (F\leftrightarrow F)$$

La $F$ inicial, a la izquierda, indica que se va a producir una entidad de ese tipo $F$; en este caso, una fórmula proposicional. Y para ello se usa una y sólo una de las 8 opciones que se presentan, separadas por el carácter $|$. Así se produce por ejemplo $p_{3}$ como 'algo' de tipo $F$, o $p_{5}$ en otro proceso de producción, o $\bot$.

Una opción como $(F\land F)$ usa dos entidades, quizá distintas pero ambas de tipo $F$, para producir otra entidad de tipo $F$, la citada a la izquierda de $::=$. Así, con las $p_{3}$ y $p_{5}$ previas se produciría $(p_{3}\land p_{5})$. Y esta nueva $F$ se puede utilizar de nuevo en alguna de las opciones para producir otra fórmula más compleja.

## Secuencias de generación

La producción de nuevas fórmulas se puede expresar sobre un listado o secuencia de fórmulas con una restricción: se parte de un listado vacío y cada fórmula que se añade al final del listado *o bien es atómica o bien se produce en un solo paso de generación a partir de fórmulas previas en la secuencia*.

De acuerdo a las restricciones, inicialmente sólo se puede añadir una fórmula proposicional, $p_{5}$ en este caso. Y a partir de ese inicio, se puede seguir ampliando  la secuencia conforme a la restricción citada.

$$\begin{align*}

& p_{5}, \ p_{3} \\

& p_{5}, \ p_{3}, \ (\neg p_{5}) \\

& p_{5}, \ p_{3}, \ (\neg p_{5}), \ (p_{3}\to (\neg p_{5})) \\

& \vdots \\

& p_{5}, \ p_{3}, \ (\neg p_{5}), \ (p_{3}\to (\neg p_{5})), \ \bot, \ p_{7}, \ (\bot\land\bot), \ (\neg p_{7}), \ ((p_{3}\to (\neg p_{5})) \lor (\bot\land\bot))

\end{align*}$$

En este ejemplo, $(\neg p_{5})$ se puede añadir porque $p_{5}$ aparecía en alguna posición previa. Lo mismo ocurre con la fórmula disyuntiva al final de la secuencia: sus dos componentes ya aparecen en posiciones previas. 

Sobre esta misma secuencia se puede acabar generando la fórmula que se desee como fórmula final. En este caso, se ha obtenido la disyunción que aparece en último lugar. De esta fórmula disyuntiva, como de cualquier otra en la secuencia, se encuentran en posiciones previas todos sus pasos intermedios de generación. Quizá entremedias de otras fórmulas que no se han utilizado en su composición, como ocurre p. ej. con $(\neg p_{7})$, que no aparece en la fórmula final.

Una *secuencia de generación de la fórmula $X$* es una secuencia de fórmulas que cumple la restricción citada y que tiene a $X$ como última fórmula.

# Nada más es una fórmula

La regla *'si una persona ha nacido un jueves entonces es un mamífero'* garantiza que se reconozca como mamífero a Juan porque nació un jueves. Pero esta regla es compatible con la existencia adicional de otros mamíferos, quizá nacidos en martes o que incluso no son personas, pero garantizados como tal por otras reglas. 

Puesto que el concepto de fórmula proposicional se está definiendo en este punto y para ciertos fines, se opta por no admitir como fórmulas proposicionales nada más que las producidas por las tres reglas de generación. Para ello se aceptan estas dos restricciones:

1. Si una expresión $X$ es generable (por estas tres reglas) entonces $X$ es una fórmula. 
2. Si una expresión $X$ se reconoce como fórmula entonces $X$ se ha producido por aplicación de las reglas de generación.

El primer condicional ya se aceptaba en la declaración de las reglas de generación y en su uso para producir fórmulas. El segundo se introduce en este punto para delimitar, para definir, el concepto de fórmula proposicional.

> [!info] Fórmula proposicional
>Fórmula proposicional
>Las fórmulas proposicionales son *exclusivamente* las expresiones que pueden generarse a partir de las reglas de generación.

Esta exclusión suele fijarse en la propia exposición de las reglas de generación, añadiendo una cuarta regla:

4. Nada más es una fórmula proposicional.

# El lenguaje proposicional

El proceso de producción genera ilimitadamente nuevas fórmulas. De esta forma, por muy extensas y complejas que se necesiten para una determinada aplicación, el esquema de generación garantiza su disponibilidad.

Resulta así un conjunto infinito de fórmulas, de tamaño creciente pero todas ellas finitas: el número de símbolos de cualquier fórmula generable $(\neg X)$ o $(X\ast Y)$ tan solo añade 3 símbolos a la suma de símbolos de sus componentes. No hay un paso de generación que, de repente, construya una fórmula sin fin a partir de dos componentes finitos.

El lenguaje proposicional $L_{prop}$ es el conjunto formado, exclusivamente, por todas las fórmulas proposicionales.

De nuevo, la definición informal anterior se puede precisar un poco más como una restricción condicional que se exige en ambos sentidos:

+ *Si $X$ es una fórmula entonces $X$ es un elemento del lenguaje*: todas las fórmulas pertenecen al lenguaje proposicional.
+ Si $X$ es un elemento del lenguaje entonces $X$ es una fórmula: nada más es elemento del lenguaje, se descartan elementos que no sean fórmulas.

Tras esta definición, las siguientes tres frases se consideran equivalentes y se utilizará una u otra indistintamente:

+ $X$ se ha producido por aplicación de las reglas de generación.
+ $X$ es una fórmula proposicional.
+ $X$ pertenece al lenguaje proposicional: $X\in L_{prop}$.

# Pertenencia al lenguaje

La primera de las dos siguientes expresiones es una fórmula proposicional y la segunda no lo es.

1. $((p_{3}\to (\neg p_{5})) \lor (\bot\land\bot))$
2. $(p_{3}\to p_{5})\land\lor\to\bot$

*Para confirmar* que una expresión es una fórmula proposicional basta mostrar detalladamente su proceso de generación: cómo se ha producido, paso a paso, a partir de las reglas de generación. Para ello basta aportar una *secuencia de generación* de la fórmula.

*Para descartar* que una expresión sea una fórmula (para confirmar que no lo es) hay que *demostrar* que no se puede generar de ninguna forma a partir de esas reglas, que no coincide con ninguna fórmula posible. Y estas demostraciones, que recorren estructuradamente infinitos elementos, se conocen como *demostraciones inductivas* y se presentarán más adelante.

La expresión $(p_{3}\to p_{5})\land\lor\to\bot$ se va a descartar como fórmula porque incumple una propiedad que se aprecia en toda fórmula: nunca aparecen dos conectivas binarias seguidas en una fórmula.

Las fórmulas atómicas iniciales ya presentan esta propiedad y esta característica *se transmite* desde las fórmulas componentes hacia las fórmulas compuestas en cualquier aplicación de las reglas de generación: si $X$ e $Y$ no presentan dos conectivas  binarias seguidas entonces tampoco ocurre en $(\neg X)$ (o en $(\neg Y)$) o en $(X\ast Y)$.