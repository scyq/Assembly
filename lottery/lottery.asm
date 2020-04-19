DATAS SEGMENT
     hint db 'The Lucky Number is: $'
     flag db 0 							;the flag of proc
     
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    
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
    ;待转换数放置于AX寄存器中     
    mov bx,10000		;初始数位权值为10000
    
cov:xor dx,dx			;将dx:ax中的数值除以权值
	div bx
	mov cx,dx			;余数备份到CX寄存器中
	
	cmp flag,0			;检测是否曾遇到非0商值
	jne nor1			;如遇到过，则不管商是否为0都输出显示
	cmp ax,0			;如未遇到过，则检测商是否为0
	je cont				;为0则不输出显示
	
nor1:
	mov dl,al			;将商转换为ascii码输出显示
	add dl,30h
	mov ah,2
	int 21h
	
	mov flag,1			;曾遇到非0商，则将标志置1
	
cont:
	cmp bx,10			;检测权值是否已经修改到十位了
	je outer			;如果相等，则完成最后的个位数输出显示
	
	xor dx,dx			;将数位权值除以10
	mov ax,bx
	mov bx,10
    div bx
    mov bx,ax
    
    mov ax,cx			;将备份的余数送入AX
    jmp cov    			;继续循环
   
outer:
	mov dl,cl			;最后的个位数变为ascii码输出显示
	add dl,30h
	mov ah,2
	int 21h  

space:					;输出一个空格
	mov ax,32 			;空格
	mov dl,al
	mov ah,2
	int 21h
	mov flag,0			;还原，这样输出不会有前导0
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




