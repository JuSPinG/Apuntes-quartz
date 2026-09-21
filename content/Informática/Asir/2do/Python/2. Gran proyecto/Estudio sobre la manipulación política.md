---
aliases:
  - Estudio sobre las variables que influyen en la desconfianza hacia la democracia, de acuerdo con el posible nuevo orden mundial y las intenciones de los ideólogos del movimiento «Dark Enlightment»
---
# Enlaces de interés

1. [Portal de datos ESS](https://ess.sikt.no/en/datafile/ffc43f48-e15a-4a1c-8813-47eda377c355?tab=0&elems=bf56efff-e218-4606-ae55-e677dc0bf2d9.d43d426d-183e-4da8-a1c8-26acb61f111d).
2. [Descripciones rápidas](https://ess.sikt.no/en/data-builder/?tab=variables&rounds=0+1+2+3+4+5+6+7+8+9+10+11&seriesVersion=920&variables=0+1+2+3+4+5+6+7+8+9).
# Introducción

El _European Social Survey Data Portal_ (ESS) es una organización académica encargada de recoger datos en encuestar de varios países de la Unión Europea. Llevan recogiendo y tratando datos desde 2002, lo que de sus datos una fuente confiable e interesante. Poseen 11 archivos con aproximadamente 45.000 entradas cada uno, por lo que el recuento total de datos es inmenso, y perfecto para sacar relaciones. Los programas que he desarrollado permiten cruzar todas las correlaciones entre todas las variables (todos los datos se pueden encontrar en [[resultados.txt]]).

Abordar los significados de todas las correlaciones es inviable, pues estas son 567, y aunque no es necesario cruzarlas todas (como la variable "_name_"), el resultado obtenido es de 536.656 entradas, cantidad que es inasumible para mí. La cuestión de este trabajo, entonces, consistirá en analizar un número concreto y reducido de las variables que más interesantes me parezcan, a mi criterio subjetivo, aunque si le lector lo desea, podrá completar mi trabajo.
# Variables de interés

1. `mascfel` (13).
2. `femifel`.
3. `liklead`.
4. `likrisk`.
5. `netusoft`.
6. `netustm`.
7. `fineqpy`.
8. `actrolga`.
9. `gndr`.
10. `alcbnge`.
11. `aesfdrk`.
12. `cgtsmok`.
13. `alcwkdy`.
14. `alcwknd`.
15. `actcomp`.
16. `lrscale`.
17. `polintr`.
18. `sothnds`.
19. `lrscale`.
20. `euftf`.
21. `stfdem`.

## Interés en `mascfel` y `femifel`

`mascel` es el alias de "_how masculine respondent feels_", es decir, de lo masculino que se siente el entrevistado. Las variables que se relacionan con mayor fuerza por encima de 0 son:

1. `jbexpvi` - `mascfel`: 0.25327006127498247.
2. `likrisk` - `mascfel`: 0.20981696036912204.
3. `jbexpmc` - `mascfel`: 0.20459601759246.
4. `jbexevl` - `mascfel`: 0.20326908170363456.
5. `jbexebs` - `mascfel`: 0.20208815532678687.
6. `liklead` - `mascfel`: 0.1890354740430699.
7. `mascfel` - `wbrgwrm`: 0.17817883601533482.
8. `jbexevh` - `mascfel`: 0.17757323191322452.
9. `jbexevc` - `mascfel`: 0.17392812175168057.
10. `hswrkp` - `mascfel`: 0.1710834252739645.
11. `fineqpy` - `mascfel`: 0.12685057871998742.
12. `actrolga` - `mascfel`: 0.11955063040318467.
13. `eqparep` - `mascfel`: 0.11920381789918262.
14. `jbexecp` - `mascfel`: 0.10634792039834283.
15. `dshltnt` - `mascfel`: 0.10517155085289902.
16. `cptppola` - `mascfel`: 0.10351000183194553.

Mientras que `femifel` es el alias de "_how feminine respondent feels_", que se podría traducir a "lo femenino que se siente el entrevistado". Las variables que se relacionan con mayor fuerza por encima de 0 son:

1. `femifel` - `gndr`: 0.8595449286106882
2. `femifel` - `nobingnd`: 0.7375134658688233
3. `femifel` - `icgndra`: 0.30078446387180113
4. `alcbnge` - `femifel`: 0.20043987512729852
5. `actcomp` - `femifel`: 0.18023238515561413
6. `aesfdrk` - `femifel`: 0.17123520970691616
7. `femifel` - `sothnds`: 0.1632147088705347
8. `femifel` - `hswrk`: 0.16144827900910563
9. `alcwkdy` - `femifel`: 0.1600096496641665
10. `alcwknd` - `femifel`: 0.15951082695741187
11. `cgtsmok` - `femifel`: 0.15708038463934781
12. `femifel` - `jbexent`: 0.15190461343231787
13. `femifel` - `polintr`: 0.13205779165823683
14. `eqmgmbg` - `femifel`: 0.13097728291107616
15. `femifel` - `njbspv`: 0.1300150261397922
16. `eqpolbg` - `femifel`: 0.12203824118811371
17. `femifel` - `jbspv`: 0.11958686319334048
18. `emplno` - `femifel`: 0.11705000869839277
19. `femifel` - `jbexpnt`: 0.10194133572624436

Analizaré ambas variables, sentimiento de masculinidad y sentimiento de feminidad, a la vez para poder sacar conclusiones más interesantes.

### `jbexpvi` - `mascfel`/`femifel`: Exposición a vibraciones, herramientas manuales y maquinaria junto al sentimiento de masculinidad y feminidad

`jbexpvi` se traduce a "_in any job, ever exposed to: vibrations from hand tools or machinery_", que se podría traducir a lo que he puesto anteriormente. El resultado de `femifel` no ha sido indexado, pero es el siguiente: `femifel` - `jbexpvi`: -0.2656398091433416.

Si comparamos un resultado con el otro, podemos llegar a la conclusión que `jbexpvi` da más feminidad que la masculinidad que aporta:

$$\left |\text{mascfel - jbexpvi}\right | < \left |\text{femifel - jbexpvi}\right | \Rightarrow 0.25327006127498247 < 0.2656398091433416$$

### `likrisk` - `mascfel`/`femifel`: Exposición a vibraciones, herramientas manuales y maquinaria junto al sentimiento de masculinidad y feminidad

`likrisk` ("_I like to take risks, to what extent_") podría ser una de mis variables favoritas, y que mejor pueda describir parte del «estereotipo masculino».

```sh
cat resultados.txt | grep mascfel | grep likrisk
```