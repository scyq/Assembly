enterline macro		  ;�س�����
	mov dl,13
	mov ah,2
	int 21h
	mov dl,10
	mov ah,2
	int 21h
endm


DATAS SEGMENT
    BUFF db 21           ;�س�ҲҪռ1��
    	 db ?
         db 21 dup(?)
         
    flag db 0
    
    MSG1 db 'Input the string: $'
    MSG2 db 'After eliminating the numerical string: $'
    
DATAS ENDS



STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS


CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    lea dx,MSG1             ;������ʾ
    mov ah,9
    int 21h
    
    lea dx,BUFF             ;�����ַ���
    mov ah,0Ah
    int 21h
    
    enterline
    
    lea si,BUFF+2           ;��ӡ��һ���ַ�
    mov dl,[si]
    mov dh,0               
	mov ah,2
	int 21h
      
    mov bx,1                ;��bx������
    mov dl,BUFF+1
    mov dh,0
    dec dx                  ;�����Ǵӵڶ�������ʼ��⣬���Ҫdx��1
    
    lea si,BUFF+2
    mov di,si
    
    inc si                  ;�ӵڶ�������ʼ���,siҪ��1
    mov cx,dx
s1:  
	push cx
	mov al,[si]             ;ֻȡһ����al,al�����ڼ�����
	mov ah,0
	
	mov cx,bx
s2:
	push cx

	mov dl,[di]
	mov dh,0
	cmp ax,dx               ;�ж��Ƿ����
	jne continueCheck
	cmp ax,dx
	je notPrint
	
continueCheck:	
	inc di
	pop cx
	jmp continueCheck2

notPrint:                   ;ע����loop���������Ƿ���pop cx
	pop cx
	jmp nextCheck

continueCheck2:	
	loop s2

print:
	push ax
	push dx
	
	mov dl,al
	mov ah,2
	int 21h
	
	pop dx
	pop ax 
	
nextCheck:	
	lea di,BUFF+2
	inc bx 	
	
	pop cx
	inc si
	loop s1
    
    MOV AH,4CH
    INT 21H
    
CODES ENDS
    END START

