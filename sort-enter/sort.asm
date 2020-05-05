enterline macro
	mov dl,10
	mov ah,02
	int 21h
endm

DATAS SEGMENT
	buf db 10,?,10 dup(0)
    numbers dw 10 dup(?)		; changable
    wrong db 'Your Input is not legal$'
    flag db 0
DATAS ENDS

STACKS SEGMENT stack
	dw 256 dup(?)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    xor si,si
    xor di,di

input:
	mov cx,10			; changable
inL:
	xor ax,ax
	push cx
	push si
	call ascToNum
	pop si
	mov numbers[si],ax
	add si,2			; db, +2
	enterline
    pop cx
loop inL
    
	mov cx,9			; bubble sort times
csi:
	xor di,di
	xor si,si
bubble:
	xor ax,ax
	xor bx,bx
	mov ax,numbers[si]
	mov bx,numbers[si+2]
	cmp ax,bx
	
	; compare ax bx
	; if ax < bx continue
	; else swap(ax, bx)
	jb sorted
	mov numbers[si],bx
	mov numbers[si+2],ax
	
sorted:
	add si,2
	inc di
	cmp di,cx
	
	; �Ƚ�cx��di��С��di<cxת��
	jb bubble
	loop csi
	
; output
	mov cx,10
output:
	xor si,si

os:
	xor ax,ax
	mov ax,numbers[si]
	push cx
	call numToAsc
	pop cx
	add si,2
	loop os
    
    
    MOV AH,4CH
    INT 21H
    
ascToNum proc	
again:
	lea dx,buf		;�Ӽ��̽���������ֵ����buf������
    mov ah,10
    int 21h
    
    mov cl,buf+1	;��ȡʵ�ʼ����ַ���������CX�Ĵ�����
    xor ch,ch
    
    xor di,di		;�ۼ�����0
    
    xor dx,dx		;DX�Ĵ�����0
    
    mov bx,1		;���ڴӸ�λ����ʼ�������������Ȩֵ��Ϊ1
    
    lea si,buf+2	;��siָ����յ��ĵ�1���ַ�λ��
    add si,cx		;��Ϊ�Ӹ�λ�������Խ�siָ�����1�����յ��ĸ�λ��
    dec si
    
cov:
	mov al,[si]		;ȡ����λ����al
	cmp al,'0'		;�߽��飺������벻��0-9�����֣��ͱ���
	jb error
	cmp al,'9'
	ja error

    sub al,30h		;��al�е�ascii��תΪ����
    xor ah,ah
    mul bx			;����������λ��Ȩֵ
    cmp dx,0		;�жϽ���Ƿ񳬳�16λ����Χ���糬���򱨴�
    jne error
    
    add di,ax		;���γɵ���ֵ�����ۼ���di��
    jc error		;����ֵ����16λ����Χ����
    
      
    mov ax,bx		;��BX�е���λȨֵ����10
    mov bx,10
    mul bx
    cmp dx,0		;�жϽ���Ƿ񳬳�16λ����Χ���糬���򱨴�
    jne error1 
    mov bx,ax
    
    dec si			;siָ���1��ָ��ǰһ��λ
    loop cov    	;��CX�е��ַ���������ѭ��
   
suc:
	mov ax,di		;������ת�������di�з��õ�ax��
	jmp stop

error1:
	cmp cx,1
	jbe suc
	
error:				;����������ʾ
	lea dx,wrong
    mov ah,9
    int 21h
    
    enterline 
    
    jmp again 		;������򷵻���ʼ����������

stop:   
	ret
ascToNum endp

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
CODES ENDS
    END START



