NUM MACRO
    ;��ת����������AX�Ĵ�����     
    mov bx,10000		;��ʼ��λȨֵΪ10000
    
cov:xor dx,dx			;��dx:ax�е���ֵ����Ȩֵ
	div bx
	mov cx,dx			;�������ݵ�CX�Ĵ�����
	
	cmp flag,0			;����Ƿ���������0��ֵ
	jne nor1			;�����������򲻹����Ƿ�Ϊ0�������ʾ
	cmp ax,0			;��δ���������������Ƿ�Ϊ0
	je cont				;Ϊ0�������ʾ
	
nor1:
	mov dl,al			;����ת��Ϊascii�������ʾ
	add dl,30h
	mov ah,2
	int 21h
	
	mov flag,1			;��������0�̣��򽫱�־��1
	
cont:
	cmp bx,10			;���Ȩֵ�Ƿ��Ѿ��޸ĵ�ʮλ��
	je outer			;�����ȣ���������ĸ�λ�������ʾ
	
	xor dx,dx			;����λȨֵ����10
	mov ax,bx
	mov bx,10
    div bx
    mov bx,ax
    
    mov ax,cx			;�����ݵ���������AX
    jmp cov    			;����ѭ��
   
outer:
	mov dl,cl			;���ĸ�λ����Ϊascii�������ʾ
	add dl,30h
	mov ah,2
	int 21h  

space:					;���һ���ո�
	mov ax,32 			;�ո�
	mov dl,al
	mov ah,2
	int 21h
	MOV FLAG,0			;��ԭ���������������ǰ��0
ENDM

;judge it is
JUDGE MACRO	
	;idiv quotient in AL, remainder in AH (dw operate)
	;number to judge is in BX			
	MOV DL,64H			;dec 100 = hex 64
	MOV AX,BX			;divident is in ax
	DIV DL				;ab in AL, cd in AH
	PUSH BX
	ADD AL,AH			;AL now saves ab + cd
	MOV AH,0			;AX now Saves ab + cd
	MUL AX				;square (ab + cd), result in ax
	POP BX				;BX is still the Number
	CMP AX,BX
	JE SUCCESS
	JNE ENDJ
SUCCESS:
	MOV AX,BX			;ready to output
	PUSH BX				;protect
	PUSH CX
	NUM				
	POP CX
	POP BX
	JMP ENDJ
	
ENDJ:
	INC BX				;BX++
	ENDM


DATAS SEGMENT
	HINT DB	'The answers that satisfy abcd = (ab+cd)^2 are:$'
	FLAG DB 0			;numתasc�ı�ʶ
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    MOV BX,1000			;starter
    MOV CX,9000			;1000~9999
    
    LEA DX,HINT			;output hint
    MOV AH,09
    INT 21H
    
    MOV DL,10			;enter a line
    MOV AH,02			
   	INT 21H				

MAIN:
	JUDGE			
LOOP MAIN		
    
    
EXIT:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START




