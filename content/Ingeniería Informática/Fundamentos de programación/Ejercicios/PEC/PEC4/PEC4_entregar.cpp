/**********************************************
* NOMBRE: #Marcos#
* PRIMER APELLIDO: #Santos#
* SEGUNDO APELLIDO: #Piñeiro#
* DNI: #51162086N#
* EMAIL: #msantos937@alumno.uned.es#
***********************************************/

#include<stdio.h>
#include<ctype.h>
#include<string.h>
#include<stdlib.h>

/*============================================
              ZONA DE DELCARACION
  ============================================*/

/*------------ Definicion de constantes ------------*/
const int MAX_Edificios = 5;
const int MAX_Apartamentos = 20;

const int MAX_Anno = 3000;
const int LongitudSemana = 7;
const int SemanasEnCalendario = 6;

/*------------ Definicion de tipos ------------*/
typedef char TipoNombre[21];
typedef char TipoReferencia[6];

typedef int TipoIdentificador;
typedef int TipoNumerosApartamentos[MAX_Apartamentos]; /* Podíra haber usado una lista enlazada en vez de una matriz,
                                                          pero algunas partes del programa se volvían demasiado complejas */

typedef enum TipoMes { Enero, Febrero, Marzo, Abril, Mayo, Junio, Julio, Agosto, Septiembre, Octubre, Noviembre, Diciembre };
typedef int TipoAnno;
typedef int TipoDia;

/*------------ Declaración TAD ------------*/
/*--  Estructura de TipoInterfaz  --*/
typedef struct TipoInterfaz {

  void Espaciar(int numero);
  char ImprimirMenuInicio();
};

/* Funciones de TipoInterfaz */
/* los subprogramas mantienen el orden de declaración de interfaz */

/*-- Procedimiento de Espaciar, sirve para imprimir espacios en masa  --*/
void TipoInterfaz::Espaciar(int numero) {
  for (int i = numero; i >= 1; i--) {
    printf(" ");
  }
}

/*--  Función de ImprimiMenuInicio, sirve para imprimir el menú todo junto a la vez, útil para la limpieza visual --*/
char TipoInterfaz::ImprimirMenuInicio() {
  char opcion;

  printf("GesRAE: Gestion de Reservas Apartamentos-Edificios\n\n");

  Espaciar(5);
  printf("Editar Edificio");
  Espaciar(17);
  printf("(Pulsar E)\n");

  Espaciar(5);
  printf("Listar Edificios");
  Espaciar(16);
  printf("(Pulsar L)\n");

  Espaciar(5);
  printf("Apartamentos Disponibles");
  Espaciar(8);
  printf("(Pulsar A)\n");

  Espaciar(5);
  printf("Reservar Apartamento");
  Espaciar(12);
  printf("(Pulsar R)\n");

  Espaciar(5);
  printf("Reservas Mensuales Apartamento");
  Espaciar(2);
  printf("(Pulsar M)\n");

  Espaciar(5);
  printf("Salir");
  Espaciar(27);
  printf("(Pulsar S)\n");

  printf("\nTeclear una opcion valida (E|L|A|R|M|S)? ");
  scanf(" %c", &opcion);

  return opcion; /* Retorna la opción que el usuario elije */
}

/*--  Estructura de TipoFecha  --*/
typedef struct TipoFecha {
  TipoDia dia;
  TipoMes mes;
  TipoAnno anno;

  bool ComprobarDia(TipoFecha fecha);
  bool ComprobarMes(TipoMes mes);
  bool ComprobarAnno(TipoAnno anno);
  bool ComprobarBisiesto(TipoAnno anno);

  int ObtenerLongitudMes(TipoMes mes, TipoAnno anno);
  int ObtenerLongitudAnno(TipoAnno anno);

  int ObtenerDias(TipoFecha fecha);
  TipoFecha ObtenerFecha(int dias);
};

/* Funciones de TipoFecha */
/* los subprogramas mantienen el orden de claracion de interfaz */

/*--  Función de ComprobarDia, nos sirve para saber si el día puede existir o no  --*/
bool TipoFecha::ComprobarDia(TipoFecha fecha) {
  if (fecha.dia <= 0 || fecha.dia > ObtenerLongitudMes(fecha.mes, fecha.anno)) {
    return false;
  } else {
    return true;
  }
}

/*--  Función de CoomprobarMes, importante para no seleccionar meses inexistentes  --*/
bool TipoFecha::ComprobarMes(TipoMes mes) {
  if (mes < 0 || mes >= 12) {
    return false;
  } else {
    return true;
  }
}

/*--  Función de CoomprobarAnno, así se comprueba que el año sea correcto  --*/
bool TipoFecha::ComprobarAnno(TipoAnno anno) {
  if (anno < 1601 || anno > MAX_Anno) {
    return false;
  } else {
    return true;
  }
}

/*--  Función de ComprobarBisiesto, muy necesario para ajustar los desfases  --*/
bool TipoFecha::ComprobarBisiesto(TipoAnno anno) {
  return (anno % 4 == 0 && anno % 100 != 0) || (anno % 400 == 0);
}

