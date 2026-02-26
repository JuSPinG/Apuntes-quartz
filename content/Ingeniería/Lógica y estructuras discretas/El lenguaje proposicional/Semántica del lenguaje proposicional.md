> [!note] Recursos de estudio
> - [Vídeos](./prop-semantica-videos.md)
> - Teoría y ejemplos (en estas páginas)
> - [Autoevaluación](./prop-semantica-test.md)
> - PEC y foros (en el grupo de estudio)

La **semántica** de un lenguaje formal facilita las normas para asignar significado a sus expresiones. En Lógica de Proposiciones, el interés principal es determinar si una fórmula es verdadera o falsa respecto a una perspectiva de evaluación específica.

Esta sección se centra en la construcción de estas "perspectivas de evaluación" y el cálculo del valor de verdad de una fórmula en cada una de ellas.

## Objetivos
Los objetivos prácticos de esta sección son los siguientes:

1. **Calcular el valor de verdad de una fórmula (respecto a una asignación)**  
   Dada una asignación específica (una "perspectiva de evaluación" determinada), se puede calcular con precisión el valor de verdad de la fórmula.

2. **Calcular el valor de verdad de una fórmula (respecto a cualquier asignación posible)**  
   Este conjunto de resultados, que abarca todas las perspectivas de evaluación posibles, se organiza y presenta en forma de **tabla de verdad** de la fórmula.

3. **Comparar el valor de verdad de varias fórmulas (respecto a una misma asignación)**  
   En una asignación dada, algunas fórmulas serán verdaderas y otras falsas, lo que permite una comparación de sus valores de verdad.

> [!definition] Perspectiva de evaluación
> Una **perspectiva de evaluación** es una asignación de valores de verdad para las variables proposicionales dentro de una fórmula. Dado un conjunto de proposiciones $\{p, q, r, \ldots\}$, una perspectiva de evaluación define un valor de verdad (verdadero o falso) para cada una de ellas, permitiendo evaluar la fórmula de acuerdo con estos valores asignados.

> [!definition] Tabla de verdad
> Una **tabla de verdad** es una representación sistemática de todos los posibles valores de verdad de una fórmula lógica en función de todas las combinaciones posibles de valores de verdad de sus variables proposicionales.

> [!tip] Nota
> Las tablas de verdad se usan para determinar si una fórmula es **válida**, **satisfacible**, o **contradictoria** según los resultados que presente en cada combinación de valores de verdad.

$$
\text{Ejemplo:} \quad p \land (q \lor \neg r)
$$