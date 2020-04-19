DATAS SEGMENT
     hint db 'The Lucky Number is: $'
     flag db 0 							;the flag of proc
     
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    
    mov ah,9
    mov al,' '			; just set background
    mov bl,01001010b	; color configure
    mov bh,0			; page 0
    int 10h
    
    lea dx,hint			; output hint
   	mov ah,9
   	int 21h
    
main:
	
	xor ax,ax
	mov ah,01h			; keyborad status
	int 16h				; scan but do not interrupt
	jz noinput
	mov ah,00h			
	int 16h
	cmp al,32			; space = 32d
	je bye

noinput:
 	mov ah,2			; set position
	mov bh,0			; page 0
	mov dh,1			; line number
	mov dl,0			; column number
	int 10h
	
once:
	mov cx,10
	; mloop output 10 random numbers
mloop:
	push cx
	call random
	call numToAsc
	pop cx
loop mloop
	jmp main

	
bye:
	mov ah,2			; set position
	mov bh,0			; page 0
	mov dh,1			; line number
	mov dl,0			; column number
	int 10h

last:
	mov cx,10
lloop:
	push cx
	call random
	call numToAsc
	pop cx
loop lloop
	
	mov ah,03h			; interrupt
	int 21h 

    MOV AH,4CH
    INT 21H
    
numToAsc proc 
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
	mov flag,0			;��ԭ���������������ǰ��0
	ret
numToAsc endp        

random proc		
	;41h I/O port is system timer
	;frequency is 1.193MHZ
	mov dx,41h			; now we get a count	
	in al,dx
	mov ah,0			; ax is the random			
	mov dl,10
	div dl				; mod 10
	mov al,ah
	mov ah,0			; random number in ax
	ret
random endp

pause proc
	mov ah,86h			; bios pause function, unit is us
	; pause time saves dw in cx(high) and dx(low)
	mov cx,19h
	mov dx,9848h		; 0x199848 I dont know how long
	int 15h
	ret
pause endp
    
CODES ENDS
    END START




