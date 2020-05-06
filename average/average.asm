enterline macro		;����س����еĺ�ָ��
	push ax
	push dx
	mov dl,13
	mov ah,2
	int 21h
	mov dl,10
	mov ah,2
	int 21h
	pop dx
	pop ax
endm

;---------------------------------------------------------------------------
ascnum macro err,buf,result          ;���ո�궨��
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
    
    
    
hhh:mov al,[si]		;ȡ����λ����al
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
   
output:   	mov ax,di		;������ת�������di�з��õ�ax
   	
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

;--------------------------------------------�궨�����




DATAS SEGMENT
    num db 50
		db ?
		db 50 dup(?)  ;������
	
	err db 'ERROR$'
	A dw 6 dup(?)     ;��ĿҪ����ٸ����־����뼸���ʺ�
	point db '.$'
	flag db 0
	
	MSG1 db 'Input the string: $'
	
    

DATAS ENDS




STACKS SEGMENT stack
    dw 256 dup(?)
STACKS ENDS




CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    lea dx,MSG1             ;������ʾ
    mov ah,9
    int 21h
    
    ascnum err,num,A    ;����,���ո�ֿ������������A��
    
    mov dx,0
	mov ax,6                ;6����ʵ���������ֵ
	mov dx,0
	lea si,A
	mov cx,ax
	
average:
	push cx
	add dx,[si]             ;dx��6����
	add si,2
	pop cx
	loop average
	
	call num_ascii
	enterline
	
	mov ax,dx               ;ax��6����
	mov bl,6
	mov bh,0
	div bl ;al:shang ah:yu
	
	mov dl,al               ;��ӡ��
	mov dh,0               
	call num_ascii
	
	push ax
	push dx
	
	lea dx,point            ;��ӡС����
    mov ah,9
    int 21h 
    
    pop dx
    pop ax
	
	mov bl,10               ;������10
	mov cl,ah
	mov ch,0
	mov ax,cx
	mul bl;resut in ax
	
	mov bx,6
	div bl					;al:shang ah:yu
	
	mov dl,al               ;��ӡ��һλС��
	mov dh,0
	call num_ascii
	
	mov bl,10
	mov cl,ah
	mov ch,0
	mov ax,cx
	mul bl
	
	mov bx,6
	div bl;al:shang ah:yu
	
	mov dl,al               ;��ӡ�ڶ�λС��
	mov dh,0
	push dx;save second ?jiwei?
	
	mov bl,10				;third>5?
	mov cl,ah	
	mov ch,0
	mov ax,cx
	mul bl
	
	mov bx,6
	div bl					;al:shang ah:yu
	
	cmp al,5
	jae jw
	call num_ascii
	jmp stopp
jw: xor dx,dx
    pop dx
    inc dx
    call num_ascii
    
stopp:    
	MOV AH,4CH
    INT 21H
    
;���ڱ�ź������N
num_ascii:
	push cx
	push ax
	push bx
	push di
	push si
	push dx
	mov ax,dx            ;(��Ч��ֵΪ0~65535)  ��ת����������AX�Ĵ�����
    
    mov bx,10000		 ;��ʼ��λȨֵΪ10000
    
covN:xor dx,dx			 ;��dx:ax�е���ֵ����Ȩֵ
	div bx
	mov cx,dx			 ;�������ݵ�CX�Ĵ�����
	
	cmp flag,0			 ;����Ƿ���������0��ֵ
	jne nor1N			 ;�����������򲻹����Ƿ�Ϊ0�������ʾ
	cmp ax,0			 ;��δ���������������Ƿ�Ϊ0
	je contN		     ;Ϊ0�������ʾ
	
nor1N:
	mov dl,al			 ;����ת��Ϊascii�������ʾ
	add dl,30h
	mov ah,2
	int 21h
	
	mov flag,1			 ;��������0�̣��򽫱�־��1
	
contN:
	cmp bx,10			 ;���Ȩֵ�Ƿ��Ѿ��޸ĵ�ʮλ��
	je outerN			 ;�����ȣ���������ĸ�λ�������ʾ
	
	xor dx,dx			 ;����λȨֵ����10
	mov ax,bx
	mov bx,10
    div bx
    mov bx,ax
    
    mov ax,cx			 ;�����ݵ���������AX
    jmp covN    			 ;����ѭ��
   
outerN:
	mov dl,cl			 ;���ĸ�λ����Ϊascii�������ʾ
	add dl,30h
	mov ah,2
	int 21h
	;enterline
	mov flag,0 
	
	pop dx
	pop si
	pop di
	pop bx
	pop ax
	pop cx  
	ret     
    
    
    
    
    
    
    
    
CODES ENDS
    END START











