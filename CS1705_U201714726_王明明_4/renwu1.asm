.386
DATA    SEGMENT  USE16  PUBLIC 'DATA'
DATA ENDS
STACK   SEGMENT  USE16 STACK
    DB  200 DUP(0)
STACK   ENDS
CODE    SEGMENT  USE16  PUBLIC 'CODE'
ASSUME CS:CODE,DS:DATA,SS:STACK
START:  MOV AX,DATA
        MOV DS,AX
                
        MOV AX,3501H
        INT 21H
                
        MOV DX,FS:[04H]
        MOV SI,FS:[06H]
       
CODE    ENDS
END START
