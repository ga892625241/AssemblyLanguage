.386
STACK SEGMENT USE16 STACK
    DB 200 DUP(0)
STACK ENDS
DATA SEGMENT USE16
BUF  DB '*****THE SHOP IS SHOP_ONE*****$'
BUF1 DB 'PLEASE INPUT YOUR NAME $'
BUF2 DB 'PLEASE INPUT YOUR PASSWORD $'
BUF3 DB 'The name is wrong $'
BUF4 DB 'Please input the good you want $'
BUF5 DB 'The NAME is right $'
BUF6 DB 'The PWD is wrong$'
BUF7 DB 'Landed successfully$'
BUF8 DB 'Goods have been sold out$'
BUF9 DB 'The current recommendation is:$'
AUTH DB ?
COUNT DB ?
TOTAL DW ?
JUDGE1 DD ?
JUDGE2 DD ?
CRLF DB 0DH,0AH,'$'
IN_NAME DB 11
	DB ?
	DB 11 DUP(0)
IN_PWD   DB 7
	DB ?
	DB 7 DUP(0)
IN_GOOD DB 11
	DB ?
	DB 11 DUP(0)
BNAME DB 'WANGM',5 DUP(0)
COUNT1 = $-BNAME
BPASS DB 'TEST',0,0
COUNT2 = $-BPASS
N EQU 30
S1  DB 'SHOP_ONE',0
GA1 DB 'PEN',7 DUP(0),10
    DD 35,56,30000,25,?
GA2 DB 'BOOK',6 DUP(0),9
    DD 12,30,30000,5,?
GAN DB N-2 DUP('TEMP-VALUE',8,15,0,0,0,20,0,0,0,30,0,0,0,2,0,0,0,?,?,?,?)
DATA ENDS
CODE SEGMENT USE16
    ASSUME CS:CODE,DS:DATA,SS:STACK
START:
	MOV AX,DATA
	MOV DS,AX
	MOV AX,0;调用timer函数;以下代码与第一次实验不同
	CALL TIMER
	LEA DI,GA1
	MOV CX,30
	MOV BX,0
	MOV TOTAL,30000
	MOV COUNT,30
L_START:	
	MOV EAX, DWORD PTR [DI]+11
	MOV ECX, 10
	IMUL ECX
	SHL EAX,7
	MOV ESI, DWORD PTR [DI]+15
	MOV BL, BYTE PTR[DI]+10
	IMUL ESI, EBX
	DIV ESI
	MOV ESI, EAX
	MOV EAX, DWORD PTR [DI]+23
	SHL EAX,6
	DIV DWORD PTR [DI]+19
	ADD ESI,EAX
	MOV DWORD PTR[DI]+27,ESI
	ADD DI,31
	DEC COUNT
	CMP COUNT,0
	JNE L_START
	LEA DI,GA1
	MOV COUNT,30
	DEC TOTAL
	CMP TOTAL,0
	JNE L_START	
	MOV AX,1;函数
	CALL TIMER
	LEA DX,BUF
	MOV AH,9
	INT 21H
	LEA DX,CRLF
	MOV AH,9
	INT 21H	
L_IN_NAME: 	
	LEA DX,BUF1;输入用户名
	MOV AH,9
	INT 21H
	LEA DX,IN_NAME
	MOV AH,10
	INT 21H
	LEA DX,CRLF
	MOV AH,9
	INT 21H
	CMP IN_NAME+1,0;判断是否仅输入回车，若是，直接跳到功能3
	JE  L_AUTH_0
	CMP IN_NAME+1,1
	JNE L_CHECK_NAME
	CMP IN_NAME+2,71H
	JNE L_CHECK_NAME
	JMP OVER	
L_CHECK_NAME:
	LEA SI,IN_NAME
	LEA DI,BNAME
	MOV CL,1[SI]
	CMP CL,5
	JNE L_OUT_WRONG_N
