DATAS SEGMENT
    MINUS DB 46 DUP(0)  ; �����ֵ ������� C 10 2 = 45
    ANS DB 10 DUP(0)   ; �����
    FLAG DB 0			;numתasc�ı�ʶ
    HINT DB 'Ten natural number with different difference:$' ;��ʾ
    ZERO DB 0
DATAS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS
START:
    MOV AX,DATAS
    MOV DS,AX

	LEA DX,HINT ;������ʾ
	MOV AH,09
	INT 21H
	MOV DX,10	;����
	MOV AH,02
	INT 21H
	
    MOV SI,0	;��ֵ�����±�
    MOV DI,46	;�������±�       
    MOV AX,0	;ANS[0] = 0
    MOV BX,1    ;��ŵ�ǰ������
    
    MOV [DI],AX
    JMP NUM

MAIN_LOOP:
	MOV DX,BX	;���䵱ǰ������
	MOV AX,[DI]	;�������µĿ�����
	SUB BX,AX	;�õ������¿������Ĳ�
	MOV AX,BX	;���䵱ǰ�Ĳ�

CHECK:
	CMP BX,[SI]	;�Ƚϵ�ǰ��ֵ�Ͳ�ֵ���е�ֵ
	JE FAIL		;��ȿ϶�����	
	MOV CX,0	
	CMP CX,[SI] ;[SI]Ϊ0˵�����λ��û�в�
	JE SUCCESS	;���������
	JNE PLUS	;����ȣ�˵�����������Ǻ�BX�����SI++
	
PLUS:			;����SI
	INC SI
	JMP CHECK
	
SUCCESS:
	INC DI		;��+1
	MOV [DI],DX	;��¼��
	MOV [SI],AX	;���²�ֵ��  
	
	MOV	AX,0	;��ԭSIָ��
	MOV SI,AX
	MOV BX,[DI] ;��BX����Ϊ������
	MOV AX,BX	;��Ҫ����Ĵ���AX��
	INC BX		;������+1����Ϊ��һ�ε����
	JMP	NUM

FAIL:
	MOV BX,DX	;��ԭ���Ǹ���������
	INC BX		;+1
	MOV AX,0	;��ԭSI
	MOV SI,AX
	JMP MAIN_LOOP


; NumתASC��
NUM:         
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
	
JUMPBACK:
	MOV FLAG,0			;��ԭ
	CMP DI,55
	JB MAIN_LOOP
	JE EXIT
  
    
EXIT: ;�������
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START

