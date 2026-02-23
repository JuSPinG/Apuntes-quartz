#include<stdio.h>
#include<ctype.h>
#include<string.h>
#include<stdlib.h>

/*=====================ZONA DE DELCARACION=====================*/

/*------------ Definicion de constantes ------------*/
const int MAX_Edificios = 5;
const int MAX_Apartamentos = 20;
const int MAX_Anno = 3000;

/*------------ Definicion de tipos ------------*/
typedef char TipoNombre[21];
typedef int TipoIdentificador;

typedef enum TipoMes { Enero, Febrero, Marzo, Abril, Mayo, Junio, Julio, Agosto, Septiembre, Octubre, Noviembre, Diciembre };
typedef int TipoAnno;
typedef int TipoDia;

/*------------ Definicion de variables ------------*/


/*------------ Declaración TAD ------------*/
/*--  Estructura de TipoInterfaz  --*/
typedef struct TipoInterfaz {

	void Espaciar(int numero);
	char ImprimirMenuInicio();
};

/* Funciones de TipoInterfaz */
/*los subprogramas mantienen el orden de declaración de interfaz */

void TipoInterfaz::Espaciar(int numero) {
	for (int i = numero; i >= 1; i--) {
		printf(" ");
	}
}

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

	return opcion;
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
/* los subprogramas mantienen el orden de claración de interfaz */

bool TipoFecha::ComprobarDia(TipoFecha fecha) {
	if (fecha.dia <= 0 || fecha.dia > ObtenerLongitudMes(fecha.mes, fecha.anno)) {
		return false;
	} else {
		return true;
	}
}

bool TipoFecha::ComprobarMes(TipoMes mes) {
    if (mes <= 0 || mes > 12) {
        return false;
    } else {
        return true;
    }
}

bool TipoFecha::ComprobarAnno(TipoAnno anno) {
    if (anno < 1601 || anno > MAX_Anno) {
        return false;
    } else {
        return true;
    }
}

bool TipoFecha::ComprobarBisiesto(TipoAnno anno) {
    return (anno % 4 == 0 && anno % 100 != 0) || (anno % 400 == 0);
}

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

int TipoFecha::ObtenerLongitudAnno(TipoAnno anno) {
    return 365 + int(ComprobarBisiesto(anno));
}

int TipoFecha::ObtenerDias(TipoFecha fecha) {
    int contadorDias = 0;

    for (int a = 1601; a < fecha.anno; a++) {
        contadorDias = contadorDias + ObtenerLongitudAnno(a);
    }

    for (int m = Enero; m < fecha.mes; m++) {
        contadorDias = contadorDias + ObtenerLongitudMes(TipoMes(m), anno);
    }

	for (int d = 1; d <= fecha.dia; d++) {
		contadorDias++;
	}

    return contadorDias;
}

TipoFecha TipoFecha::ObtenerFecha(int dias) {
	int contadorDias = 0;
	TipoFecha fecha;

	for (int a = 1601; a <= MAX_Anno; a++) {
		if (contadorDias > dias && contadorDias < dias + ObtenerLongitudAnno(TipoAnno(a + 1))) {
			fecha.anno = TipoAnno(a);
		} else {
			contadorDias = contadorDias + ObtenerLongitudAnno(TipoAnno(a));
		}
	}

	for (int m = Enero; m <= 12; m++) {
		if (contadorDias > dias && contadorDias < dias + ObtenerLongitudMes(TipoMes(m), fecha.anno)) {
			fecha.mes = TipoMes(m);
		} else {
			contadorDias = contadorDias + ObtenerLongitudMes(TipoMes(m), fecha.anno);
		}
	}

	for (int d = 1; d <= ObtenerLongitudMes(fecha.mes, fecha.anno); d++) {
		if (contadorDias == dias) {
			fecha.dia = TipoDia(d);
		} else {
			contadorDias++;
		}
	}

	return fecha;
}