/*--  Función de ObtenerLongitudMes, si es necesario calcular distancias entre fechas, es necesario abstraerlo por años, meses, y días  --*/
int TipoFecha::ObtenerLongitudMes(TipoMes mes, TipoAnno anno) {
  switch (mes) {
    case Enero:
    case Marzo:
    case Mayo:
    case Julio:
    case Agosto:
    case Octubre:
    case Diciembre:
      return 31;
      break;
    case Abril:
    case Junio:
    case Septiembre:
    case Noviembre:
      return 30;
      break;
    case Febrero:
      if (ComprobarBisiesto(anno)) {
        return 29;
      } else {
        return 28;
      }
      break;
    default:
      return -1;
  }
}

/*--  Función de ObtenerLongitudAnno, se usa para saber cuántos días tiene un año  --*/
int TipoFecha::ObtenerLongitudAnno(TipoAnno anno) {
  return 365 + int(ComprobarBisiesto(anno)); /* Si es true, se pasa a int, donde equivale a 1, así se simplifica un poco el subprograma */
}

/*--  Función de ObtenerDias, esto sirve para pasar de una fecha a su número de días, partiendo desde el 1/1/1601  --*/
int TipoFecha::ObtenerDias(TipoFecha fecha) {
  int contadorDias = 0;

  for (int a = 1601; a < fecha.anno; a++) {
    contadorDias = contadorDias + ObtenerLongitudAnno(a);
  }

  for (int m = Enero; m < fecha.mes; m++) {
    contadorDias = contadorDias + ObtenerLongitudMes(TipoMes(m), fecha.anno);
  }

  if (fecha.dia <= 0) {
    fecha.dia = 1;
  }
  for (int d = 1; d <= fecha.dia; d++) {
    contadorDias++;
  }

  return contadorDias;
}

/*--  Función de ObtenerFecha, igual que la función de antes pero al reves, se introduce un número y sale una fecha  --*/
TipoFecha TipoFecha::ObtenerFecha(int dias) {
    int contadorDias = 0;
    int diasMes;
    TipoFecha fecha;

    /* A continuación, se anidan varios for para poder extraer la fecha correcta */
    for (int a = 1601; a <= MAX_Anno; a++) {
        if (contadorDias + ObtenerLongitudAnno(TipoAnno(a)) > dias) {
            fecha.anno = TipoAnno(a);
            for (int m = Enero; m <= 12; m++) {
        diasMes = ObtenerLongitudMes(TipoMes(m), fecha.anno);
        if (contadorDias + diasMes > dias) {
          fecha.mes = TipoMes(m);
          fecha.dia = TipoDia(dias - contadorDias);
          if (fecha.dia <= 0) {
            fecha.mes = TipoMes(m - 1);
            fecha.dia = TipoDia(ObtenerLongitudMes(TipoMes(m - 1), fecha.anno) + fecha.dia);
          }
          return fecha;
        }
                contadorDias = contadorDias + diasMes;
            }
        }
        contadorDias = contadorDias + ObtenerLongitudAnno(TipoAnno(a));
    }
    return fecha;
}


/*-- Estructura del puntero --*/
typedef struct TipoDiasReservados {
  int N_Habitacion;
  int calidadHabitacion;
  int N_deReserva;

  TipoFecha fecha;

  TipoDiasReservados* siguiente;
};

typedef TipoDiasReservados* TipoPuntero;

/*--  Estructura de TipoEdificio  --*/
typedef struct TipoEdificio {
  TipoNombre nombre;
  TipoDiasReservados* informacionReservado;

  int N_apartamentoBasico, N_apartamentoNormal, N_apartamentoLujo;
  bool baja, iniciado;
};

/*--  Estructura del conjunto de TipoEdificio  --*/
typedef struct TipoConjuntoEdificios {
  TipoEdificio edificios[MAX_Edificios]; /* Aquí declaro una matriz de edificios, esto resulta muy cómodo a la hora de desarrollar el programa */

  bool ComprobarIdentificador(TipoIdentificador identificador);
  TipoEdificio ComprobarDisponibilidad(TipoEdificio edificio, TipoFecha fecha);

  /* De forma orientativa, cada una de estos procedimientos corresponden a cada una de las posibles respuestas del cliente en el menú */
  void EditarEdificio(TipoConjuntoEdificios &edificio);
  void ListarEdificios(TipoConjuntoEdificios edificios);
  void ConsultarReservas(TipoConjuntoEdificios edificio);
  void HacerReserva(TipoConjuntoEdificios &edificio);

};

/* Funciones de TipoEdificio */
/* los subprogramas mantienen el orden de declaracion de interfaz */

/*--  Función de ComprobarIdentificador, es necesaria para comprobar un identificador correcto  --*/
bool TipoConjuntoEdificios::ComprobarIdentificador(TipoIdentificador identificador) {
  return (identificador >= 0) && (identificador < MAX_Edificios);
}