L_LOOP_N:
	MOV AL,2[SI]
	MOV BL,[DI]
	INC SI
	INC DI
	CMP AL,BL
	JNE L_OUT_WRONG_N
	LOOP L_LOOP_N	
	LEA DX,BUF5
	MOV AH,9
	INT 21H
	LEA DX,CRLF
	MOV AH,9
	INT 21H	
L_IN_PWD:
	LEA DX,BUF2;输入密码
	MOV AH,9
	INT 21H
	LEA DX,IN_PWD
	MOV AH,10
	INT 21H
	LEA DX,CRLF
	MOV AH,9
	INT 21H	
	LEA SI,IN_PWD;比较密码
	LEA DI,BPASS
	MOV CL,1[SI]
	CMP CL,4
	JNE L_OUT_WRONG_PWD
L_CHECK_PWD:
	MOV AL,2[SI]
	MOV BL,[DI]
	INC SI
	INC DI
	CMP AL,BL
	JNE L_OUT_WRONG_PWD
	LOOP L_CHECK_PWD
	JMP L_AUTH_1
L_OUT_WRONG_N: 
	LEA DX,BUF3;提示输出错误的信息
	MOV AH,9
	INT 21H
	LEA DX,CRLF
	MOV AH,9
	INT 21H
	JMP L_IN_NAME;跳回开始	
L_OUT_WRONG_PWD:
	LEA DX,BUF6
	MOV AH,9
	INT 21H
	LEA DX,CRLF
	MOV AH,9
	INT 21H
	JMP L_IN_NAME
L_AUTH_0:
	MOV AUTH,0
	JMP L_IN_GOOD
L_AUTH_1:
	MOV AUTH,1
	LEA DX,BUF7
	MOV AH,9
	INT 21H
	LEA DX,CRLF
	MOV AH,9
	INT 21H
L_IN_GOOD:
	LEA DX,BUF4;提示输入商品名称
	MOV AH,9
	INT 21H	
	LEA DX,IN_GOOD
	MOV AH,10
	INT 21H	
	CMP IN_GOOD+1,0
	JNE L_CHECK_GOOD	
	LEA DX,CRLF
	MOV AH,9
	INT 21H
	JMP L_IN_NAME	
L_CHECK_GOOD:	
	LEA DX,CRLF
	MOV AH,9
	INT 21H
	MOV DX,0
	MOV AH,0
LL:
	LEA DI,GA1
	IMUL DX,31
	ADD DI,DX
	LEA SI,IN_GOOD
	MOV CL,1[SI]
L_LOOP_G: 
	MOV AL,2[SI]
	MOV BL,[DI]
	INC SI
	INC DI
	CMP AL,BL
	JNE L_NEXT_GOOD
	DEC CL
	CMP CL,0
	JE  L_CHECK_AUT
	JMP L_LOOP_G
L_NEXT_GOOD:;进入下个商品的位置
	INC DX
	CMP DX,5
	JE L_IN_GOOD
	JMP LL
L_CHECK_AUT:
	CMP AUTH,1
	JE L_OUT_GOOD_T
	JMP L_OUT_GOOD_N
L_OUT_GOOD_N:
	MOV BL,IN_GOOD+1
	MOV BH,0
	MOV BYTE PTR IN_GOOD+2[BX],'$'
	LEA DX,IN_GOOD+2
	MOV AH,9
	INT 21H 
	LEA DX,CRLF
	MOV AH,9
	INT 21H
	JMP L_IN_NAME
L_OUT_GOOD_T:	
	MOV AX,0
	MOV AL,IN_GOOD+1
	SUB DI,AX
	MOV TOTAL,30000
	MOV ECX,DWORD PTR[DI]+19
	MOV JUDGE1,ECX
	MOV EAX,DWORD PTR[DI]+23
	MOV JUDGE2,EAX
	MOV AX,0;调用timer函数;以下代码与第一次实验不同
	CALL TIMER	
