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
	A dw 10 dup(?)     ;��ĿҪ����ٸ����־����뼸���ʺ�!!!!!!!!!!!!!!!!!!
	point db '.$'
	flag db 0

    ;�˴��������ݶδ���  
DATAS ENDS



STACKS SEGMENT stack
    dw 256 dup(?)
STACKS ENDS




CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    ascnum err,num,A    ;����,���ո�ֿ������������A��
                        ;�˴���ӡ   
    mov cx,10           ;!!!!!!!!!!!!!!!!!!!!!!�ĳ�n
    lea si,A            ;��ѭ��ǰ��ȡ��ַ
print:
	mov dx,[si]             
	call num_ascii
	add si,2
	
	mov dl,' '
    mov ah,2
	int 21h
	
	loop print
	
	enterline
	
;----------------------------------ð�����������ݶ�A�
Begin:   
	mov bx,0                ;bx��i  
    mov al,10                ;��6������ð������!!!!!!!!!!!!!!!!!!!!!!!!!
    mov ah,0
    dec ax                  ;i<len-1���ѭ������
    mov cx,ax
s1: push cx                 ;ѹջ����, s1�ǳ�ʼ���ڲ�ѭ��
 
 	mov al,10                ;����������ð������������Ҫ�ģ�!!!!!!!!!!!!!!!!!!
 	mov ah,0
 	dec ax                  
 	sub ax,bx               ;j<len-1-i
 	
 	push bx                 ;�ڲ�bx��Ϊj��ѹջ
 	
 	lea si,A        
 	mov bx,0                ;j��0��ʼ
	mov cx,ax
s2:
	push cx	                ;ð�����򽻻�����
	mov ax,[si+bx]
	mov dx,[si+bx+2]
	cmp	ax,dx
	jb change               ;������ֻ�������,Ŀǰ�ǽ���
	cmp ax,dx
	ja notchange            ;������ֻ�������,Ŀǰ�ǽ���

notchange:
	add bx,2                ;������dw���Ҫ+2
	jmp GO
	
change:        
	mov [si+bx+2],ax        ;��������
	mov [si+bx],dx
	add bx,2                  

GO:
	pop cx
    loop s2
    pop bx
    inc bx                  ;��Ӧi+2
    pop cx
    loop s1


	mov cx,10           ;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    lea si,A            ;��ѭ��ǰ��ȡ��ַ
print1:
	mov dx,[si]             
	call num_ascii
	add si,2
	
	mov dl,' '
    mov ah,2
	int 21h
	
	loop print1
;----------------------------------ð���������	
	enterline
;------------------------------------------����ð�������������Сֵ
    
    lea si,A
    mov dx,[si]         	 ;���ֵ�ǵ�һ��,������dw
    call num_ascii  
    
    mov dl,' '               ;��ӡ�ո�
    mov ah,2
	int 21h
    
    lea si,A
    mov bl,20                ;��Сֵ�����һ��,��ֵΪ2n!!!!!!!!!!!!!!!!!!
    mov bh,0
    sub bx,2                 ;�˴�����
    mov dx,[si+bx]
    call num_ascii	
    
;-------------------------------------------------------��ƽ������������λС��
	enterline
	
	enterline
 
  	push ax
  	
  	lea si,A
  	mov ax,0
	mov cx,10               ;!!!!!!!!!!!!!!!!!!!!!
average:
	add ax,[si]             ;ax��n����!!!!!!!!!!!!!
	add si,2
	loop average
  	
  	
  	
    ;mov ax,A
    ;add ax,A+2
    ;add ax,A+4
    ;add ax,A+6
    ;add ax,A+8
    ;add ax,A+10
    ;add ax,A+12
    ;add ax,A+14
    ;add ax,A+16
    ;add ax,A+18
 
 	push cx
 	mov cx,10                ;ȨֵΪ10
 	xor dx,dx                ;���dx���⣨dx|ax)/bx����diverror
 	mov bx,10               ;!!!!!!!!!!!!!!!!��Ϊn
 	div bx   
 	push dx                ;bx�б�������
 
 	mov dx,ax
 	call num_ascii
 
 	lea dx,point            ;���'.'
    mov ah,9
    int 21h
;----------------------------------------------��һλ��������
    pop dx
    mov ax,dx           ;dx�б�������
    mul cx
    div bx
    push dx
    mov dx,ax
 	call num_ascii          ;���С������һλ��
;-------------------------------------------------------------
 
 	pop dx
 	mov ax,dx
 	mul cx
 	div bx
 	cmp dx,5              ;�ĳɳ�����һ��!!!!!!!!!!!!!!!!!!1
    jae plus
    jmp noplus
plus:                     ;�н�λ���
 	inc ax
 	mov dx,ax
 	call num_ascii        ;���С�����ڶ�λ��
 	enterline
 	jmp next
 
noplus:                   ;�޽�λ���
 	mov dx,ax
 	call num_ascii        ;���С�����ڶ�λ��
 	enterline
    jmp next
 
next: 
 	pop cx
 	pop ax
	
	
	
;------------------------------------------------------------------	
    

;-------------------------------------------------------���ո�ȥ��
	enterline

	lea si,A                ;��ӡ��һ���ַ�
    mov dx,[si]              
	call num_ascii
	
	mov dl,' '              ;��ӡ�ո�
    mov ah,2
	int 21h
      
    mov bx,1                ;��bx������
    mov dl,10                ;!!!!!!!!!!!!!!!��Ϊn
    mov dh,0
    dec dx                  ;�����Ǵӵڶ�������ʼ��⣬���Ҫdx��1
    
    lea si,A
    mov di,si
    
    add si,2                ;�ӵڶ�������ʼ���,siҪ��2
    mov cx,dx
p1:  
	push cx
	mov ax,[si]             ;ax�����ڼ�����
	
	mov cx,bx
p2:
	push cx

	mov dx,[di]
	cmp ax,dx               ;�ж��Ƿ����
	jne continueCheck
	cmp ax,dx
	je notPrint
	
continueCheck:	
	add di,2
	pop cx
	jmp continueCheck2

notPrint:                   ;ע����loop���������Ƿ���pop cx
	pop cx
	jmp nextCheck

continueCheck2:	
	loop p2

print2:
	push ax
	push dx
	
	mov dx,ax
	call num_ascii
	
	mov dl,' '               ;��ӡ�ո�
    mov ah,2
	int 21h
	
	pop dx
	pop ax 
	
nextCheck:	
	lea di,A
	inc bx 	
	
	pop cx
	add si,2
	loop p1


	MOV AH,4CH
    INT 21H



;-------------------------------------------------------	
    
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


