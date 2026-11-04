---
aliases: []
---
# Conceptos básicos

Backus-Naur Form (BNF) se define como un metalenguaje lógico que permite describir formalmente la sintaxis de lenguajes de programación, lenguajes lógicos, y otros sistemas formales. Es una notación que define las reglas de producción que especifican cómo los símbolos de un lenguaje pueden combinarse para formar sentencias válidas.

Si, por ejemplo, se necesita definir un conjunto de posibilidades numéricas de la constante "$a$", entonces, así se ordenaría en BNF:

$$\texttt{a::=0|1|2|3|4}$$

En este caso, en la producción de "$a$", estamos indicando, gracias al operador "$::=$", que esta puede ser "$0$", pero también "$1$", "$2$", "$3$" o "$4$". Estas instrucciones de opcionalidad, se especifican al usar el operador "$|$".

# Operadores

- Operador de asignación, "$\texttt{a::=X}$": Define una asignación de  "$a$" entre el conjunto, sea vació o no, de $\texttt{X}$.
- Operador de alternativa, "$\texttt{a|b|c|...}$": Se encarga de presentar una alternativa entre los elementos, en este caso, entre $\texttt{a}$, $\texttt{b}$, $\texttt{c}$ y los que sean.
- Operador de repetición, "$\texttt{\langle X\rangle}$": Representa una repetición del conjunto $\texttt{X}$.
- Operador de opcionalidad, "$\texttt{[X]}$": Nos permite añadir o no añadir $\texttt{X}$ a la definición.
- Operador de agrupación, $\texttt{(ab)}$: Establece una agrupación entre, en este caso, $\texttt{a}$ y $\texttt{b}$, aunque pueden introducirse más.

A partir de aquí, se pueden hacer definiciones muy exactas.

## Ejemplo

![[2.4 Representación de valores constantes#2.4.1 Valores numéricos enteros]]

Se pueden encontrar más ejemplos en [[2.4 Representación de valores constantes]].