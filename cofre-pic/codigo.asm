; Codigo Controle Cofre Bluetooth
; Paulo Eduardo Manzone Maia
; RA: 161022261

#include <p16F873.inc>

; ========/ declarando variaveis que usarei ========
CBLOCK 0x20
	BYTE1 ; byte que chega pelo bluetooth (primeira parte da senha)
	BYTE2 ; byte que chega pelo bluetooth (segunda parte da senha)
	SENHA1 ; byte que armazena a senha
	SENHA2 ; byte que armazena a senha
	TEMPO1 ; variável auxiliar do for de nops do servomotor
	TEMPO2 ; variável auxiliar do for de nops do servomotor
	NLOOPS ; variável para contar quantos ciclos do servo deverão ser realizados	

ENDC
	ORG	0X0000
	GOTO 	INICIO
	
;interrupcao nao faz nada

	ORG	0X4
	RETFIE

;======================================================================
;				INICIO
;======================================================================
INICIO:
	;============== / Inicializacao =======================
	BANKSEL TRISB ;rb´s são de saída
	MOVLW d'0'
	MOVWF TRISB 
	BANKSEL SENHA1

	MOVLW d'0'
	MOVWF SENHA1 ; inicializa primeiro byte da senha como 00000000
	MOVWF SENHA2 ; inicializa segundo byte da senha como 00000000
	
	;============= /config bluetooth =======================

	banksel SPBRG ; muda para banco de SPBRG
	MOVLW d'25' ; baudrate = 9600
	MOVWF SPBRG
	banksel TXSTA
	BSF TXSTA, BRGH ; configurar para utilizar baudrate de alta velocidade
	BCF TXSTA, SYNC ; configurar para modo asssincrono de recepcao
	banksel RCSTA	; muda para banco de dados de rcsta
	BSF RCSTA, SPEN	; Habilita porta serial
	BCF RCSTA, RX9	; configura para receber 8 bits apenas
	BSF RCSTA, CREN ; recebe continuamente pela porta serial

	BANKSEL PORTB
	BSF PORTB, RB7 ; teste pra ver se chegou ate aqui

	;=============/FIM config bluetooth ==================

	;=============/loop leitura bluetooth ================
	; sao lidos 2 bytes do serial para serem tratados
	

LOOP1:
	BTFSS PIR1, RCIF ; fica verificando se existe byte no registrador RCREG (se tiver, RCIF igual a 1, senao 0)
	GOTO LOOP1
	
	MOVF RCREG, W ; le o RCREG para a var BYTE2
	MOVWF BYTE1
	
LOOP2:
	BTFSS PIR1, RCIF  ; fica verificando se existe byte no registrador RCREG (se tiver, RCIF igual a 1, senao 0)
	GOTO LOOP2

	MOVF RCREG, W ; le o RCREG para a var BYTE2
	MOVWF BYTE2	



	;==============/FIM leitura bluetooth ==============
	
	;==============/tratando a entrada =================
	
	MOVLW d'0' ; verificando se as senhas sao 0
	SUBWF SENHA1
	
	BTFSC STATUS, Z
	GOTO PRIMEIRAVEZ ; caso a senha nao seja zero vai pra PRIMEIRAVEZ

	MOVLW d'0'
	SUBWF SENHA2

	BTFSC STATUS, Z
	GOTO PRIMEIRAVEZ ; caso a senha nao seja zero vai pra PRIMEIRAVEZ

	;Se chegou aqui, nao é a primeira vez (já foi gravada uma senha e o cofre está trancado)
	
	MOVF SENHA1, W ; comparando byte1 com senha1
	SUBWF BYTE1
	BTFSS STATUS, Z
	GOTO VOLTATUDO
	
	MOVF SENHA2, W ; comparando byte2 com senha2
	SUBWF BYTE2
	BTFSS STATUS, Z
	GOTO VOLTATUDO
	
	;Se chegou aqui, a senha esta correta e ele deve abrir a tranca
	;**************************************************************************************************
	banksel PORTB
	BSF PORTB, RB7 ; led indicador = ligado
	banksel NLOOPS
	MOVLW d'20' ; 20 ciclos do servomotor
	MOVWF NLOOPS

INICIOCICLO:

; tempo ligado
	BSF PORTB, RB4

	CALL Delay1.5ms ; delay de 1.5 ms

; tempo desligado
	BCF PORTB, RB4

	CALL Delay18.5ms; delay de 18.5 ms


	DECFSZ NLOOPS ;verifica se faz denovo o ciclo
	GOTO INICIOCICLO

	MOVLW d'0' ;zera senha
	MOVWF SENHA1
	MOVWF SENHA2
	;****************************************************************************************************************
	
	GOTO VOLTATUDO
	
PRIMEIRAVEZ:
	;caso seja a primeira vez, deve-se gravar os bytes nas senhas
	MOVF BYTE1, W
	MOVWF SENHA1
	MOVF BYTE2, W
	MOVWF SENHA2

	;fechar a tranca
	;*********************************************************************************************************
	banksel PORTB
	BCF PORTB, RB7 ; led indicador = desligado
	banksel NLOOPS
	MOVLW d'20' ; 20 ciclos do servomotor
	MOVWF NLOOPS
	banksel TEMPO1

INICIOCICLOX:

; tempo ligado
	BSF PORTB, RB4
;1ms
	CALL Delay1ms

; tempo desligado
	BCF PORTB, RB4
;19ms
	CALL Delay19ms
NOP

;verifica se faz denovo o ciclo
	DECFSZ NLOOPS
	GOTO INICIOCICLOX
	


;***************************************************************************************************

VOLTATUDO:
	GOTO LOOP1 ; volta a ler do bluetooth


; DELAYS
;1 ms ---------------------
Delay1ms
			;993 cycles
	movlw	0xC6
	movwf	TEMPO1
	movlw	0x01
	movwf	TEMPO2
Delay1ms_0
	decfsz	TEMPO1, f
	goto	$+2
	decfsz	TEMPO2, f
	goto	Delay1ms_0

			;3 cycles
	goto	$+1
	nop

			;4 cycles (including call)
	return

;1.5 ms ------------------
Delay1.5ms
			;1493 cycles
	movlw	0x2A
	movwf	TEMPO1
	movlw	0x02
	movwf	TEMPO2
Delay1.5ms_0
	decfsz	TEMPO1, f
	goto	$+2
	decfsz	TEMPO2, f
	goto	Delay1.5ms_0

			;3 cycles
	goto	$+1
	nop

			;4 cycles (including call)
	return


;18.5ms-------------------

Delay18.5ms
			;18493 cycles
	movlw	0x72
	movwf	TEMPO1
	movlw	0x0F
	movwf	TEMPO2
Delay18.5ms_0
	decfsz	TEMPO1, f
	goto	$+2
	decfsz	TEMPO2, f
	goto	Delay18.5ms_0

			;3 cycles
	goto	$+1
	nop

			;4 cycles (including call)
	return

;19s
Delay19ms
			;18993 cycles
	movlw	0xD6
	movwf	TEMPO1
	movlw	0x0F
	movwf	TEMPO2
Delay19ms_0
	decfsz	TEMPO1, f
	goto	$+2
	decfsz	TEMPO2, f
	goto	Delay19ms_0

			;3 cycles
	goto	$+1
	nop

			;4 cycles (including call)
	return

	END