L1:
	MOV EAX, DWORD PTR [DI]+11
	MOV ECX, 10
	IMUL ECX
	SHL EAX,7
	MOV ESI, DWORD PTR [DI]+15
	MOV BX,0
	MOV BL, BYTE PTR[DI]+10
	IMUL ESI, EBX
	DIV ESI
	MOV ESI, EAX
	MOV EAX, DWORD PTR [DI]+23
	SHL EAX,6
	DIV DWORD PTR [DI]+19
	ADD ESI,EAX
	MOV DWORD PTR[DI]+27,ESI		
	MOV EAX,JUDGE2
	CMP JUDGE1,EAX
	JB L_OUT_WRONG_G
	INC EAX
	MOV JUDGE2,EAX
	DEC TOTAL
	CMP TOTAL,0
	JNE L1	
L2:	LEA DX,BUF9
	MOV AH,9
	INT 21H	
	CMP ESI,100
	JG L_OUT_A	
	CMP ESI,50
	JG L_OUT_B	
	CMP ESI,10
	JG L_OUT_C
	JMP L_OUT_F	
	LEA DX,CRLF
	MOV AH,9
	INT 21H
	LEA DX,CRLF
	MOV AH,9
	INT 21H
	JMP L_IN_NAME
L_OUT_WRONG_G:
	LEA DX,BUF8
	MOV AH,9
	INT 21H
	JMP L2	
L_OUT_A: 
	MOV DL,'A'
	MOV AH,2
	INT 21H
	LEA DX,CRLF
	MOV AH,9
	INT 21H
	MOV AX,1;函数
	CALL TIMER
	JMP L_IN_NAME
L_OUT_B:
	MOV DL,'B'
	MOV AH,2
	INT 21H
	LEA DX,CRLF
	MOV AH,9
	INT 21H
	MOV AX,1;函数
	CALL TIMER
	JMP L_IN_NAME
L_OUT_C:
	MOV DL,'C'
	MOV AH,2
	INT 21H
	LEA DX,CRLF
	MOV AH,9
	INT 21H
	MOV AX,1;函数
	CALL TIMER
	JMP L_IN_NAME
L_OUT_F:
	MOV DL,'F'
	MOV AH,2
	INT 21H
	LEA DX,CRLF
	MOV AH,9
	INT 21H
	MOV AX,1;函数
	CALL TIMER
	JMP L_IN_NAME
OVER: 	
	MOV AH,4CH
	INT 21H		
TIMER	PROC
	PUSH  DX
	PUSH  CX
	PUSH  BX
	MOV   BX, AX
	MOV   AH, 2CH
	INT   21H	     ;CH=hour(0-23),CL=minute(0-59),DH=second(0-59),DL=centisecond(0-100)
	MOV   AL, DH
	MOV   AH, 0
	IMUL  AX,AX,1000
	MOV   DH, 0
	IMUL  DX,DX,10
	ADD   AX, DX
	CMP   BX, 0
	JNZ   _T1
	MOV   CS:_TS, AX
_T0:	POP   BX
	POP   CX
	POP   DX
	RET
_T1:	SUB   AX, CS:_TS
	JNC   _T2
	ADD   AX, 60000
_T2:	MOV   CX, 0
	MOV   BX, 10
_T3:	MOV   DX, 0
	DIV   BX
	PUSH  DX
	INC   CX
	CMP   AX, 0
	JNZ   _T3
	MOV   BX, 0
_T4:	POP   AX
	ADD   AL, '0'
	MOV   CS:_TMSG[BX], AL
	INC   BX
	LOOP  _T4
	PUSH  DS
	MOV   CS:_TMSG[BX+0], 0AH
	MOV   CS:_TMSG[BX+1], 0DH
	MOV   CS:_TMSG[BX+2], '$'
	LEA   DX, _TS+2
	PUSH  CS
	POP   DS
	MOV   AH, 9
	INT   21H
	POP   DS
	JMP   _T0
_TS	DW    ?
 	DB    'Time elapsed in ms is '
_TMSG	DB    12 DUP(0)
TIMER   ENDP
CODE ENDS 
	END START
