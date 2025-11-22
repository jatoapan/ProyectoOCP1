.data

	direccion_tablero: .word 0
	msg_pedir_casillas: .asciiz "Ingrese el tamano del tablero (entre 20 y 120 casillas): "
	msg_pedir_dado:    .asciiz "Por favor, ingrese el valor del dado (1-6): "
	titulo_turno_jugador:   .asciiz "\n--- TURNO DEL JUGADOR ---\n"
	titulo_turno_maquina:   .asciiz "\n--- TURNO DE LA MAQUINA ---\n"
	titulo_extra_jugador:   .asciiz "\n--- TURNO EXTRA DEL JUGADOR ---\n"
	titulo_extra_maquina:   .asciiz "\n--- TURNO EXTRA DE LA MAQUINA ---\n"
	msg_dado_jugador:     .asciiz "Has sacado un: "
	msg_dado_maquina:    .asciiz "La maquina lanza el dado y obtiene: "
	msg_jugador_finalizo:    .asciiz "El Jugador llego al final del tablero!\n"
	msg_maquina_finalizo:    .asciiz "La Maquina llego al final del tablero!\n"
	msg_encontro_tesoro: .asciiz " -> Genial! Se encontro un TESORO escondido en la casilla "
	msg_recogio_dinero_p1: .asciiz " -> Se recogio dinero: $"
	msg_recogio_dinero_p2: .asciiz " en la casilla "
	titulo_estado_actual:  .asciiz "ESTADO ACTUAL:\n"
	msg_estado_jugador:      .asciiz "   Jugador -> Posicion: "
	msg_estado_maquina:      .asciiz "   Maquina -> Posicion: "
	msg_tesoros:  .asciiz " | Tesoros: "
	msg_dinero:    .asciiz " | Dinero: $"
	titulo_cabecera_final:      .asciiz "\n=========================================\n           RESULTADOS FINALES            \n=========================================\n"
	msg_resumen_jugador:    .asciiz "JUGADOR -> Tesoros encontrados: "
	msg_resumen_maquina:    .asciiz "MAQUINA -> Tesoros encontrados: "
	msg_dinero_acumulado: .asciiz " | Dinero acumulado: $"
	msg_gana_jugador:        .asciiz "\nFELICIDADES JUGADOR! Has ganado el juego.\n"
	msg_gana_maquina:        .asciiz "\nLA MAQUINA GANA EL JUEGO.\n"
	msg_premio_jugador:      .asciiz "Te llevas: $"
	msg_premio_maquina:      .asciiz "La Maquina se lleva: $"
	salto_linea:            .asciiz "\n"

.text

