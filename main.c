#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void llenar_tablero(int *tablero, int cantidad_casillas) { 
    int dinero_minimo = 10;
    int dinero_maximo = 100;
    for (int i = 0; i < cantidad_casillas; i++) {
        tablero[i] = (rand() % (dinero_maximo - dinero_minimo + 1)) + dinero_minimo;
    }
}

void colocar_tesoros(int *tablero, int cantidad_casillas) {
    int valor_tesoro = -1;
    int tesoros_colocados = 0;
    float porcentaje = 0.3;
    int cantidad_tesoros_meta = cantidad_casillas * porcentaje;
    while (tesoros_colocados < cantidad_tesoros_meta) {
        int indice_aleatorio = rand() % cantidad_casillas;
        if (tablero[indice_aleatorio] != valor_tesoro) {
            tablero[indice_aleatorio] = valor_tesoro;
            tesoros_colocados++;
        }
    }
}

int obtener_dado_jugador() {
    int valor_dado = 0;
    while (valor_dado < 1 || valor_dado > 6) {
        printf("Por favor, ingrese el valor del dado (1-6): ");
        scanf("%d", &valor_dado);
    }
    return valor_dado;
}

void actualizar_datos(int *tablero, int posicion_actual, int *dinero, int *tesoros) {
    int valor_tesoro = -1;
    int valor_encontrado = tablero[posicion_actual];
    tablero[posicion_actual] = 0;
    if (valor_encontrado == valor_tesoro) { 
        *dinero += 1;
        printf(" -> ¡Genial! Se encontró un TESORO escondido en la casilla %d.\n", posicion_actual);
    } else {
        *tesoros += valor_encontrado;
        printf(" -> Se recogió dinero: $%d en la casilla %d.\n", valor_encontrado, posicion_actual);
    }
}

int determinar_ganador(int tesoros_jugador, int tesoros_maquina, int dinero_jugador, int dinero_maquina) {
    int meta_tesoros = 3;
    if (tesoros_jugador >= meta_tesoros) return 1;
    if (tesoros_maquina >= meta_tesoros) return 0;
    if (dinero_jugador > dinero_maquina) return 1;
    if (dinero_jugador < dinero_maquina) return 0;
    if (tesoros_jugador > tesoros_maquina) return 1;
    return 0;
}

void mostrar_resultados(int tesoros_jugador, int tesoros_maquina, int *dinero_jugador, int *dinero_maquina) {
    printf("\n=========================================\n");
    printf("           RESULTADOS FINALES            \n");
    printf("=========================================\n");
    printf("JUGADOR -> Tesoros encontrados: %d | Dinero acumulado: $%d\n", tesoros_jugador, *dinero_jugador);
    printf("MAQUINA -> Tesoros encontrados: %d | Dinero acumulado: $%d\n", tesoros_maquina, *dinero_maquina);
    int es_ganador_jugador = determinar_ganador(tesoros_jugador, tesoros_maquina, *dinero_jugador, *dinero_maquina);
    int dinero_total = *dinero_jugador + *dinero_maquina;
    if (es_ganador_jugador) {
        printf("\n¡FELICIDADES JUGADOR! Has ganado el juego.\n");
        *dinero_jugador = dinero_total; 
        *dinero_maquina = 0;
    } else {
        printf("\nLA MAQUINA GANA EL JUEGO.\n");
        *dinero_jugador = 0;
        *dinero_maquina = dinero_total;
    }
    printf("Te llevas: $%d\n", *dinero_jugador);
    printf("La maquina se lleva: $%d\n", *dinero_maquina);
}

