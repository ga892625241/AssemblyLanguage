.386
STACK SEGMENT USE16 STACK
	DB 200 DUP(0)
STACK ENDS

DATA SEGMENT USE16
	SECOND DB 0
	MINITE DB 2
	HOUR DB 4
DATA ENDS

CODE SEGMENT USE16
ASSUME CS:CODE, DS:DATA, SS:STACK

START:
	MOV AL,4
	OUT 70H,AL
	JMP $ + 2
	IN AL,71H
	
	CALL OUTPUT
	MOV DL,'H'
	MOV AH,02H
	INT 21H
	
	MOV AL,2
	OUT 70H,AL
	JMP $ + 2
	IN AL,71H
	
	CALL OUTPUT
	MOV DL,'M'
	MOV AH,02H
	INT 21H
	
	MOV AL,0
	OUT 70H,AL
	JMP $ + 2
	IN AL,71H
	
	CALL OUTPUT
	MOV DL,'S'
	MOV AH,02H
	INT 21H
	MOV AH,4CH
	INT 21H
	
OUTPUT PROC
	PUSH AX
	PUSH DX
	
	PUSH AX
	SHR AL,4
	ADD AL,30H
	
	MOV DL,AL
	MOV AH,02H
	INT 21H
	
	POP AX
	AND AL,00001111B
	ADD AL,30H
	
	MOV DL,AL
	MOV AH,02H
	INT 21H
	
	POP DX
	POP AX
	RET
OUTPUT ENDP

CODE ENDS
	END START