/*-- Estructura del puntero --*/
typedef struct TipoDiasReservados {
	bool reservado;
	int N_Habitacion;
	int calidadHabitacion;
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
	TipoEdificio edificios[MAX_Edificios];

	bool ComprobarIdentificador(TipoIdentificador identificador);
	TipoEdificio ComprobarDisponibilidad(TipoEdificio edificio, TipoFecha fecha);

	void EditarEdificio(TipoConjuntoEdificios &edificio);
	void ListarEdificios(TipoConjuntoEdificios edificios);
	void ConsultarReservas(TipoConjuntoEdificios edificio);
	void ObtenerDatosReserva(TipoConjuntoEdificios edificio);

};

/* Funciones de TipoEdificio */
/*los subprogramas mantienen el orden de declaración de interfaz */

bool TipoConjuntoEdificios::ComprobarIdentificador(TipoIdentificador identificador) {
	return (identificador >= 0) && (identificador < MAX_Edificios);
}

TipoEdificio TipoConjuntoEdificios::ComprobarDisponibilidad(TipoEdificio edificio, TipoFecha fecha) {
	TipoPuntero cursor = edificio.informacionReservado;
	TipoEdificio edificioAUX = edificio;

	while (cursor != NULL) {
		if (cursor->fecha.anno == fecha.anno && cursor->fecha.mes == fecha.mes && cursor->fecha.dia == fecha.dia) {

			if (cursor->calidadHabitacion == 0 && cursor->reservado) {
				edificioAUX.N_apartamentoBasico--;
			} else if (cursor->calidadHabitacion == 1 && cursor->reservado) {
				edificioAUX.N_apartamentoNormal--;
			} else if (cursor->calidadHabitacion == 2 && cursor->reservado) {
				edificioAUX.N_apartamentoLujo--;
			}
		}
		cursor = cursor->siguiente;
	}

	return edificioAUX;
}

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

	if (!ComprobarIdentificador(identificador)) {
		throw 1;
	}

	if (edificio.edificios[identificador].baja == true) {
		interzaf.Espaciar(10);
		printf("El edificio consultado esta dado de baja, quiere continuar (S/N)? ");
		scanf(" %c", &respuesta);

		/*
		No me ha quedado muy claro qué tiene que suceder (o no suceder) cuando un edificio está de baja,
		por lo que he introducido este fragmento para que el cliente pueda decidir nuevamente.
		*/

		if (toupper(respuesta) == 'S') {
			edificio.edificios[identificador].baja = false;
		} else {
			printf("Operacion cancelada\n");
			return;
		}
	}

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

	if (toupper(respuesta) == 'S') {
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

void TipoConjuntoEdificios::ListarEdificios(TipoConjuntoEdificios edificio) {
	bool hayEdificios = false;

	for (int i = 0; i < MAX_Edificios; i++) {
		if (edificio.edificios[i].iniciado == true && edificio.edificios[i].baja == false) {
			if (hayEdificios == false) {
				printf("Id                 Nombre     Aptos Basicos     Aptos Normales     Aptos de Lujo\n");
				hayEdificios = true;
			}
			printf("\n%d   %20s          %4d             %4d               %4d", i+1, edificio.edificios[i].nombre, edificio.edificios[i].N_apartamentoBasico, edificio.edificios[i].N_apartamentoNormal, edificio.edificios[i].N_apartamentoLujo);
		}
	}
	if (hayEdificios == false) {
		printf("No hay edificios disponibles\n");
	}
	printf("\n\n");
}

void TipoConjuntoEdificios::ConsultarReservas(TipoConjuntoEdificios edificio) {
	int longitud;
	int disponibilidadCorrecta = 0;

	TipoIdentificador identificador;
	TipoInterfaz interfaz;
	TipoFecha fecha;
	TipoEdificio edificioSeleccionado, apartamentosLibres;

	printf("Apartamentos Disponibles: \n\n");

	interfaz.Espaciar(5);
	printf("Identificador de Edificio? ");
	scanf(" %d", &identificador);

	identificador--;

	if (!ComprobarIdentificador(identificador)) {
		throw 1;
	}

	edificioSeleccionado = edificio.edificios[identificador];

	if (edificioSeleccionado.baja) {
		throw 2;
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

	if (!fecha.ComprobarAnno(fecha.anno)) {
		throw 5;
	}

	if (!fecha.ComprobarMes(fecha.mes)) {
		throw 4;
	}
	
	if (!fecha.ComprobarDia(fecha)) {
		throw 3;
	}


	interfaz.Espaciar(5);
	printf("Dias de duracion de la estancia? ");
	scanf(" %d", &longitud);

	for (int i = 0; i <= longitud; i++) {

		apartamentosLibres = ComprobarDisponibilidad(edificioSeleccionado, fecha.ObtenerFecha(fecha.ObtenerDias(fecha) + i));

		if (apartamentosLibres.N_apartamentoBasico + apartamentosLibres.N_apartamentoNormal + apartamentosLibres.N_apartamentoLujo > 0) {
			disponibilidadCorrecta++;
		}
	}

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

void TipoConjuntoEdificios::ObtenerDatosReserva(TipoConjuntoEdificios edificio) {
	char tipoApartamento;
	int longitud;
	int disponibilidadCorrecta = 0;
	int contador = 0;

	int arreglo;

	TipoIdentificador identificador;
	TipoInterfaz interfaz;
	TipoFecha fecha;
	TipoEdificio edificioSeleccionado;
	TipoPuntero cursor;

	printf("Reservar Apartamento: \n\n");

	interfaz.Espaciar(5);
	printf("Identificador edificio? ");
	scanf(" %d", &identificador);

	identificador--;

	if (!ComprobarIdentificador(identificador)) {
		throw 1;
	}

	edificioSeleccionado = edificio.edificios[identificador];

	if (edificioSeleccionado.baja) {
		throw 2;
	}

	interfaz.Espaciar(5);
	printf("Tipo de Apartamento (B-Basico/N-Normal/L-Lujo) ? ");
	scanf(" %c", &tipoApartamento);

	tipoApartamento = toupper(tipoApartamento);

	switch (tipoApartamento) {
		case 'B':
			tipoApartamento = 0;
			break;
		case 'M':
			tipoApartamento = 1;
			break;
		case 'L':
			tipoApartamento = 2;
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

	if (!fecha.ComprobarAnno(fecha.anno)) {
		throw 5;
	}

	if (!fecha.ComprobarMes(fecha.mes)) {
		throw 4;
	}
	
	if (!fecha.ComprobarDia(fecha)) {
		throw 3;
	}

	/*if (tipoApartamento == 'B') {
		for (int i = 0; i <= longitud; i++) {
			apartamentosLibres = ComprobarDisponibilidad(edificioSeleccionado, fecha.ObtenerFecha(fecha.ObtenerDias(fecha) + i));
			apartamentosLibres.N_apartamentoBasico--;
		}
		disponibilidadCorrecta
	} else if (tipoApartamento == 'M') {
		for (int i = 0; i <= longitud; i++) {
			apartamentosLibres = ComprobarDisponibilidad(edificioSeleccionado, fecha.ObtenerFecha(fecha.ObtenerDias(fecha) + i));
			apartamentosLibres.N_apartamentoBasico--;
		}
		apartamentosLibres.N_apartamentoNormal--;
	} else if (tipoApartamento == 'L' && apartamentosLibres.N_apartamentoLujo <= 0) {
		for (int i = 0; i <= longitud; i++) {
			apartamentosLibres = ComprobarDisponibilidad(edificioSeleccionado, fecha.ObtenerFecha(fecha.ObtenerDias(fecha) + i));
			apartamentosLibres.N_apartamentoBasico--;
		}
	} else {
		throw 6;
	}*/

	cursor = edificioSeleccionado.informacionReservado;

	while (cursor != NULL) {
		if (cursor->fecha.anno == fecha.anno && cursor->fecha.mes == fecha.mes && cursor->fecha.dia == fecha.dia && cursor->calidadHabitacion == tipoApartamento) {
			contador++;
		}
		cursor = cursor->siguiente;
	}

	printf("Flujo");

	bool habitacionesReservadas[contador];
	cursor = edificioSeleccionado.informacionReservado;

	while (cursor != NULL) {
		if (cursor->fecha.anno == fecha.anno && cursor->fecha.mes == fecha.mes && cursor->fecha.dia == fecha.dia && cursor->calidadHabitacion == tipoApartamento) {
			habitacionesReservadas[cursor->N_Habitacion] = cursor->reservado;
		}
		cursor = cursor->siguiente;
	}

	cursor->calidadHabitacion = tipoApartamento;
	cursor->fecha = fecha;
	cursor->reservado = true;
	cursor->N_Habitacion = -1;
	
	for (int i = 0; i < contador && cursor->N_Habitacion != -1; i++) {
		if (habitacionesReservadas[i] == false) {
			cursor->N_Habitacion = i;
		}
	}

	if (cursor->N_Habitacion == -1 && ((tipoApartamento == 0 && edificioSeleccionado.N_apartamentoBasico > contador) || (tipoApartamento == 1 && edificioSeleccionado.N_apartamentoNormal > contador) || (tipoApartamento == 2 && edificioSeleccionado.N_apartamentoLujo > contador))) {
		cursor->N_Habitacion = contador + 1;
	} else {
		throw 7;
	}

	if (disponibilidadCorrecta > longitud) {
		printf("\n");
		interfaz.Espaciar(10);
		printf("Datos de la Reserva: \n\n");

		interfaz.Espaciar(5);
		printf("Numero de Reserva: \n");
			
		interfaz.Espaciar(5);
		printf("Edificio: %s (Id = %d)\n", edificioSeleccionado.nombre, identificador);

		interfaz.Espaciar(5);
		printf("Referencia de Apartamento: APT%d%c%d\n");
		
		interfaz.Espaciar(5);
		printf("Fecha Entrada: %d/%d/%d\n", fecha.dia, fecha.mes, fecha.anno);

		interfaz.Espaciar(5);
		printf("Duracion estancia: %d\n", longitud);

		interfaz.Espaciar(5);
		printf("fecha Salida: %d/%d/%d\n", fecha.ObtenerFecha(fecha.ObtenerDias(fecha) + longitud));

	} else {
		printf("\nEl edificio %s no se encuentra disponible\n", edificioSeleccionado.nombre);
	}

}

/*=====================PROGRAMA PRINCIPAL=====================*/
int main() {
	TipoInterfaz interfaz;
	TipoConjuntoEdificios edificios;

	char respuesta;

	do {
		respuesta = toupper(interfaz.ImprimirMenuInicio());
		printf("\n");

		switch (respuesta) {
			case 'E':
				try {
					edificios.EditarEdificio(edificios);
					printf("\n");
				} catch (int e) {
					if (e == 1) {
						printf("Error: Identificador fuera de rango (1 - %d)\n\n", MAX_Edificios);
					} if (e == 2) {
						printf("Error: Numero de apartamentos por edificio superado (maximo: %d)\n\n", MAX_Apartamentos);
					}
				}
				break;
			case 'L':
				edificios.ListarEdificios(edificios);
				break;
			case 'A':
				try {
					edificios.ConsultarReservas(edificios);
					printf("\n");
				} catch (int e) {
					if (e == 1) {
						printf("Error: Identificador fuera de rango (1 - %d)\n\n", MAX_Edificios);
					} else if (e == 2) {
						printf("Error: El edificio se encuentra dado de baja\n\n");
					} else if (e == 3) {
						printf("Error: Dia fuera de rango (1 - 28/29/30/31)\n\n");
					} else if (e == 4) {
						printf("Error: Mes fuera de rango (1 - 12)\n\n");
					} else if (e == 5) {
						printf("Error: Ano fuera de rango (1601 - %d)\n\n", MAX_Anno);
					}
				}
				break;
			case 'R':
				try {
					edificios.ObtenerDatosReserva(edificios);
					printf("\n");
				} catch (int e) {
					if (e == 1) {
						printf("Error: Identificador fuera de rango (1 - %d)\n\n", MAX_Edificios);
					} else if (e == 2) {
						printf("Error: El edificio se encuentra dado de baja\n\n");
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
			default:
				printf("Por favor, ingresa un caracter valido (E|L|A|R|M|S)\n\n");
		}

	} while (respuesta != 'S');
}