int main() {
    srand(time(NULL));
    int numero_casillas = 0;
    
    while (numero_casillas < 20 || numero_casillas > 120) {
        printf("Ingrese el tamaño del tablero (entre 20 y 120 casillas): ");
        scanf("%d", &numero_casillas);
    }
    
    int *tablero = (int*) malloc(numero_casillas * sizeof(int)); 
    
    llenar_tablero(tablero, numero_casillas);
    colocar_tesoros(tablero, numero_casillas);

    int posicion_jugador = 0; 
    int posicion_maquina = 0;
    int dinero_jugador = 0; 
    int dinero_maquina = 0;
    int tesoros_jugador = 0; 
    int tesoros_maquina = 0;
    int es_turno_jugador = 1; 
    int meta_tesoros = 3; 
    int valor_dado;

    while (posicion_jugador < numero_casillas && posicion_maquina < numero_casillas && 
           tesoros_jugador < meta_tesoros && tesoros_maquina < meta_tesoros) {
        
        if (es_turno_jugador) {
            printf("\n--- TURNO DEL JUGADOR ---\n");
            valor_dado = obtener_dado_jugador();
            printf("Has sacado un: %d\n", valor_dado); 
            posicion_jugador += valor_dado;
            
            if (posicion_jugador >= numero_casillas) { 
                printf("¡El Jugador llego al final del tablero!\n"); 
                es_turno_jugador = 0; 
                break; 
            }
            
            actualizar_datos(tablero, posicion_jugador, &dinero_jugador, &tesoros_jugador);
            es_turno_jugador = 0;
        } else {
            printf("\n--- TURNO DE LA MAQUINA ---\n");
            valor_dado = (rand() % 6) + 1;
            printf("La maquina lanza el dado y obtiene: %d\n", valor_dado);
            posicion_maquina += valor_dado;
            
            if (posicion_maquina >= numero_casillas) { 
                printf("¡La Maquina llego al final del tablero!\n"); 
                es_turno_jugador = 1; 
                break; 
            }
            
            actualizar_datos(tablero, posicion_maquina, &dinero_maquina, &tesoros_maquina);   
            es_turno_jugador = 1;
        }
        
        printf("ESTADO ACTUAL:\n");
        printf("   Jugador -> Posicion: %d | Tesoros: %d | Dinero: $%d\n", posicion_jugador, tesoros_jugador, dinero_jugador);
        printf("   Maquina -> Posicion: %d | Tesoros: %d | Dinero: $%d\n", posicion_maquina, tesoros_maquina, dinero_maquina);
    }

    while (posicion_jugador < numero_casillas && tesoros_jugador < meta_tesoros && tesoros_maquina < meta_tesoros) {
        printf("\n--- TURNO EXTRA DEL JUGADOR ---\n");
        valor_dado = obtener_dado_jugador();
        printf("Has sacado un: %d\n", valor_dado); 
        posicion_jugador += valor_dado;
        
        if (posicion_jugador >= numero_casillas) {
             printf("¡El Jugador llego al final del tablero!\n"); 
             break;
        }
        
        actualizar_datos(tablero, posicion_jugador, &dinero_jugador, &tesoros_jugador);
        printf("   Jugador -> Posicion: %d | Tesoros: %d | Dinero: $%d\n", posicion_jugador, tesoros_jugador, dinero_jugador);
    }

    while (posicion_maquina < numero_casillas && tesoros_jugador < meta_tesoros && tesoros_maquina < meta_tesoros) {
        printf("\n--- TURNO EXTRA DE LA MAQUINA ---\n");
        valor_dado = (rand() % 6) + 1;
        printf("La maquina lanza el dado y obtiene: %d\n", valor_dado);
        posicion_maquina += valor_dado;
        
        if (posicion_maquina >= numero_casillas) {
            printf("¡La Maquina llego al final del tablero!\n");
            break;
        }
        
        actualizar_datos(tablero, posicion_maquina, &dinero_maquina, &tesoros_maquina);
        printf("   Maquina -> Posicion: %d | Tesoros: %d | Dinero: $%d\n", posicion_maquina, tesoros_maquina, dinero_maquina);
    }

    mostrar_resultados(tesoros_jugador, tesoros_maquina, &dinero_jugador, &dinero_maquina);

    free(tablero);
    return 0;
}