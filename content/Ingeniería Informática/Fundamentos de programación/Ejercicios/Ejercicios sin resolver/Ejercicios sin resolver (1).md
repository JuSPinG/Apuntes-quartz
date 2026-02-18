Enlace: [[Fundamentos de programación.pdf#page=157&selection=0,0,6,3|Fundamentos de programación, página 157]].
# 1. Tablas de multiplicar

Enlace: [[Fundamentos de programación.pdf#page=157&selection=174,3,226,14|Fundamentos de programación, página 157]].

## Planteamiento del programa y [[4.3 Desarrollo por refinamientos sucesivos|refinamientos sucesivos]]

1. Imprimir los 10 primeros números números de la tabla de un número introducido por el usuario →
	1. Obtener el número introducido por el usuario →
		1. Preguntar al usuario por su número.
			1. `printf("De que numero quieres obtener la tabla?: ");`
		2. Guardarlo en una variable.
			1. `scanf("%d", &num);`
	2. Imprimir el embellecedor.
		1. `printf("Tabla de multiplicar de %d\n", num);`
		2. `printf("===========================\n");`
	4. Imprimir la tabla de números, de x1 a x10 →
		1. `for (int i = num; i <= 10; i++) {`
		2. `  printf("%5d  x  %2d  =  %2d\n", num, i, num*i);`
		3. `}`
## Programa

```c
/************************************************************
* Nombre: Tabla de multiplicar
*
* Descripción: Es un programa que le pide al usuario
*   un número del que posteriormente se obtendrá
*   su tabla de multiplicar, del 1 al 10
************************************************************/

#include<stdio.h>

int main() {

  int num;

  /*-- Preguntar al usuario por su número --*/
  printf("De que numero quieres obtener la tabla?: ");
  scanf("%d", &num);

  /*-- Imprimir el embellecedor --*/
  printf("Tabla de multiplicar de %d\n", num);
  printf("===========================\n");

  /*-- Imprimir números de la tabla, del 1, al 10 --*/
  for (int i = 1; i <= 10; i++) {
    printf("%5d  x  %2d  =  %2d\n", num, i, num*i);
  }
}
```

# 2. Tablas de multiplicar

Enlace: [[Fundamentos de programación.pdf#page=158&selection=104,0,145,8|Fundamentos de programación, página 158]].

```c
/**************************************************************
 * Programa: Obtener máximo común divisor
 *
 * Descripción:
 *   Este programa se encarga de obtener el máximo común
 *   divisor entre 2 números dados por el usuario
 **************************************************************/

#include<stdio.h>

int main() {
	int num1, num2;
	int res = -1;

	printf("Primer Numero? ");
	scanf("%d", &num1);

	printf("Segundo Numero? ");
	scanf("%d", &num2);

	if (num1 < num2) {
		num1 = num1 + num2;
		num2 = num1 - num2;
		num1 = num1 - num2;

		/*printf("%d, %d", num1, num2);*/
	}

	for (int i = 1; i <= num2; i++) {
		if (num2 % i == 0 && num1 % i == 0) {
			res = i;
		}
	}

	if (res == -1) {
		printf("No se ha encontrado maximo común divisor");
	} else {
		printf("El maximo comun divisor es: %d", res);
	}
}
```

# 5. Propiedades del triángulo

```c
/*************************************************************
 * Programa: Análisis de triángulos
 * 
 * Descripción:
 *   Analiza los lados del triángulo bajo los siguientes
 *   3 criterios: no forma triángulo, equilátero, isósceles
 *   escaleno y rectángulo
 *************************************************************/

#include<stdio.h>

const int MAX_Lados = 3; /* Puesto que vamos a analizar un triángulo */
typedef float TipoLongitudesLados[MAX_Lados];

void OrdenarVector(TipoLongitudesLados longitudesLados) {
	float aux;

	for (int i = 0; i < MAX_Lados; i++) {
		for (int j = 0; j < MAX_Lados; j++) {
			if (longitudesLados[i] > longitudesLados[j]) {

				aux = longitudesLados[i];
				longitudesLados[i] = longitudesLados[j];
				longitudesLados[j] = aux;
			}
		}
	}
}

bool EsPosible(TipoLongitudesLados longitudesLados) {
	for (int i = 0; i < MAX_Lados - 2; i++) {
		if (longitudesLados[0 + i] > longitudesLados[1 + i] + longitudesLados[2 + i]) {
			return 0;
		}
	}

	return 1;
}

int LadosIguales(TipoLongitudesLados longitudesLados) {
	int res = 0;

	for (int i = 0; i < MAX_Lados; i++) {
		for (int j = 0; j < MAX_Lados; j++) {
			if (longitudesLados[i] == longitudesLados[j + i] && i + j < MAX_Lados) {
				res++;
			}
		}
	}

	return res / 2;
}

int main() {
	TipoLongitudesLados longitudesLados;

	for (int i = 0; i < MAX_Lados; i++) {
		printf("Introduce la longitud del lado %d: ", i + 1);
		scanf(" %f", &longitudesLados[i]);
	}

	OrdenarVector(longitudesLados);
	
	if (!EsPosible(longitudesLados)) {
		printf("Formar esa figura es imposible");

		return 0;
	}

	printf("La figura tiene %d lados iguales", LadosIguales(longitudesLados));
}

```

Siguiente: [[7.1 Concepto de subprograma]].