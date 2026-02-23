/********************************************************
 * Programa: Lista To-do.
 * 
 * Descripción:
 *   Este programa maneja la tareas de un usuario.
 *   Además, cuanta con múltiples parámetros.
 ********************************************************/

#include<stdio.h>

const int MAX_tareas = 20;

typedef int TipoDuracionEstimada;
typedef char TipoDescripcion[501];
typedef enum TipoImportancia { Baja, Media, Alta };

typedef struct TipoTarea {

	/* Datos a guardar */
	TipoDescripcion descripcion;
	TipoDuracionEstimada duracionEstimada;
	TipoImportancia importancia;
	bool completado;

	int ComprobarDuracion(TipoDuracionEstimada duracionEstimada);
};

int TipoTarea::ComprobarDuracion(TipoDuracionEstimada duracionEstimada) {
	if (duracionEstimada <= 0) {
		return 0;
	} else {
		return 1;
	}
}

typedef TipoTarea TipoConjuntoTareas[MAX_tareas];

typedef struct TipoTareas {

	void HorasPendientesAltaPrioridad();
	int ObtenerTareasPendientes(TipoImportancia importancia);
	TipoImportancia ComprobarImportancia(int importancia);
	void TareasPendientes();
	void ImprimirInformacionTarea(TipoTarea tarea);
	void MostrarNoCompletadas();

	private:
		TipoConjuntoTareas tareas;
	
};

void TipoTareas::HorasPendientesAltaPrioridad() {
	bool tareaEncontrada = false;

	for (int i = 0; i < MAX_tareas; i++) {
		if (!tareas[i].completado && tareas[i].importancia == Alta) {
			tareaEncontrada = true;

			printf("La tarea numero %d con prioridad ALTA va a tarar en completarse %d horas\n", i, tareas[i].duracionEstimada);
		}
	}
	if (!tareaEncontrada) {
		printf("No se ha encontrado ninguna tarea...\n");
	}
}

int TipoTareas::ObtenerTareasPendientes(TipoImportancia importancia) {
	int contador = 0;

	for (int i = 0; i < MAX_tareas; i++) {
		if (tareas[i].importancia == importancia) {
			contador++;
		}
	}

	return contador;
}

TipoImportancia TipoTareas::ComprobarImportancia(int importancia) {

	if (importancia > 3 && importancia < 1) {
		throw 0;
	} else {
		return TipoImportancia(importancia - 1);
	}

}

void TipoTareas::TareasPendientes() {
	int res;
	TipoImportancia importancia;

	printf("Por favor, ingresa la importancia de las tareas a consultar: 1) Baja, 2) Media, 3) Alta");
	scanf("%d", &res);

	try {
		importancia = ComprobarImportancia(res);
	} catch (int e) {
		if (e == 0) {
			printf("Solo se admiten valores del 1 al 3\n");
			return;
		}
	}

	printf("Hay %d con la importancia seleccionada\n", ObtenerTareasPendientes(importancia));
}

void TipoTareas::ImprimirInformacionTarea(TipoTarea tarea) {
	printf("     Descripcion: %s\n", tarea.descripcion);
	printf("     Duracion: %d\n", tarea.duracionEstimada);
	printf("     Prioridad: ");
	
	switch (tarea.importancia) {
		case Baja:
			printf("Baja");
			break;
		case Media:
			printf("Media");
			break;
		case Alta:
			printf("Alta");
			break;
		default:
			printf("?");
	}
	printf("\n");
}

void TipoTareas::MostrarNoCompletadas() {
	bool tareasEncontradas = false;
	for (int i = 0; i < MAX_tareas; i++) {
		if (!tareas[i].completado && tareas[i].importancia == Alta) {
			tareasEncontradas = true;

			printf("Tarea encontrada en la posicion %d", i + 1);
			ImprimirInformacionTarea(tareas[i]);
		}
	}

	for (int i = 0; i < MAX_tareas; i++) {
		if (!tareas[i].completado && tareas[i].importancia == Media) {
			tareasEncontradas = true;

			printf("Tarea encontrada en la posicion %d", i + 1);
			ImprimirInformacionTarea(tareas[i]);
		}
	}

	for (int i = 0; i < MAX_tareas; i++) {
		if (!tareas[i].completado && tareas[i].importancia == Baja) {
			tareasEncontradas = true;

			printf("Tarea encontrada en la posicion %d", i + 1);
			ImprimirInformacionTarea(tareas[i]);
		}
	}
}

int main() {
	int res;
	TipoTareas tareas;

	printf("Bienvenido al gestor de tareas!\nElije una opcion para continuar:\n     1) Revisar tareas de alta prioridad\n     2) Revisar el numero de tareas pendientes\n     3) Revisar todas las tareas pendientes\nOpcion: ");

	scanf("%d", &res);

	switch (res) {
		case 1:
			tareas.HorasPendientesAltaPrioridad();
			break;
		case 2:
			tareas.TareasPendientes();
			break;
		case 3:
			tareas.MostrarNoCompletadas();
			break;
		default:
			printf("Esa no es una respuesta valida...\n");
	}
}