/*--  Función de ComprobarDisponibilidad, como su nombre indica, comprueba cuántos apartamentos están disponibles para una fecha y edificio concretos  --*/
TipoEdificio TipoConjuntoEdificios::ComprobarDisponibilidad(TipoEdificio edificio, TipoFecha fecha) {
  TipoPuntero cursor = edificio.informacionReservado;
  TipoEdificio edificioAUX = edificio; /* Me apollo en un edificio auxiliar para poder guardar algunos datos */

  while (cursor != NULL) { /* Es necesario recorrerse una lista enlazada para obtener los datos de las reserva */
    if (cursor->fecha.anno == fecha.anno && cursor->fecha.mes == fecha.mes && cursor->fecha.dia == fecha.dia) {

      if (cursor->calidadHabitacion == 0) {
        edificioAUX.N_apartamentoBasico--;
      } else if (cursor->calidadHabitacion == 1) {
        edificioAUX.N_apartamentoNormal--;
      } else if (cursor->calidadHabitacion == 2) {
        edificioAUX.N_apartamentoLujo--;
      }
    }
    cursor = cursor->siguiente;
  }

  return edificioAUX;
}

/*--  Procedimiento de EditarEdificio, esta función crea una edificio y hace ciertas comprobaciones para que todo esté correcto  --*/
void TipoConjuntoEdificios::EditarEdificio(TipoConjuntoEdificios &edificio) {
  TipoInterfaz interzaf;
  TipoEdificio edificioAUX;
  TipoIdentificador identificador;

  char respuesta;

  printf("Editar Edificio:\n\n");

  interzaf.Espaciar(5);
  printf("Identificador (numero entre 1 y 5)? ");
  scanf(" %d", &identificador);

  identificador--;

  if (!ComprobarIdentificador(identificador)) { /* Comprobación de si identificador es posible */
    throw 1;
  }

  if (edificio.edificios[identificador].baja == true) {
    interzaf.Espaciar(10);
    printf("El edificio consultado esta dado de baja, quiere continuar (S/N)? ");
    scanf(" %c", &respuesta);

    /*
    No me ha quedado muy claro que tiene que suceder (o no suceder) cuando un edificio esta de baja,
    por lo que he introducido este fragmento para que el cliente pueda decidir nuevamente.
    */

    if (toupper(respuesta) == 'S') {
      edificio.edificios[identificador].baja = false;
    } else {
      printf("Operacion cancelada\n");
      return;
    }
  }
  /*-- Se ejecuta el menú de selección --*/
  interzaf.Espaciar(5);
  printf("Nombre (entre 1 y 20 caracteres)? ");
  scanf(" %s", &edificioAUX.nombre);

  interzaf.Espaciar(5);
  printf("Numero de Apartamentos Basicos? ");
  scanf(" %d", &edificioAUX.N_apartamentoBasico);

  interzaf.Espaciar(5);
  printf("Numero de Apartamentos Normales? ");
  scanf(" %d", &edificioAUX.N_apartamentoNormal);

  interzaf.Espaciar(5);
  printf("Numero de Apartamentos Lujo? ");
  scanf(" %d", &edificioAUX.N_apartamentoLujo);

  if (edificioAUX.N_apartamentoBasico + edificioAUX.N_apartamentoNormal + edificioAUX.N_apartamentoLujo > MAX_Apartamentos) {
    throw 2;
  } else if (edificioAUX.N_apartamentoBasico <= 0 && edificioAUX.N_apartamentoNormal <= 0 && edificioAUX.N_apartamentoLujo <= 0) {
    edificio.edificios[identificador].baja = true;
    printf("El edificio se ha dado de baja exitosamente\n");
    return;
  }

  printf("\nIMPORTANTE: Esta opcion borra los datos anteriores. \nSon correctos los nuevos datos (S/N)? ");
  scanf(" %c", &respuesta);

  if (toupper(respuesta) == 'S') { /* Aquí se sobreescribe el edificio, me apoyo de un edificio auxiliar para poder guardar los datos */
    strcpy(edificio.edificios[identificador].nombre, edificioAUX.nombre);
    edificio.edificios[identificador].N_apartamentoBasico = edificioAUX.N_apartamentoBasico;
    edificio.edificios[identificador].N_apartamentoNormal = edificioAUX.N_apartamentoNormal;
    edificio.edificios[identificador].N_apartamentoLujo = edificioAUX.N_apartamentoLujo;
    edificio.edificios[identificador].iniciado = true;
    edificio.edificios[identificador].baja = false;

    printf("Datos guardados con exito\n");
  } else {
    printf("Operacion cancelada\n");
  }
}

/*--  Procedimiento de ListarEdificios, lista los edificios disponibles, por esto me los declaro en una matriz  --*/
void TipoConjuntoEdificios::ListarEdificios(TipoConjuntoEdificios edificio) {
  bool hayEdificios = false;

  for (int i = 0; i < MAX_Edificios; i++) {
    if (edificio.edificios[i].iniciado == true && edificio.edificios[i].baja == false) { /* Aquí se comprueba si el edificio existe, para evitar problemas de obtener datos que no son */
      if (hayEdificios == false) {
        printf("Id                 Nombre     Aptos Basicos     Aptos Normales     Aptos de Lujo\n");
        hayEdificios = true;
      }
      printf("\n%d   %20s          %4d             %4d               %4d", i+1, edificio.edificios[i].nombre, edificio.edificios[i].N_apartamentoBasico, edificio.edificios[i].N_apartamentoNormal, edificio.edificios[i].N_apartamentoLujo);
    }
  }
  if (hayEdificios == false) { /* Así se presenta que no hay edificios */
    printf("No hay edificios disponibles\n");
  }
  printf("\n\n");
}

