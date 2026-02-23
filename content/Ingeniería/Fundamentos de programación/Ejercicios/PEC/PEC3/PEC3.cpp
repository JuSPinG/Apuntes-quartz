/**************************************
* NOMBRE: #Juan#
* PRIMER APELLIDO: #Lacoma#
* SEGUNDO APELLIDO: #Santos#
* DNI: #51162086N#
* EMAIL: #jlacoma949@alumno.uned.es#
***************************************/

#include<stdio.h>

const int LongitudSemana = 7;
const int SemanasEnCalendario = 6;

typedef enum TipoMes { Enero, Febrero, Marzo, Abril, Mayo, Junio, Julio, Agosto, Septiembre, Octubre, Noviembre, Diciembre };
typedef enum TipoSemana { Lunes, Martes, Miercoles, Jueves, Viernes, Sabado, Domingo };

typedef int TipoAnno;

typedef int TipoEstructuraCalendario[LongitudSemana][SemanasEnCalendario];

typedef struct TipoFormatoCalendario {

    TipoEstructuraCalendario INFO_calendario;

    void ImprimirFecha(TipoMes mes, TipoAnno anno);
    void ImprimirSeparador(int numero, char caracter);
    void ImprimirSiglasSemana();
    void GenerarCalendario(TipoMes mes, TipoAnno anno);
};

typedef struct TipoFecha {
    TipoMes mes;
    TipoAnno anno;

    bool ComprobarMes(TipoMes mes);
    bool ComprobarAnno(TipoAnno anno);
    bool ComprobarBisiesto(TipoAnno anno);

    int ObtenerLongitudMes(TipoMes mes, TipoAnno anno);
    int ObtenerLongitudAnno(TipoAnno anno);

    int MedirDistancia(TipoMes mes, TipoAnno anno);
};

/*=========== Declaraciones TipoFormatoCalendario ===========*/
void TipoFormatoCalendario::ImprimirFecha(TipoMes mes, TipoAnno anno) {
    switch (mes) {
        case Enero:
            printf("ENERO     ");
            break;
        case Febrero:
            printf("FEBRERO   ");
            break;
        case Marzo:
            printf("MARZO     ");
            break;
        case Abril:
            printf("ABRIL     ");
            break;
        case Mayo:
            printf("MAYO      ");
            break;
        case Junio:
            printf("JUNIO     ");
            break;
        case Julio:
            printf("JULIO     ");
            break;
        case Agosto:
            printf("AGOSTO    ");
            break;
        case Septiembre:
            printf("SEPTIEMBRE");
            break;
        case Octubre:
            printf("OCTUBRE   ");
            break;
        case Noviembre:
            printf("NOVIEMBRE ");
            break;
        case Diciembre:
            printf("DICIEMBRE ");
            break;
        default:
            printf("?         ");
    }

    ImprimirSeparador(13, ' ');
    printf("%4d", anno);
}

void TipoFormatoCalendario::ImprimirSeparador(int numero, char caracter) {
    for (int i = 0; i < numero; i++) {
        printf("%c", caracter); /* Separación estándar del calendario: 27 */
    }
}

void TipoFormatoCalendario::ImprimirSiglasSemana() {
    printf("LU  MA  MI  JU  VI | SA  DO");
}

void TipoFormatoCalendario::GenerarCalendario(TipoMes mes, TipoAnno anno) {
    TipoFecha fecha;

    int contadorDias = 1;
    int diaInicio = (fecha.MedirDistancia(mes, anno)) % 7;
    int semanasNecesarias = (fecha.ObtenerLongitudMes(mes, anno) + diaInicio + 6) / 7;

    for (int i = 0; i < semanasNecesarias; i++) {
        printf("\n");
        for (int j = 0; j < LongitudSemana; j++) {

            if (i == 0 && j < diaInicio) {
                INFO_calendario[i][j] = 0;
                printf(" .");
            } else if (contadorDias > fecha.ObtenerLongitudMes(mes, anno)) {
                INFO_calendario[i][j] = 0;
                printf(" .");
            } else {
                INFO_calendario[i][j] = contadorDias;
                contadorDias++;
                printf("%2d", INFO_calendario[i][j]);
            }

            if (j == 4) {
                printf(" | ");
            } else if (j == 6) {
                printf("");
            } else {
                printf("  ");
            }
        }
    }
}

/*=========== Declaraciones TipoFecha ===========*/
bool TipoFecha::ComprobarMes(TipoMes mes) {
    if (mes <= 0 || mes > 12) {
        return false;
    } else {
        return true;
    }
}


bool TipoFecha::ComprobarAnno(TipoAnno anno) {
    if (anno < 1601 || anno > 3000) {
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

int TipoFecha::MedirDistancia(TipoMes mes, TipoAnno anno) {

    int contadorDias = 0;

    for (int a = 1601; a < anno; a++) {
        contadorDias = contadorDias + ObtenerLongitudAnno(a);
    }

    for (int m = Enero; m < mes; m++) {
        contadorDias = contadorDias + ObtenerLongitudMes(TipoMes(m), anno);
    }

    return contadorDias;
}

int main() {

    TipoFecha fecha;
    TipoFormatoCalendario calendario;


    printf("Mes (1..12)? ");
    scanf("%d", &fecha.mes);

    printf("Ano (1601..3000)? ");
    scanf("%d", &fecha.anno);

    if (!(fecha.ComprobarMes(fecha.mes) && fecha.ComprobarAnno(fecha.anno))) {
        return 0;
    }

    fecha.mes = TipoMes(int(fecha.mes) - 1);

    printf("\n");
    calendario.ImprimirFecha(fecha.mes, fecha.anno);
    printf("\n");
    calendario.ImprimirSeparador(27, '=');
    printf("\n");
    calendario.ImprimirSiglasSemana();
    printf("\n");
    calendario.ImprimirSeparador(27, '=');

    calendario.GenerarCalendario(fecha.mes, fecha.anno);
    printf("\n");

}
