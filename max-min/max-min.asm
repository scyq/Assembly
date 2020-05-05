enterline macro		;����س����еĺ�ָ��
	mov dl,13
	mov ah,2
	int 21h
	mov dl,10
	mov ah,2
	int 21h
endm

ascnum macro err,buf,result
	LOCAL star,cov,error,stop,output,hhh
	push ax
	push bx
	push cx
	push dx	
	push si
	push di
star: 
    lea dx,buf		;�Ӽ��̽���������ֵ����buf������
    mov ah,10
    int 21h
    
    enterline		;�س�����
    mov cl,buf+1	;��ȡʵ�ʼ����ַ���������CX�Ĵ�����
    xor ch,ch
    
    lea si,buf+2	;��siָ����յ��ĵ�1���ַ�λ��
    add si,cx		;��Ϊ�Ӹ�λ�������Խ�siָ�����1�����յ��ĸ�λ��
    dec si          ;���һ��������ַ��ǻس�����ǰ�ƶ�1λ
    mov bp,0
    
cov: xor di,di		;�ۼ�����0
    
    xor dx,dx		;DX�Ĵ�����0
    
    mov bx,1		;���ڴӸ�λ����ʼ�������������Ȩֵ��Ϊ1
    
    
    
hhh:
	mov al,[si]		;ȡ����λ����al
	cmp al,20h      ;�ж��ǲ��ǿո�
	jz output       ;����ǿո��
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
    mov bx,ax
    
    dec si			;siָ���1��ָ��ǰһ��λ
    
    lea cx,buf+2    ;cx�����λ�ĵ�ַ
    cmp si,cx
    jae hhh         ;��si���ڻ����cxʱ��ת�ص�hhh
    ;jmp hhh    	;��CX�е��ַ���������ѭ��
   
output:   	
	mov ax,di		;������ת�������di�з��õ�ax
   	
   	mov result[bp],ax       ;bp�൱����ƫ����
   	add bp,2
   	dec si
   	lea cx,buf+2
    cmp si,cx      ;�ж����ǲ��Ǽ�⵽�����������λ
    jb stop        ;jb�����ڻ򲻸��ڡ�����Ѿ������λ�������
    jmp cov        ;����ͽ��Ĵ����ۼ���Ȩֵ����� ���´�����һ������

error:				;����������ʾ
	lea dx,err
    mov ah,9
    int 21h
    enterline 
    
    jmp star 		;������򷵻���ʼ����������  
        
stop:
   pop di
   pop si
   pop dx
   pop cx
   pop bx
   pop ax
   
endm

DATAS SEGMENT
    buf db 50,?,50 dup(?)
    numbers dw 10 dup(?)	; �м��������Ǽ�
    err db 'wrong$'
    flag db 0
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
    
    ascnum err,buf,numbers
    
    mov cx,9			; bubble sort times  (n-1)
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

; ��ʱ�Ѿ�������ɣ�numbers���ŵ�������õ���

	xor si,si
	mov cx,10				; �ж��ٸ�����cx���Ǽ�
	
	; ѭ�����
f:			
	mov ax,numbers[si]
	push cx
	call numToAsc
	pop cx
	add si,2
	loop f	
	
	enterline
	
	xor si,si				; si ƫ����Ϊ0
	mov ax,numbers[si]
	call numToAsc
	
	enterline
	
	xor si,si				; si ƫ������Ϊ 2 * (n-1)
	mov si,18				; 2 * (10 - 1)
	mov ax,numbers[si]
	call numToAsc
    
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
CODES ENDS
    END START