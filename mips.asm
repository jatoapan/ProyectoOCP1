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


llenar_tablero:
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	li $t0, 0

loop_llenar_tablero:
	bge $t0, $a1, fin_llenar_tablero
	li $v0, 42
	li $a0, 0
	li $a1, 91
	syscall
	addi $t1, $a0, 10
	lw $a0, 0($sp)
	sll $t2, $t0, 2
	add $t2, $t2, $a0
	sw $t1, 0($t2)
	addi $t0, $t0, 1
	lw $a1, 4($sp)
	j loop_llenar_tablero

fin_llenar_tablero:
	addi $sp, $sp, 8
	jr $ra

colocar_tesoros:
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	mul $t0, $a1, 3
	div $t0, $t0, 10
	li $t1, 0
	li $t2, -1

loop_colocar_tesoros:
	bge $t1, $t0, fin_colocar_tesoros
	li $v0, 42
	li $a0, 0
	syscall
	move $t3, $a0
	lw $a0, 0($sp)
	sll $t4, $t3, 2
	add $t4, $t4, $a0
	lw $t5, 0($t4)
	lw $a1, 4($sp)
	beq $t5, $t2, loop_colocar_tesoros
	sw $t2, 0($t4)
	addi $t1, $t1, 1
	j loop_colocar_tesoros

fin_colocar_tesoros:
	addi $sp, $sp, 8
	jr $ra

obtener_dado_jugador:

loop_pedir_dado:
	li $v0, 4
	la $a0, msg_pedir_dado
	syscall
	li $v0, 5
	syscall
	move $t0, $v0
	blt $t0, 1, loop_pedir_dado
	bgt $t0, 6, loop_pedir_dado
	move $v0, $t0
	jr $ra

actualizar_datos:
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	li $t0, -1
	sll $t1, $a1, 2
	add $t1, $t1, $a0
	lw $t2, 0($t1)
	sw $zero, 0($t1)
	beq $t2, $t0, es_tesoro

es_dinero:
	lw $t3, 0($a2)
	add $t3, $t3, $t2
	sw $t3, 0($a2)
	li $v0, 4
	la $a0, msg_recogio_dinero_p1
	syscall
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, msg_recogio_dinero_p2
	syscall
	lw $a0, 4($sp)
	li $v0, 1
	syscall
	j fin_actualizar_datos

es_tesoro:
	lw $t3, 0($a3)
	addi $t3, $t3, 1
	sw $t3, 0($a3)
	li $v0, 4
	la $a0, msg_encontro_tesoro
	syscall
	lw $a0, 4($sp)
	li $v0, 1
	syscall

fin_actualizar_datos:
	li $v0, 4
	la $a0, salto_linea
	syscall
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	addi $sp, $sp, 8
	move $v0, $t2
	jr $ra

determinar_ganador:
	li $t0, 3
	bge $a0, $t0, dg_gana_jugador
	bge $a1, $t0, dg_gana_maquina
	bgt $a2, $a3, dg_gana_jugador
	blt $a2, $a3, dg_gana_maquina
	bgt $a0, $a1, dg_gana_jugador
	j dg_gana_maquina

dg_gana_jugador:
	li $v0, 1
	jr $ra

dg_gana_maquina:
	li $v0, 0
	jr $ra

mostrar_resultados:
	addi $sp, $sp, -20
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)
	sw $ra, 16($sp)
	li $v0, 4
	la $a0, titulo_cabecera_final
	syscall
	la $a0, msg_resumen_jugador
	syscall
	li $v0, 1
	lw $a0, 0($sp)
	syscall
	li $v0, 4
	la $a0, msg_dinero_acumulado
	syscall
	li $v0, 1
	lw $t0, 8($sp)
	lw $a0, 0($t0)
	syscall
	li $v0, 4
	la $a0, salto_linea
	syscall
	la $a0, msg_resumen_maquina
	syscall
	li $v0, 1
	lw $a0, 4($sp)
	syscall
	li $v0, 4
	la $a0, msg_dinero_acumulado
	syscall
	li $v0, 1
	lw $t0, 12($sp)
	lw $a0, 0($t0)
	syscall
	li $v0, 4
	la $a0, salto_linea
	syscall
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $t0, 8($sp)
	lw $a2, 0($t0)
	lw $t1, 12($sp)
	lw $a3, 0($t1)
	jal determinar_ganador
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $t0, 0($a2)
	lw $t1, 0($a3)
	add $t2, $t0, $t1
	li $t3, 1
	beq $v0, $t3, mr_gana_jugador

mr_gana_maquina:
	li $v0, 4
	la $a0, msg_gana_maquina
	syscall
	sw $zero, 0($a2)
	sw $t2, 0($a3)
	j imprimir_cantidades_finales

mr_gana_jugador:
	li $v0, 4
	la $a0, msg_gana_jugador
	syscall
	sw $t2, 0($a2)
	sw $zero, 0($a3)

imprimir_cantidades_finales:
	li $v0, 4
	la $a0, msg_premio_jugador
	syscall
	li $v0, 1
	lw $a0, 0($a2)
	syscall
	li $v0, 4
	la $a0, salto_linea
	syscall
	li $v0, 4
	la $a0, msg_premio_maquina
	syscall
	li $v0, 1
	lw $a0, 0($a3)
	syscall
	li $v0, 4
	la $a0, salto_linea
	syscall
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	jr $ra


