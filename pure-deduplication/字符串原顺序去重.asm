enterline macro		  ;回车换行
	mov dl,13
	mov ah,2
	int 21h
	mov dl,10
	mov ah,2
	int 21h
endm


DATAS SEGMENT
    BUFF db 21           ;回车也要占1个
    	 db ?
         db 21 dup(?)
         
    flag db 0
    
    MSG1 db 'Input the string: $'
    MSG2 db 'After eliminating the numerical string: $'
    
DATAS ENDS



STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS


CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    lea dx,MSG1             ;输入提示
    mov ah,9
    int 21h
    
    lea dx,BUFF             ;输入字符串
    mov ah,0Ah
    int 21h
    
    enterline
    
    lea si,BUFF+2           ;打印第一个字符
    mov dl,[si]
    mov dh,0               
	mov ah,2
	int 21h
      
    mov bx,1                ;用bx来计数
    mov dl,BUFF+1
    mov dh,0
    dec dx                  ;由于是从第二个数开始检测，因此要dx减1
    
    lea si,BUFF+2
    mov di,si
    
    inc si                  ;从第二个数开始检测,si要加1
    mov cx,dx
s1:  
	push cx
	mov al,[si]             ;只取一个用al,al是正在检测的数
	mov ah,0
	
	mov cx,bx
s2:
	push cx

	mov dl,[di]
	mov dh,0
	cmp ax,dx               ;判断是否相等
	jne continueCheck
	cmp ax,dx
	je notPrint
	
continueCheck:	
	inc di
	pop cx
	jmp continueCheck2

notPrint:                   ;注意在loop里跳出后是否有pop cx
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