/*--  Procedimiento de ConsultarReservas, consulta las reservas que hay disponibles, se usa la función ComprobarDisponibilidad declarada anteriormente  --*/
void TipoConjuntoEdificios::ConsultarReservas(TipoConjuntoEdificios edificio) {
  int longitud;
  int disponibilidadCorrecta = 0; /* Esto nos servirá para saber si el edificio seleccionado tiene apartamentos disponibles */

  TipoIdentificador identificador;
  TipoInterfaz interfaz;
  TipoFecha fecha;
  TipoEdificio edificioSeleccionado, apartamentosLibres, edificioAUX;

  /*-- Impresión del menú y manejo de los datos obtenidos --*/
  printf("Apartamentos Disponibles: \n\n");

  interfaz.Espaciar(5);
  printf("Identificador de Edificio? ");
  scanf(" %d", &identificador);

  identificador--; /* En el programa, es una práctica habitual, obtener un dato y tratarlo */

  if (!ComprobarIdentificador(identificador)) { /* Comprobación del identificador */
    throw 1;
  }

  edificioSeleccionado = edificio.edificios[identificador];

  if (edificioSeleccionado.baja) { /* Comprobación de que el edificio se encuentre iniciado */
    throw 2;
  }

  /* Continuación del menú */
  interfaz.Espaciar(5);
  printf("Fecha Entrada: Dia? ");
  scanf(" %d", &fecha.dia);

  interfaz.Espaciar(5);
  printf("Fecha Entrada: Mes? ");
  scanf(" %d", &fecha.mes);

  interfaz.Espaciar(5);
  printf("Fecha Entrada: Ano? ");
  scanf(" %d", &fecha.anno);

  fecha.mes = TipoMes(int(fecha.mes) - 1); /* Más tratamiento de datos, el mes enero se corresponde con el 0, por eso se resta 1 */

  /* Comprobaciones de las fechas */
  if (!fecha.ComprobarAnno(fecha.anno)) {
    throw 5;
  } else if (!fecha.ComprobarMes(fecha.mes)) {
    throw 4;
  } else if (!fecha.ComprobarDia(fecha)) {
    throw 3;
  }


  interfaz.Espaciar(5);
  printf("Dias de duracion de la estancia? ");
  scanf(" %d", &longitud);

  edificioAUX = ComprobarDisponibilidad(edificioSeleccionado, fecha);

  for (int i = 0; i <= longitud; i++) {

    apartamentosLibres = ComprobarDisponibilidad(edificioSeleccionado, fecha.ObtenerFecha(fecha.ObtenerDias(fecha) + i));

    /* Los siguientes apartados detectan los apartamentos libres en un día específico, y si uno es mayor que el otro, ambos se establecen en el menor */
    if (edificioAUX.N_apartamentoBasico > apartamentosLibres.N_apartamentoBasico) {
      edificioAUX.N_apartamentoBasico = apartamentosLibres.N_apartamentoBasico;
    } else if (edificioAUX.N_apartamentoBasico < apartamentosLibres.N_apartamentoBasico) {
      apartamentosLibres.N_apartamentoBasico = edificioAUX.N_apartamentoBasico;
    }

    if (edificioAUX.N_apartamentoNormal > apartamentosLibres.N_apartamentoNormal) {
      edificioAUX.N_apartamentoNormal = apartamentosLibres.N_apartamentoNormal;
    } else if (edificioAUX.N_apartamentoNormal < apartamentosLibres.N_apartamentoNormal) {
      apartamentosLibres.N_apartamentoNormal = edificioAUX.N_apartamentoNormal;
    }

    if (edificioAUX.N_apartamentoLujo > apartamentosLibres.N_apartamentoLujo) {
      edificioAUX.N_apartamentoLujo = apartamentosLibres.N_apartamentoLujo;
    } else if (edificioAUX.N_apartamentoLujo < apartamentosLibres.N_apartamentoLujo) {
      apartamentosLibres.N_apartamentoLujo = edificioAUX.N_apartamentoLujo;
    }

    if (apartamentosLibres.N_apartamentoBasico + apartamentosLibres.N_apartamentoNormal + apartamentosLibres.N_apartamentoLujo > 0) {
      disponibilidadCorrecta++; /* Comprobación de que todo esté correcto, de que haya apartamentos disponibles */
    }
  }

  /* Por último, se imprimen los edificios disponibles, si hay */
  if (disponibilidadCorrecta > longitud) {
    printf("\nEl edificio %s desde el %d/%d/%d y %d dias despues de estancia, tendra disponibles: \n\n",
    edificioSeleccionado.nombre, fecha.dia, fecha.mes, fecha.anno, longitud);

    interfaz.Espaciar(5);
    printf("%d apartamentos de tipo Basico\n", apartamentosLibres.N_apartamentoBasico);

    interfaz.Espaciar(5);
    printf("%d apartamentos de tipo Normal\n", apartamentosLibres.N_apartamentoNormal);

    interfaz.Espaciar(5);
    printf("%d apartamentos de tipo Lujo\n", apartamentosLibres.N_apartamentoLujo);
  } else {
    printf("\nEl edificio %s no se encuentra disponible\n", edificioSeleccionado.nombre);
  }
}

