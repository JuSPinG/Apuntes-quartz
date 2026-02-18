> [!attention] Alfabeto alternativo
> Como letras proposicionales se utilizarán $\{p,q,r,s,t\ldots\}$ en lugar de $\{p_{1},p_{2},p_{3},\ldots\}$ en algunos casos. En concreto, para los ejemplos y desarrollos que requieren pocas proposiciones atómicas basta usar algunas letras del alfabeto, evitando así los subíndices.

Respecto a las conectivas, en otros textos se pueden encontrar símbolos distintos para nombrarlas:
- Entre otras opciones, se utiliza $\&$ para la conjunción, $|$ para la disyunción o $\sim$ para la negación.
- La Electrónica Digital permite materializar fórmulas lógicas en forma de circuitos combinacionales. Y en ese contexto, es habitual notar la disyunción como una suma $(P+Q)$, la conjunción como un producto $(P\cdot Q)$ y la negación con una sobrelínea $\overline{P}$.

# Omisión de paréntesis

Aunque las fórmulas utilizadas en los textos son usualmente cortas, aún así presentan demasiados paréntesis y son difíciles de interpretar a primera vista. En este apartado se expone cómo transmitir fórmulas proposicionales, omitiendo algunos de sus paréntesis, pero sin pérdida de precisión en la estructura de la fórmula que se comunica.

> [!tip] Vídeo
> [Omisión de paréntesis](prop-notaciones-alternativas-video)

> [!example]+
> Si en una fórmula como $X=((p\land (q\to r)) \lor s)$ se elimina un par de paréntesis, se genera una ambigüedad entre la posición de dos conectivas en el árbol sintáctico: no se puede afirmar cuál debe situarse encima de la otra.
>
> Este es el caso de $X_{sin}=((p\land q\to r) \lor s)$, donde el orden de anidamiento entre $\land$ y $\to$ ya no está delimitado. Así, esta fórmula se puede interpretar estructuralmente de maneras:
> 1. $X_{\land}=((p\land (q\to r)) \lor s)$
> 2. $X_{\to}=((p\land q)\to r) \lor s)$

## Reglas de precedencia

**Definición:**
Para la reposición de paréntesis, se acuerda el siguiente orden de precedencia:
- Negaciones: 1
- Conjunciones: 2
- Disyunciones: 3
- Condicionales: 4
- Bicondicionales: 5

En caso de duda entre dos conectivas, se debe considerar con un *anidamiento más interno* (*por debajo* en el árbol sintáctico) la conectiva con menor orden de precedencia.

*Agrupación por la izquierda*: Adicionalmente, la repetición de una misma conectiva binaria $\ast$ se considerará agrupada binariamente por la izquierda. Así, $\,p\land q\land r\,$ se considera una fórmula con la estructura siguiente: $((p\land q)\land r)$.

### Paréntesis que se pueden omitir

Las fórmulas de la siguiente lista se pueden presentar sin paréntesis y su reposición se entiende conforme a las reglas de precedencia. Cada par de paréntesis repuesto se ha marcado con un superíndice que indica el orden de precedencia de esa conectiva.

1. $\neg p \vee q\quad$ se entiende como $\quad((\neg p)^{\tiny{1}} \vee q)^{\tiny{3}}$
2. $r \land \neg p \to q\quad$ se entiende como $\quad\big(\big(r \land (\neg p)^{\tiny{1}}\big)^{\tiny{2}} \to q\big)^{\tiny{4}}$
3. $r \land \neg p \to \neg q \lor s\quad$ se entiende como $\quad\big(\big(r \land (\neg p)^{\tiny{1}}\big)^{\tiny{2}} \to \big((\neg q)^{\tiny{1}} \lor s\big)^{\tiny{3}}\big)^{\tiny{4}}$
4. $r \land p\land t \leftrightarrow \neg q \lor s\quad$ se entiende como $\quad\big(\big((r \land p)^{\tiny{2}}\land t\big)^{\tiny{2}} \leftrightarrow \big((\neg q)^{\tiny{1}} \lor s\big)^{\tiny{3}}\big)^{\tiny{5}}$

