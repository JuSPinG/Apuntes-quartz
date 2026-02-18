/************************************************************
 * Programa: Base de datos de personas
 * 
 * Descripcion:
 *   Este programa se encarga de guardar ciertos datos
 *   personas para luego poder extraerlos de forma ordenada
 ************************************************************/

#include<stdio.h>
#include<string.h>

const int MAX_personas = 50;

typedef char TipoNombre[16];
typedef char TipoApellido[21];
typedef char TipoDNI[10];
typedef int TipoEdad; /* TipoEdad es un tipo concreto pues es un número con restricciones, en este caso, >= 0 */

typedef struct TipoDatosPersona {
	TipoNombre nombre;
	TipoApellido apellido;
	TipoDNI dni;
	TipoEdad edad;
};

typedef TipoDatosPersona TipoDatosPersonas[MAX_personas];

typedef struct TipoPersonas {
	TipoEdad ComprobarEdad(int edad);

	void ImprimirMayoresDe(TipoEdad edad);
	void BuscarApellido(TipoApellido apellido);

	private:
		TipoDatosPersonas personas;
};

TipoEdad TipoPersonas::ComprobarEdad(int edad) {
	if (edad <= 0) {
		throw 1;
	} else {
		return TipoEdad(edad);
	}
}

void TipoPersonas::ImprimirMayoresDe(TipoEdad edad) {
	bool personasEncontradas = false;

	for (int i = 0; i < MAX_personas; i++) {
		if (personas[i].edad >= edad) {
			personasEncontradas = true;
			printf("La persona %s %s tiene la edad de: %d\n", personas[i].nombre, personas[i].apellido, personas[i].edad);
		}
	}

	if (!personasEncontradas) {
		printf("No se han encontrado personas...\n");
	}
}

void TipoPersonas::BuscarApellido(TipoApellido apellido) {
	bool personasEncontradas = false;

	for (int i = 0; i < MAX_personas; i++) {
		if (strcmp(personas[i].apellido, apellido) == 0) {
			personasEncontradas = true;
			printf("La persona %s %s comparte el apellido\n", personas[i].nombre, personas[i].apellido);
		}
	}

	if (!personasEncontradas) {
		printf("No se ha encontrado ninguna coincidencia...\n");
	}
}

int main() {
	int edad;
	int res = 0;
	TipoApellido apellido;

	TipoPersonas personas;

	while (res != 3) {

		printf("Bienvenido al registro de personas. Ingresa una opcion:\n     1) Busqueda por edad\n     2) Busqueda por apellido\n     3) Salir: ");
		scanf(" %d", &res);

		switch (res) {
			case 1:
				printf("Ingresa la edad: ");
				scanf(" %d", &edad);

				try {
					edad = int(personas.ComprobarEdad(edad));
				} catch (int e) {
					if (e == 0) {
						printf("Lo siento, pero esa edad es inválida\n");
						return 0;
					}
				}
				personas.ImprimirMayoresDe(TipoEdad(edad));
				break;
			case 2:
				printf("Ingresa el apellido: ");
				scanf(" %s", apellido);

				personas.BuscarApellido(apellido);
				break;
			case 3:
				printf("Nos vemos!\n");
				break;
		}
	}
}