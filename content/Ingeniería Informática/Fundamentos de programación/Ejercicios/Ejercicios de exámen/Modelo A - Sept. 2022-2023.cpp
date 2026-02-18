/****************************************************
 * Programa: Gestor de señales de tráfico
 * 
 * Descripción:
 *   El programa se encarga de clasificar señales
 *   de tráfico y realizar operaciones entre ellas.
 ****************************************************/

#include<stdio.h>
#include<string.h>
#include<ctype.h>

const int MAX_TipoSennal = 100;
const int MAX_SeccionSennal = 5;
const int MAX_SennalesTraidas = 8;

typedef int TipoSeccionSennalNumero;
typedef int TipoTipoSennalNumero;

typedef char TipoIdentificadorSennal[5];
typedef char TipoDescripcionSennal[25];

typedef struct TipoSennal {
    TipoIdentificadorSennal identificador;
    int cantidad;
    TipoDescripcionSennal descripcion;
    int alto;
    int ancho;
    int peso;
};

typedef TipoSennal TipoTipoSennal[MAX_TipoSennal];
typedef TipoTipoSennal TipoSeccionSennal[MAX_SeccionSennal];

typedef struct TipoConjuntoSennales {
    TipoSeccionSennal sennales;

    void IniciarSennales(TipoSeccionSennal sennales);
    bool ComprobarSeccion(TipoSeccionSennalNumero seccion);
};

void TipoConjuntoSennales::IniciarSennales(TipoSeccionSennal sennales) {
    for (int i = 0; i < MAX_SeccionSennal; i++) {
        for (int j = 0; j < MAX_TipoSennal; j++) {
            strcpy(sennales[i][j].identificador, "0000");
            sennales[i][j].cantidad = 0;
        }
    }
}

bool TipoConjuntoSennales::ComprobarSeccion(TipoSeccionSennalNumero seccion) {
    if (seccion < 0 || seccion >= MAX_SeccionSennal) {
        return 1;
    }
}

int main() {
    int res = 0;
    int cantidad;
    int seccion = 0;
    bool continuar = true;
    char confirmar;

    TipoSennal sennalAux;
    TipoConjuntoSennales sennales;

    sennales.IniciarSennales(sennales.sennales);

    while (res != 0) {
        printf("\nBienvenido al gestor de senales!\nQue quieres hacer?\n\n1) Nuevo tipo\n2) Cargar entrada\n3) Mostrar menor numero\n0) Salir");
        scanf(" %d", &res);

        switch (res) {
            case 1:

                while (!sennales.ComprobarSeccion(seccion)) {
                    printf("A que seccion pertenece? (1 - %d) ", MAX_SeccionSennal);
                    scanf(" %d", &seccion);
                }

                seccion--;

                printf("A que tipo pertenece? ");
                scanf(" %s", &sennalAux.identificador);

                for (int i = 0; i < MAX_TipoSennal && continuar; i++) {
                    if (sennales.sennales[seccion][i].identificador == sennalAux.identificador) {
                        printf("El identificador que has mencionado ya existe. Considera otra opcion para anadir nuevas existencias");
                        continuar = false;
                    }
                }

                if (continuar) {
                    printf("Cuantas senales hay? ");
                    scanf(" %d", &sennalAux.cantidad);

                    printf("Cual es su descripcion? ");
                    scanf(" %s", &sennalAux.descripcion);

                    printf("Cual es su altura? ");
                    scanf(" %d", &sennalAux.alto);

                    printf("Cual es su anchura? ");
                    scanf(" %d", &sennalAux.ancho);

                    printf("Cuanto pesa? ");
                    scanf(" %d", &sennalAux.peso);

                    printf("\n\n========= Resumen =========\n\n");

                    printf("Identificador: %s");
                    printf("Cantidad: %d");
                    printf("Descripcion: %s");
                    printf("Altura: %d");
                    printf("Anchura: %d");
                    printf("Peso: %d");

                    printf("\n\nSon correctos los datos? (S|N)");
                    scanf(" %c", confirmar);

                    if (toupper(confirmar) == 'S') {
                        for (int i = 0; i < MAX_TipoSennal && continuar; i++) {
                            if (sennales.sennales[seccion][i].identificador == "0000") {
                                strcpy(sennales.sennales[seccion][i].identificador, sennalAux.identificador);
                                strcpy(sennales.sennales[seccion][i].descripcion, sennalAux.descripcion);
                                sennales.sennales[seccion][i].cantidad = sennalAux.cantidad;
                                sennales.sennales[seccion][i].alto = sennalAux.alto;
                                sennales.sennales[seccion][i].ancho = sennalAux.ancho;
                                sennales.sennales[seccion][i].peso = sennalAux.peso;
                                continuar = false;

                                printf("\nDatos guardados con exito\n\n");
                            }
                        }
                    }
                }
                break;
            case 2:
                while (cantidad > 0 || cantidad <= MAX_SennalesTraidas) {
                    printf("\nCuantos tipos de senales ha traido el camion? (1 - %d)", MAX_SennalesTraidas);
                    scanf(" %d", &cantidad);
                }

                for (int i = 0; i < cantidad; i++) {
                    printf("\nIngresa el identificador de la sennal numero %d: ", i + 1);
                    scanf(" %s", &sennalAux.identificador);

                    for (int j = 0; j < MAX_SeccionSennal && continuar; j++) {
                        for (int e = 0; e < MAX_TipoSennal && continuar; e++) {
                            if (sennales.sennales[j][i].identificador == sennalAux.identificador) {
                                printf("\nActualmente, el tipo %s cuenta con %d exitencias, cuantos hay que anadir? ", sennales.sennales[j][i].identificador, sennales.sennales[j][i].cantidad);
                                scanf(" %d", sennalAux.cantidad);
                                sennales.sennales[j][i].cantidad = sennalAux.cantidad;
                                continuar = false;
                            }
                        }
                    }

                    if (continuar) {
                        printf("\nNo se ha encontrado la sennal");
                    }
                }
                break;
            case 3:
                for (int i = 0; i < MAX_SeccionSennal; i++) {
                    for (int j = 0; j < MAX_TipoSennal; j++) {
                        if (sennales.sennales[j][i].cantidad >= 5) {
                            printf("\nSennal encontrada:\n");
                            printf("\n     Codigo: %s", sennales.sennales[j][i].identificador);
                            printf("\n     Descripcion: %s", sennales.sennales[j][i].descripcion);
                        }
                    }
                }
                break;
            default:
                printf("?");
        }
    }
}