/*--  Procedimiento de HaceReserva, aquí el programa obtiene e inserta los datos en el edificio  --*/
void TipoConjuntoEdificios::HacerReserva(TipoConjuntoEdificios &edificio) {
  char tipoApartamentoLetra;
  int tipoApartamento;
  int longitud, N_apartamentos;
  int contador = 0;
  int N_habitacionSeleccionada = 0;
  bool habitacionOcupada = false;
  int N_deReserva = 0;

  TipoIdentificador identificador;
  TipoInterfaz interfaz;
  TipoFecha fecha, fechaAux;
  TipoPuntero cursor, nuevo;
  TipoNumerosApartamentos habitacionesOcupadas;

  /*-- Vuelven los menús  --*/
  printf("Reservar Apartamento: \n\n");

  interfaz.Espaciar(5);
  printf("Identificador edificio? ");
  scanf(" %d", &identificador);

  /* Tratamiento de datos y comprobación del dato identificador */
  identificador--;

  if (!ComprobarIdentificador(identificador)) {
    throw 1;
  }

  if (edificio.edificios[identificador].baja) {
    throw 2;
  }

  interfaz.Espaciar(5);
  printf("Tipo de Apartamento (B-Basico/N-Normal/L-Lujo)? ");
  scanf(" %c", &tipoApartamentoLetra);

  tipoApartamentoLetra = toupper(tipoApartamentoLetra);

  /* Este fragmento se encarga de cambiar seleccionar los apartamentos en función de la letra */
  switch (tipoApartamentoLetra) {
    case 'B':
      tipoApartamento = 0;
      N_apartamentos = edificio.edificios[identificador].N_apartamentoBasico;
      break;
    case 'N':
      tipoApartamento = 1;
      N_apartamentos = edificio.edificios[identificador].N_apartamentoNormal;
      break;
    case 'L':
      tipoApartamento = 2;
      N_apartamentos = edificio.edificios[identificador].N_apartamentoLujo;
      break;
    default:
      throw 6;
  }

  interfaz.Espaciar(5);
  printf("Fecha Entrada: Dia? ");
  scanf(" %d", &fecha.dia);

  interfaz.Espaciar(5);
  printf("Fecha Entrada: Mes? ");
  scanf(" %d", &fecha.mes);

  interfaz.Espaciar(5);
  printf("Fecha Entrada: Ano? ");
  scanf(" %d", &fecha.anno);

  /*-- Tratamiento de la fecha --*/
  fecha.mes = TipoMes(int(fecha.mes) - 1);

  if (!fecha.ComprobarAnno(fecha.anno)) {
    throw 5;
  } else if (!fecha.ComprobarMes(fecha.mes)) {
    throw 4;
  } else if (!fecha.ComprobarDia(fecha)) {
    throw 3;
  }

  interfaz.Espaciar(5);
  printf("Dias de duracion de la estancia? ");
  scanf(" %d", &longitud);

  /*-- Verifica la disponibilidad para cada dia de la estancia --*/
  for (int i = 0; i < longitud; i++) { /**/
    fechaAux = fecha.ObtenerFecha(fecha.ObtenerDias(fecha) + i);
    cursor = edificio.edificios[identificador].informacionReservado;

    while (cursor != NULL) {
      if (cursor->fecha.anno == fechaAux.anno) {
      N_deReserva++; /* Esto servirá más adelante para saber qué número de reserva ocupa una reserva */
        if (cursor->fecha.mes == fechaAux.mes && cursor->fecha.dia == fechaAux.dia && cursor->calidadHabitacion == tipoApartamento) {
          habitacionOcupada = false; /* No confundir `habitacionOcupada` con `habitacionesOcupadas` */
          for (int i = 0; i < MAX_Apartamentos && !habitacionOcupada; i++) { /* La razón de este nuevo for radica en la necesidad de no procesar elementos repetidos */
            if (habitacionesOcupadas[i] == cursor->N_Habitacion) {
              habitacionOcupada = true;
            }
          }

          contador++;
        }
      }

      cursor = cursor->siguiente;
    }
  }

  /* Se recorre la lista enlazada hasta su último elemento */
  cursor = edificio.edificios[identificador].informacionReservado;
  while (cursor->siguiente != NULL) {
    cursor = cursor->siguiente;
  }

  if (contador == 0) { /* Es decir, si no hay reservas previas */
    for (int i = 0; i < longitud; i++) {
      fechaAux = fecha.ObtenerFecha(fecha.ObtenerDias(fecha) + i);
      nuevo = new TipoDiasReservados; /* Se crean los datos de la nueva reserva */
      nuevo->calidadHabitacion = tipoApartamento;
      nuevo->fecha = fecha.ObtenerFecha(fecha.ObtenerDias(fecha) + i);
      nuevo->N_Habitacion = N_habitacionSeleccionada;
      nuevo->N_deReserva = N_deReserva;
      nuevo->siguiente = NULL;

      cursor->siguiente = nuevo;
      cursor = cursor->siguiente; /* Se guarda la reserva */

    }
  } else { /* Es decir, si sí hay reservas */
    for (int i = 0; i < contador; i++) {
      for (int j = 0; j < contador; j++) {
        if (habitacionesOcupadas[j] == N_habitacionSeleccionada) {
          N_habitacionSeleccionada++; /* Esto sirve para ver qué habitaciones están seleccionadas, proceso que se omite si no hay reservas previas */

          if (N_habitacionSeleccionada >= N_apartamentos) {
            throw 7; /* En el caso de que la habitación salga del rango */
          }
        }
      }
    }

    for (int i = 0; i < longitud; i++) {
      fechaAux = fecha.ObtenerFecha(fecha.ObtenerDias(fecha) + i);
      nuevo = new TipoDiasReservados; /* Se crean los datos de las reservas */
      nuevo->calidadHabitacion = tipoApartamento;
      nuevo->fecha = fechaAux;
      nuevo->N_Habitacion = N_habitacionSeleccionada;
      nuevo->N_deReserva = N_deReserva;
      nuevo->siguiente = NULL;

      cursor->siguiente = nuevo;
      cursor = cursor->siguiente; /* Se guarda la reserva */
    }
  }

  /* Una vez hecha la reserva, se imprime su resumen */
  printf("\n");
  interfaz.Espaciar(10);
  printf("Datos de la Reserva: \n\n"); /* Vuelta a la impresión del menú */

  interfaz.Espaciar(5);
  printf("Numero de Reserva: %d/%d\n", N_deReserva + 1, fecha.anno);

  interfaz.Espaciar(5);
  printf("Edificio: %s (Id = %d)\n", edificio.edificios[identificador].nombre, identificador + 1);

  interfaz.Espaciar(5);
  printf("Referencia de Apartamento: APT");

  /* Pequeño arreglo para imprimir los identificadores */
  if (identificador + 1 < 10) {
    printf("0%d", identificador + 1); /* Recordatorio de que el 0 se tiene en cuenta, por eso se suma 1 */
  } else {
    printf("%d", identificador + 1);
  }

  printf("%c", tipoApartamentoLetra);

  /* Pequeño arreglo para imprimir el número de habitación */
  if (nuevo->N_Habitacion + 1 < 10) {
    printf("0%d\n", nuevo->N_Habitacion + 1); /* Recordatorio de que el 0 se tiene en cuenta, por eso se suma 1 */
  } else {
    printf("%d\n", nuevo->N_Habitacion + 1);
  }

  interfaz.Espaciar(5);
  printf("Fecha Entrada: %d/%d/%d\n", fecha.dia, int(fecha.mes) + 1, fecha.anno);

  interfaz.Espaciar(5);
  printf("Duracion estancia: %d dias\n", longitud);

  fechaAux = fecha.ObtenerFecha(fecha.ObtenerDias(fecha) + longitud - 1);
  interfaz.Espaciar(5);
  printf("Fecha Salida: %d/%d/%d\n", fechaAux.dia, int(fechaAux.mes) + 1, fechaAux.anno); /* Recordatorio de que el 0 se tiene en cuenta en los meses, por eso se suma 1 */
}

