DATAS SEGMENT
    FLAG DB 0			;numתasc�ı�ʶ
    HINT DB 'Ten natural number with different difference:$' ;��ʾ
DATAS ENDS

STACKS SEGMENT

STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
	
	LEA DX,HINT ;������ʾ
	MOV AH,09
	INT 21H
	MOV DX,10	;����
	MOV AH,02
	INT 21H
	
	
	MOV AX,0	
	CALL NUM	;���
	MOV AX,1
	MOV CX,8	;ѭ������
	PUSH AX		;ѹջ����
	PUSH CX
	CALL NUM
	POP CX
	POP AX
	
MAIN:
	ADD AX,AX	;���ϵ�0����Ŀǰ������ֵ
	INC AX		;�ټ�1���������ܳ��ֹ�
	PUSH AX
	PUSH CX
	CALL NUM
	POP CX
	POP AX
LOOP MAIN
   
EXIT: ;�������
    MOV AH,4CH
    INT 21H
    
; NumתASC���ӳ���
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
	MOV FLAG,0			;��ԭ���������������ǰ��0
RET

CODES ENDS
    END START