> [!tip] Nota
> Eliminar o no un par de paréntesis es siempre una decisión del autor, confiando en que el lector los repondrá correctamente conforme al acuerdo de precedencia. En algunos casos, se puede optar por mantener algunos paréntesis que podrían eliminarse, si se considera que no sobrecargan la legibilidad de la fórmula:
$$ q\lor r\lor (p\land q)\leftrightarrow (s\to p) = q\lor r\lor p\land q\leftrightarrow s\to p = (((q\lor r)\lor (p\land q))\leftrightarrow (s\to p))$$

### Paréntesis que no deben omitirse

Algunos paréntesis no pueden omitirse nunca, porque su reposición (conforme a precedencia) los situaría en una posición distinta y, por tanto, no se habría transmitido la fórmula que se pretendía comunicar. Esto ocurre en cada una de las fórmulas de la siguiente lista si se omite el par de paréntesis que queda:

1. $\neg (p \lor q)$
2. $r \land (\neg p \to q)$
3. $r \land (\neg p \to \neg q \lor s)$ 
4. $r \land p\land (t \leftrightarrow \neg q \lor s)$

# Notación prefija

La notación presentada originalmente se conoce como notación infija y presenta las conexiones binarias como $(X\ast Y)$.

**Definición de Notación prefija:**  
En notación prefija, la conectiva se escribe antes que sus dos componentes y sin uso de paréntesis: ${\ast}XY$. Así, las fórmulas en notación prefija se pueden obtener mediante el siguiente esquema de producción:

$$F ::= p_{k} \mid \top \mid \bot \mid {\neg}F \mid {\land}FF \mid {\lor}FF \mid {\to}FF \mid {\leftrightarrow}FF$$

**Ejemplo:**
La siguiente fórmula, así como su árbol sintáctico, corresponden a la reescritura en notación prefija:

$$X_{inf}:\,((p_{2}\to (\neg p_{3}))\land (\neg(p_{1}\lor p_{2}))) \quad \rightarrow \quad X_{pref}:\,{\land}{\to}p_{2}{\neg p_{3}}{\neg}{\lor}p_{1}p_{2}$$

La secuencia de generación en notación infija y en notación prefija es:

$$\begin{array}{ccccccccc}
(1): & p_{1}, & p_{2}, & p_{3}, & (\neg p_{3}), & (p_{2}\to (\neg p_{3})), & (p_{1}\lor p_{2}), & (\neg (p_{1}\lor p_{2})), & ((p_{2}\to (\neg p_{3}))\land (\neg (p_{1}\lor p_{2}))) \\
(2): & p_{1}, & p_{2}, & p_{3}, & {\neg p_{3}}, & {\to}p_{2}{\neg p_{3}}, & {\lor}p_{1}p_{2}, & {\neg}{\lor}p_{1}p_{2}, & {\land}{\to}p_{2}{\neg p_{3}}{\neg}{\lor}p_{1}p_{2} \\
\end{array}$$

## Listas anidadas

La notación prefija es más fácil de procesar por un sistema automático, aunque es menos legible para las personas. Para automatizar el tratamiento de fórmulas prefijas se suelen representar en una estructura de datos de uso general en programación: la lista de elementos.

**Definición de Listas anidadas:**
La implementación de las fórmulas proposicionales se puede hacer representándolas como listas anidadas. La producción de fórmulas con esta notación se define en la siguiente expresión:

$$F ::= p_{k} \mid \top \mid \bot \mid [{\neg},F] \mid [{\land},F,F] \mid [{\lor},F,F] \mid [{\to},F,F] \mid [{\leftrightarrow},F,F]$$

**Ejemplo:**
Una fórmula en notación infija como $X_{inf}$ se puede representar en notación prefija o como una lista anidada. Dada la fórmula: $X_{inf}=((p_{2}\to (\neg p_{3}))\land (\neg (p_{1}\lor p_{2})))$, su versión en listas anidadas sería:

$$X_{list} = [\land,[\to,p_{2},[\neg,p_{3}]],[\neg,[\lor,p_{1},p_{2}]]]$$