/*-- Estructura del calendario --*/
typedef struct CalendarioMes {
  void ImprimirFecha(TipoMes mes, TipoAnno anno);
  void ImprimirSeparador(int numero, char caracter);
  void ImprimirSiglasSemana();
  void GenerarCalendario(TipoConjuntoEdificios edificio);
};

/* Funciones de CalendarioMes */
/* los subprogramas mantienen el orden de declaracion de interfaz */

/*--  Procedimiento de ImprimirFecha, un pequeño útil para imprimir el inicio del calendario  --*/
void CalendarioMes::ImprimirFecha(TipoMes mes, TipoAnno anno) {
  switch (mes) {
    case Enero:
      printf("Enero     ");
            break;
        case Febrero:
            printf("Febrero   ");
            break;
        case Marzo:
            printf("Marzo     ");
            break;
        case Abril:
            printf("Abril     ");
            break;
        case Mayo:
            printf("Mayo      ");
            break;
        case Junio:
            printf("Junio     ");
            break;
        case Julio:
            printf("Julio     ");
            break;
        case Agosto:
            printf("Agosto    ");
            break;
        case Septiembre:
            printf("Septiembre");
            break;
        case Octubre:
            printf("Octubre   ");
            break;
        case Noviembre:
            printf("Noviembre ");
            break;
        case Diciembre:
            printf("Diciembre ");
            break;
        default:
            printf("?         ");
    }

    ImprimirSeparador(13, ' ');
    printf("%4d", anno);
}

/*--  Procedimiento de ImprimirSeparador, es similar al procedimiento Espaciar(), pero este proviene
      de otro programa, se incluyó porque se especificó la reutilización de código  --*/
void CalendarioMes::ImprimirSeparador(int numero, char caracter) {
    for (int i = 0; i < numero; i++) {
        printf("%c", caracter);
    }
}

/*--  Procedimiento de ImprimirSiglasSemana, pequeño útil para imprimir el formato del calendario  --*/
void CalendarioMes::ImprimirSiglasSemana() {
    printf(" L   M   X   J   V   S   D");
}

