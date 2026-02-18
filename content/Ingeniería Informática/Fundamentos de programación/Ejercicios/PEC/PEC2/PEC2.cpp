/**************************************
* NOMBRE: #Marcos#
* PRIMER APELLIDO: #Santos#
* SEGUNDO APELLIDO: #Piñeiro#
* DNI: #51162086N#
* EMAIL: #msantos937@alumno.uned.es#
***************************************/

#include<stdio.h>

typedef enum TipoCaracter { Arroba, Punto1, LetraO, Punto2 };

TipoCaracter CalcularCaracter(int numero) {

  return TipoCaracter(numero % 4);
}

void ImprimirCaracter(TipoCaracter caracter) {
  switch (caracter) {
    case Arroba:
      printf("@");
      break;
    case Punto1:
    case Punto2:
      printf(".");
      break;
    case LetraO:
      printf("o");
      break;
    default:
      printf("?");
  }
}

void Espaciar(int espacios) {
  for (int i = 0; i < espacios; i++) {
    printf(" ");
  }
}

int main() {

  TipoCaracter caracter;

  int lado;

  printf("�Lado del Rombo? ");
  scanf("%2d", &lado);
  printf("\n");

  if (lado <= 0 || lado > 20) {
    printf("El lado del rombo debe de estar entre 1 y 20");
  } else {
    for (int i = 0; i <= lado - 1; i++) {

      Espaciar(lado - i - 1);

      for (int e = i; e >= 0; e--) {
        caracter = CalcularCaracter(i - e);
        ImprimirCaracter(caracter);
      }

      for (int e = 1; e <= i; e++) {
        caracter = CalcularCaracter(i - e);
        ImprimirCaracter(caracter);
      }

      printf("\n");
    }

    for (int i = lado - 2; i >= 0; i--) {

      Espaciar(lado - i - 1);

      for (int e = i; e >= 0; e--) {
        caracter = CalcularCaracter(i - e);
        ImprimirCaracter(caracter);
      }

      for (int e = 1; e <= i; e++) {
        caracter = CalcularCaracter(i - e);
        ImprimirCaracter(caracter);
      }

      printf("\n");
    }
  }
}
