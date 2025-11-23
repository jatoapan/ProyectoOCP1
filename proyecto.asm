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

.globl main

main:
	addi $sp, $sp, -36
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)

loop_pedir_tamano:
	li $v0, 4
	la $a0, msg_pedir_casillas
	syscall
	li $v0, 5
	syscall
	move $s0, $v0
	li $t2, 20
	blt $s0, $t2, loop_pedir_tamano
	li $t2, 120
	bgt $s0, $t2, loop_pedir_tamano

	sll $a0, $s0, 2
	li $v0, 9
	syscall
	move $s1, $v0
	move $a0, $s1
	move $a1, $s0
	jal llenar_tablero
	move $a0, $s1
	move $a1, $s0
	jal colocar_tesoros

	li $s2, 0
	li $s3, 0
	li $s4, 0
	li $s5, 0
	li $s6, 0
	li $s7, 0
	li $t0, 1
	li $t1, 3

loop_principal:
	bge $s2, $s0, fin_loop_principal
	bge $s3, $s0, fin_loop_principal
	bge $s6, $t1, fin_loop_principal
	bge $s7, $t1, fin_loop_principal
	bne $t0, 1, turno_principal_maquina

turno_principal_jugador:
	li $v0, 4
	la $a0, titulo_turno_jugador
	syscall
	jal obtener_dado_jugador
	move $t2, $v0
	li $v0, 4
	la $a0, msg_dado_jugador
	syscall
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, salto_linea
	syscall
	add $s2, $s2, $t2
	bge $s2, $s0, finalizo_jugador_principal
	move $a0, $s1
	move $a1, $s2
	addi $a2, $sp, 16
	addi $a3, $sp, 24
	sw $s4, 16($sp)
	sw $s6, 24($sp)
	jal actualizar_datos
	lw $s4, 16($sp)
	lw $s6, 24($sp)
	li $t0, 0
	j mostrar_estado_general

finalizo_jugador_principal:
	li $v0, 4
	la $a0, msg_jugador_finalizo
	syscall
	li $t0, 0
	j mostrar_estado_general

turno_principal_maquina:
	li $v0, 4
	la $a0, titulo_turno_maquina
	syscall
	li $v0, 42
	li $a0, 0
	li $a1, 6
	syscall
	addi $t2, $a0, 1    # $t2 = random entre 1 y 6
	li $v0, 4
	la $a0, msg_dado_maquina
	syscall
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, salto_linea
	syscall
	add $s3, $s3, $t2
	bge $s3, $s0, finalizo_maquina_principal
	move $a0, $s1
	move $a1, $s3
	addi $a2, $sp, 20
	addi $a3, $sp, 28
	sw $s5, 20($sp)
	sw $s7, 28($sp)
	jal actualizar_datos
	lw $s5, 20($sp)
	lw $s7, 28($sp)
	li $t0, 1
	j mostrar_estado_general

finalizo_maquina_principal:
	li $v0, 4
	la $a0, msg_maquina_finalizo
	syscall
	li $t0, 1
	j mostrar_estado_general

mostrar_estado_general:
	li $v0, 4
	la $a0, titulo_estado_actual
	syscall

	li $v0, 4
	la $a0, msg_estado_jugador
	syscall
	li $v0, 1
	move $a0, $s2
	syscall
	li $v0, 4
	la $a0, msg_tesoros
	syscall
	li $v0, 1
	move $a0, $s6
	syscall
	li $v0, 4
	la $a0, msg_dinero
	syscall
	li $v0, 1
	move $a0, $s4
	syscall

	li $v0, 4
	la $a0, msg_estado_maquina
	syscall
	li $v0, 1
	move $a0, $s3
	syscall
	li $v0, 4
	la $a0, msg_tesoros
	syscall
	li $v0, 1
	move $a0, $s7
	syscall
	li $v0, 4
	la $a0, msg_dinero
	syscall
	li $v0, 1
	move $a0, $s5
	syscall

	li $v0, 4
	la $a0, salto_linea
	syscall
	j loop_principal

fin_loop_principal:

turno_extra_jugador:
	bge $s2, $s0, fin_turno_extra_jugador
	bge $s6, $t1, fin_juego
	bge $s7, $t1, fin_juego
	li $v0, 4
	la $a0, titulo_extra_jugador
	syscall
	jal obtener_dado_jugador
	move $t2, $v0
	li $v0, 4
	la $a0, msg_dado_jugador
	syscall
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, salto_linea
	syscall
	add $s2, $s2, $t2
	bge $s2, $s0, finalizo_extra_jugador
	move $a0, $s1
	move $a1, $s2
	addi $a2, $sp, 16
	addi $a3, $sp, 24
	sw $s4, 16($sp)
	sw $s6, 24($sp)
	jal actualizar_datos
	lw $s4, 16($sp)
	lw $s6, 24($sp)
	li $v0, 4
	la $a0, msg_estado_jugador
	syscall
	li $v0, 1
	move $a0, $s2
	syscall
	li $v0, 4
	la $a0, msg_tesoros
	syscall
	li $v0, 1
	move $a0, $s6
	syscall
	li $v0, 4
	la $a0, msg_dinero
	syscall
	li $v0, 1
	move $a0, $s4
	syscall
	li $v0, 4
	la $a0, salto_linea
	syscall
	j turno_extra_jugador

finalizo_extra_jugador:
	li $v0, 4
	la $a0, msg_jugador_finalizo
	syscall

fin_turno_extra_jugador:

turno_extra_maquina:
	bge $s3, $s0, fin_juego
	bge $s6, $t1, fin_juego
	bge $s7, $t1, fin_juego
	li $v0, 4
	la $a0, titulo_extra_maquina
	syscall
	li $v0, 42
	li $a0, 0
	li $a1, 6
	syscall
	addi $t2, $a0, 1
	li $v0, 4
	la $a0, msg_dado_maquina
	syscall
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, salto_linea
	syscall
	add $s3, $s3, $t2
	bge $s3, $s0, finalizo_extra_maquina
	move $a0, $s1
	move $a1, $s3
	addi $a2, $sp, 20
	addi $a3, $sp, 28
	sw $s5, 20($sp)
	sw $s7, 28($sp)
	jal actualizar_datos
	lw $s5, 20($sp)
	lw $s7, 28($sp)
	li $v0, 4
	la $a0, msg_estado_maquina
	syscall
	li $v0, 1
	move $a0, $s3
	syscall
	li $v0, 4
	la $a0, msg_tesoros
	syscall
	li $v0, 1
	move $a0, $s7
	syscall
	li $v0, 4
	la $a0, msg_dinero
	syscall
	li $v0, 1
	move $a0, $s5
	syscall
	li $v0, 4
	la $a0, salto_linea
	syscall
	j turno_extra_maquina

finalizo_extra_maquina:
	li $v0, 4
	la $a0, msg_maquina_finalizo
	syscall

fin_juego:
	move $a0, $s6
	move $a1, $s7
	addi $a2, $sp, 16
	addi $a3, $sp, 20
	jal mostrar_resultados
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	li $v0, 10
	syscall

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