/*--  Procedimiento de GenerarCalendario, este subrpograma se encarga de generar e imprimir todo el calendario con sus reservas  --*/
/* Pequeña no: Esta es la parte más compleja del programa */
void CalendarioMes::GenerarCalendario(TipoConjuntoEdificios edificio) {
  TipoFecha fecha, fechaAUX;
  TipoInterfaz interfaz;
  TipoIdentificador identificador;
  TipoReferencia referencia;
  TipoPuntero cursor;

  int diaInicio = 0;
  int semanasNecesarias = 0;
  int tipoApartamento;
  char tipoApartamentoLetra;
  int N_habitacionSeleccionada;
  bool reservado = false;
  bool repetirFinal = false;
  int contadorDias = 1;
  int diasReservados = 0;
  int reservaActual;

  printf("Reservas Mensuales Apartamento:\n");
  printf("Referencia Apartamento? APT");
  scanf(" %s", &referencia);

  /* Esta sección maneja los datos en la referencia */
  if (referencia[0] == '0') {
    identificador = int(referencia[1]) - int('0');
  } else {
    identificador = (int(referencia[0]) - int('0'))*10 + (int(referencia[1]) - int('0'));
  }

  identificador--;

  /* Manejo de excepciones posibles del identificador */
  if (!edificio.ComprobarIdentificador(identificador)) {
    throw 1;
  } else if (edificio.edificios[identificador].baja) {
    throw 2;
  }

  tipoApartamentoLetra = referencia[2];
  tipoApartamentoLetra = toupper(tipoApartamentoLetra);

  /* Manejo de la letra, para pasarla a número */
  switch (tipoApartamentoLetra) {
    case 'B':
      tipoApartamento = 0;
      break;
    case 'N':
      tipoApartamento = 1;
      break;
    case 'L':
      tipoApartamento = 2;
      break;
    default:
      throw 6; /* Si la letra no existe */
  }

  /* Extracción de la habitación */
  if (referencia[3] == '0') {
    N_habitacionSeleccionada = int(referencia[4]) - int('0');
  } else {
    N_habitacionSeleccionada = (int(referencia[3]) - int('0'))*10 + (int(referencia[4]) - int('0'));
  }

  N_habitacionSeleccionada--;

  /* Manejo de las fechas */
  printf("Seleccion Mes? ");
  scanf(" %d", &fecha.mes);

  printf("Seleccion Ano? ");
  scanf(" %d", &fecha.anno);

  fecha.mes = TipoMes(int(fecha.mes) - 1);

  /* Comprobar que la fecha esté bien */
  if (!fecha.ComprobarMes(fecha.mes)) {
    throw 3;
  } else if (!fecha.ComprobarAnno(fecha.anno)) {
    throw 4;
  }

  fecha.dia = 0; /* Como el día no se especifica, se establece en 0 para que no estorbe */

  /* Menú en el que se imprimen algunos datos */
  printf("\n");
  interfaz.Espaciar(10);
  printf("Estado Mensual Apartamento: APT%s\n", referencia);

  interfaz.Espaciar(20);
  printf("Edificio: %s\n\n", edificio.edificios[identificador].nombre);

  interfaz.Espaciar(15);
  ImprimirFecha(fecha.mes, fecha.anno);

  printf("\n\n");
  interfaz.Espaciar(15);
  ImprimirSiglasSemana();

  /* A continuación, se imprime el calendario */
  printf("\n");
  interfaz.Espaciar(15);
  ImprimirSeparador(27, '-');

  /* Obtención del día de inicio, para calcular el desfase semanal de calendario */
  diaInicio = (fecha.ObtenerDias(fecha)) % 7;
  semanasNecesarias = (fecha.ObtenerLongitudMes(fecha.mes, fecha.anno) + diaInicio + 6) / 7; /* Con esto se calculan cuántas semanas se van a necesitar */
  fecha.dia = -diaInicio; /* Pequeño arreglo para saber cuándo empezar a imprimir */

  for (int i = 0; i < semanasNecesarias; i++) { /* Bucle para establecer cuántas líneas de semana se necesitan */
    printf("\n");
    interfaz.Espaciar(15);
    for (int j = 0; j < LongitudSemana; j++) {
      fecha.dia++;

      cursor = edificio.edificios[identificador].informacionReservado;
      reservado = false; /* Variable un poco auxiliar para no hacer el bucle más de una vez */

      while (cursor != NULL && !reservado) { /* Se recorre el cursor, hasta que finalmente se encuentra un «espacio libre» */

        if (cursor->fecha.dia == (fecha.dia + 1)
        && cursor->fecha.mes == fecha.mes
        && cursor->fecha.anno == fecha.anno
        && cursor->calidadHabitacion == tipoApartamento
        && cursor->N_Habitacion == N_habitacionSeleccionada) {
          reservado = true;
          contadorDias++;
          printf("Re"); /* Se imprime la marca "Re" para indicar que el día está reservado */

          diasReservados++; /* Usado para el conteo posterior */
        }

        cursor = cursor->siguiente; /* Se avanza una posición en el cursor */
      }

      if (!reservado) { /* En el caso de que no haya una reserva */
        /* Este apartado se encarga de cuando los días del mes anterior llegan a su fin */
        if (i == 0 && j < diaInicio - 1) {
          printf("  "); /* Es imprimen espacios para rellenar */

        } else if (contadorDias > fecha.ObtenerLongitudMes(fecha.mes, fecha.anno) || repetirFinal) { /* Cuando los días superan el mes */

          printf("  "); /* Más espacios para rellenar */
          contadorDias++;
          repetirFinal = true; /* Para que se siga repitiendo hasta que finalice, si no, cambia de mes */

        } else { /* Si el día está dentro del mes */
          printf("%2d", contadorDias); /* Imprime el día del mes */
          contadorDias++;
        }
      }

      printf("  ");
    }
  }

  printf("\n");

  /*-- Indexar las reservas en orden  --*/
  cursor = edificio.edificios[identificador].informacionReservado;

  while (cursor != NULL) {
    if (cursor->fecha.anno > 0) {
      contadorDias = 0; /* Se reutiliza la variable, realmente vuelve a contar días */
      fechaAUX.dia = cursor->fecha.dia;
      fechaAUX.mes = cursor->fecha.mes;
      fechaAUX.anno = cursor->fecha.anno;
      reservaActual = cursor->N_deReserva;

      /* Se recorre el cursor hasta alcanzar la misma reserva (de número) */
      while (cursor->siguiente != NULL && cursor->siguiente->N_deReserva == reservaActual) {
        contadorDias++;
        cursor = cursor->siguiente;
      }

      /* Se imprime la información de la reserva */
      printf("\nReserva %d/%d Fecha entrada: %d/%d/%d y de %d dias\n",
        reservaActual + 1,
        fechaAUX.anno,
        fechaAUX.dia,
        fechaAUX.mes,
        fechaAUX.anno,
        contadorDias + 1);
    }

    cursor = cursor->siguiente;
  }

  printf("\nTotal dias reservados del mes: %d dias", diasReservados); /* Así se saben los días que se han reservado */
  printf("\nTotal dias libres del mes: %d dias", fecha.ObtenerLongitudMes(fecha.mes, fecha.anno) - diasReservados); /* Y se restan a los días totales */
  printf("\n\n");
}


