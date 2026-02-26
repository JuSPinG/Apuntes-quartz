> **Nota:** Cada fórmula es verdadera o falsa.
> En Lógica de Proposiciones, **a toda fórmula** (atómica o compuesta) se le puede asignar un valor de verdad entre dos posibles: {verdadero, falso}, que también se representan respectivamente como $\{v,f\}$ o $\{1,0\}$.

## Dos valores de verdad

Una declaración como *‘llueve y es de día’* se puede formalizar como $(p\wedge q)$. Y en esta fórmula se distinguen 3 proposiciones lógicas distintas: dos atómicas y una compuesta.

1. *‘llueve’*: $p$
2. *‘es de día’*: $q$
3. *‘llueve y es de día’*: $(p\land q)$

Estas tres proposiciones, como toda fórmula proposicional, admitirán ser evaluadas como verdaderas o falsas: 

1. *'llueve'* se puede considerar verdadera o falsa.
2. *'es de día'* se puede considerar verdadera o falsa.
3. la proposición compuesta *'llueve y es de día'* también se puede evaluar como verdadera o falsa.

## Asignación a fórmulas atómicas

El valor de verdad de una fórmula atómica es discrecional: el observador decide si ocurre o no ocurre lo que la fórmula $p_{k}$ declara.

> **Definición:** Asignación a fórmulas atómicas.
> 
> Una *asignación* es una función que asigna a cada fórmula atómica un valor de verdad en $\{1,0\}$. Así, una asignación fija para cada $p_{k}$ un valor $1$ o $0$.
> 
> Las proposiciones constantes ($\bot$ y $\top$) tienen un valor fijo en toda asignación: el valor de verdad para $\bot$ es 0 (falso) y el valor de verdad para $\top$ es 1 (verdadero).

**Ejemplo:** La figura muestra dos funciones *asignación* sobre un mismo conjunto de fórmulas atómicas $A=\{\top,\bot,p,q,r,s\}$. Para distinguirlas, se han denominado $asign_{a}$ (a la izquierda) y $asign_{b}$ (a la derecha). En ambas funciones, por definición, se debe asignar a $\top$ el valor de verdad 1 y a $\bot$ el valor de verdad 0.

Este conjunto $A$ de fórmulas atómicas se puede haber usado para representar los siguientes enunciados: $p$ ('llueve'), $q$ ('es martes'), $r$ ('es de día') y $s$ ('siento frío'). Y en la figura ocurre que $asign_{a}(s)=1$ mientras que $asign_b(s)=0$. Es decir, ambas perspectivas sobre lo que ocurre en el mundo son iguales salvo que en $asign_{a}$ es verdad que 'siento frío' y en $asign_{b}$ no.

![Dos funciones asignación sobre las fórmulas atómicas: $asign_{a}$ (izquierda) y $asign_{b}$ (derecha)](img/dos-funciones-asignacion.svg)

## Fórmulas con una conectiva

### Conjunciones

El valor de verdad de una conjunción como *'es martes y siento frío'* no se reconoce como independiente del valor de verdad de sus componentes. Tan sólo se acepta como verdadera cuando ambas componentes se reconocen como verdaderas.

### Disyunciones

Algo similar ocurre con disyunciones como *'es martes o es de día'*. Tan sólo se reconoce en su conjunto como falsa si ambas componentes no ocurren, es decir, son ambas falsas. En cualquier otro caso, en que es verdadera sólo una de ellas o ambas, la disyunción se acepta como verdadera.

La siguiente figura presenta el valor de verdad de $(p\lor q)$ respecto a las 4 posibles asignaciones a sus dos componentes $(p,q)$. El nodo raíz $(p\lor q)$ resulta verdadero (verde) en toda asignación salvo una: cuando ambos nodos componentes son falsos (rojo).

![Valor de verdad de una disyunción](img/arbol-p-o-q.svg)

### Condicionales

Los resultados anteriores se recogen bajo las columnas $(p\land q)$ y $(p\lor q)$ en la siguiente tabla, para las cuatro asignaciones distintas desde las que se puede "contemplar" estas fórmulas. La columna $(p\to q)$ muestra respectivamente la evaluación fijada para un condicional.

 p | q | (p∧q) | (p∨q) | (p→q) | (p↔q)
-------------------|---|---|-------|-------|-------|-------
 asign_{11} →      | 1 | 1 |   1   |   1   |   1   |   1
 asign_{10} →      | 1 | 0 |   0   |   1   |   0   |   0
 asign_{01} →      | 0 | 1 |   0   |   1   |   1   |   0
 asign_{00} →      | 0 | 0 |   0   |   0   |   1   |   1
