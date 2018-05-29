; Codigo Controle Cofre Bluetooth
; Paulo Eduardo Manzone Maia
; RA: 161022261

#include <p16F873.inc>

; ========/ declarando variaveis que usarei ========
CBLOCK 0x20
	BYTE1
	BYTE2
	SENHA1
	SENHA2

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
	;============== / Inicializacao ========================
	MOVLW b'00000000'
	MOVWF SENHA1 ; inicializa primeiro byte da senha como 00000000
	MOVWF SENHA2 ; inicializa segundo byte da senha como 00000000
	
	MOVLW b'11111101'
	MOVWF TRISB ; configurando RBs
	
	;============= /config bluetooth =======================
	banksel SPBRG ; muda para banco de SPBRG
	MOVLW d'25' ; baudrate = 9600
	MOVWF SPBRG
	BSF TXSTA, BRGH ; configurar para utilizar baudrate de alta velocidade
	BCF TXSTA, SYNC ; configurar para modo asssincrono de recepcao
	BSF RCSTA, SPEN	; Habilita porta serial
	banksel RCSTA	; muda para banco de dados de rcsta
	BCF RCSTA, RX9	; configura para receber 8 bits apenas
	BSF RCSTA, CREN ; recebe continuamente pela porta serial
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

	;Se chegou aqui, nao eh a primeira vez (j� foi gravada uma senha e o cofre est� trancado)
	
	MOVF SENHA1, W ; comparando byte1 com senha1
	SUBWF BYTE1
	BTFSS STATUS, Z
	GOTO VOLTATUDO
	
	MOVF SENHA2, W ; comparando byte2 com senha2
	SUBWF BYTE2
	BTFSS STATUS, Z
	GOTO VOLTATUDO
	
	;Se chegou aqui, a senha esta correta e ele deve abrir a tranca
	;**********************************


	;***********************************
	
	GOTO VOLTATUDO
	
PRIMEIRAVEZ:
	;caso seja a primeira vez, deve-se gravar os bytes nas senhas
	MOVF BYTE1, W
	MOVWF SENHA1
	MOVF BYTE2, W
	MOVWF SENHA2

	;fechar a tranca
	;***********************************


	;***********************************

VOLTATUDO:
	GOTO LOOP1 ; volta a ler do bluetooth

	END