/*========================================
            PROGRAMA PRINCIPAL
  ========================================*/
int main() {
  TipoInterfaz interfaz;
  TipoConjuntoEdificios edificios;
  CalendarioMes calendario;

  char respuesta;

  while (respuesta != 'S') {
    respuesta = toupper(interfaz.ImprimirMenuInicio()); /* Llamada al menú del inicio */
    printf("\n");

    switch (respuesta) { /* Se evalúan las posibles respuestas */
      case 'E': /* Para crear un nuevo edificio */
        try {
          edificios.EditarEdificio(edificios);
          printf("\n");
        } catch (int e) { /* Manejo de errores */
          if (e == 1) {
            printf("Error: Identificador fuera de rango (1 - %d)\n\n", MAX_Edificios);
          } if (e == 2) {
            printf("Error: Numero de apartamentos por edificio superado (maximo: %d)\n\n", MAX_Apartamentos);
          }
        }
        break;
      case 'L': /* Para listar los edificios */
        edificios.ListarEdificios(edificios);
        break;
      case 'A': /* Para consultar las reservas */
        try {
          edificios.ConsultarReservas(edificios);
          printf("\n");
        } catch (int e) { /* Manejo de errores */
          if (e == 1) {
            printf("Error: Identificador fuera de rango (1 - %d)\n\n", MAX_Edificios);
          } else if (e == 2) {
            printf("Error: El edificio se encuentra dado de baja o no se ha iniciado\n\n");
          } else if (e == 3) {
            printf("Error: Dia fuera de rango (1 - 28/29/30/31)\n\n");
          } else if (e == 4) {
            printf("Error: Mes fuera de rango (1 - 12)\n\n");
          } else if (e == 5) {
            printf("Error: Ano fuera de rango (1601 - %d)\n\n", MAX_Anno);
          }
        }
        break;
      case 'R': /* Para hacer la reserva */
        try {
          edificios.HacerReserva(edificios);
          printf("\n");
        } catch (int e) { /* Manejo de errores */
          if (e == 1) {
            printf("Error: Identificador fuera de rango (1 - %d)\n\n", MAX_Edificios);
          } else if (e == 2) {
            printf("Error: El edificio se encuentra dado de baja o no se ha iniciado\n\n");
          } else if (e == 3) {
            printf("Error: Dia fuera de rango (1 - 28/29/30/31)\n\n");
          } else if (e == 4) {
            printf("Error: Mes fuera de rango (1 - 12)\n\n");
          } else if (e == 5) {
            printf("Error: Ano fuera de rango (1601 - %d)\n\n", MAX_Anno);
          } else if (e == 6) {
            printf("Error: Tipo de apartamento fuera de rango (B/M/L)\n\n");
          } else if (e == 7) {
            printf("Error: No hay apartamentos disponibles\n\n");
          }
        }
        break;
      case 'M': /* Para ver las reservas en el calendario */
        try {
          calendario.GenerarCalendario(edificios);
        } catch (int e) { /* Manejo de errores */
          if (e == 1) {
            printf("Error: Identificador fuera de rango (1 - %d)\n\n", MAX_Edificios);
          } else if (e == 2) {
            printf("Error: El edificio se encuentra dado de baja o no se ha iniciado\n\n");
          } else if (e == 3) {
            printf("Error: Mes fuera de rango (1 - 12)\n\n");
          } else if (e == 4) {
            printf("Error: Ano fuera de rango (1601 - %d)\n\n", MAX_Anno);
          }
        }
        break;
      case 'S': /* Para salir */
        break;
      default:
        printf("Por favor, ingresa un caracter valido (E|L|A|R|M|S)\n\n");
    }

  }
}



