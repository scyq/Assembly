DATAS SEGMENT
    ;�˴��������ݶδ���  
    letters db 30 dup(?)
DATAS ENDS

STACKS SEGMENT stack
    dw 256 dup(0)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    
    xor si,si			; ��¼����
input:    
    mov ah,01
    int 21h
    cmp al,13			; ����Ǿͻس�����
    je judge
    mov letters[si],al
    inc si
    jmp input
    
judge:
	mov cx,si			; ��¼����
	xor si,si
	
sj:
	mov al,letters[si]
	cmp al,'A'
	jb continue
	cmp al,'Z'
	ja continue
	jmp op

op:
	add al,20h			; Сд��ĸ�ȴ�д��ĸ��20h
	mov ah,02
	mov dl,al
	int 21h
	inc si
	loop sj
	jmp bye
   
continue:
    mov ah,02
    mov dl,al
    int 21h
    inc si
    loop sj
    
bye:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
