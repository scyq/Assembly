enterline macro		;定义回车换行的宏指令
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
    lea dx,buf		;从键盘接收输入数值放入buf缓冲区
    mov ah,10
    int 21h
    
    enterline		;回车换行
    mov cl,buf+1	;获取实际键入字符数，置于CX寄存器中
    xor ch,ch
    
    lea si,buf+2	;将si指向接收到的第1个字符位置
    add si,cx		;因为从个位算起，所以将si指向最后1个接收到的个位数
    dec si          ;最后一个键入的字符是回车，往前移动1位
    mov bp,0
    
cov: xor di,di		;累加器清0
    
    xor dx,dx		;DX寄存器清0
    
    mov bx,1		;由于从个位数开始算起，因而将所乘权值设为1
    
    
    
hhh:
	mov al,[si]		;取出个位数给al
	cmp al,20h      ;判断是不是空格
	jz output       ;如果是空格就
	cmp al,'0'		;边界检查：如果输入不是0-9的数字，就报错
	jb error
	cmp al,'9'
	ja error

	
	
    sub al,30h		;将al中的ascii码转为数字
    xor ah,ah
    mul bx			;乘以所处数位的权值
    cmp dx,0		;判断结果是否超出16位数范围，如超出则报错
    jne error
    
    add di,ax		;将形成的数值放在累加器di中
    
    
    jc error		;如数值超过16位数范围报错
    
        
    mov ax,bx		;将BX中的数位权值乘以10
    mov bx,10
    mul bx
    mov bx,ax
    
    dec si			;si指针减1，指向前一数位
    
    lea cx,buf+2    ;cx是最高位的地址
    cmp si,cx
    jae hhh         ;当si高于或等于cx时跳转回到hhh
    ;jmp hhh    	;按CX中的字符个数计数循环
   
output:   	
	mov ax,di		;将最终转换结果从di中放置到ax
   	
   	mov result[bp],ax       ;bp相当于是偏移量
   	add bp,2
   	dec si
   	lea cx,buf+2
    cmp si,cx      ;判断是是不是检测到输入数的最高位
    jb stop        ;jb：低于或不高于。如果已经到最高位，就输出
    jmp cov        ;否则就将寄存器累加器权值都清空 重新存贮下一个数字

error:				;给出错误提示
	lea dx,err
    mov ah,9
    int 21h
    enterline 
    
    jmp star 		;如出错则返回起始点重新输入  
        
stop:
   pop di
   pop si
   pop dx
   pop cx
   pop bx
   pop ax
   
endm

DATAS SEGMENT
    err db 'wrong input$'
    allNumbers dw 6 dup(?)
    buffer db 50,?,50 dup(?) 
    flag db 0
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
    ascnum err,buffer,allNumbers
    
    enterline
enterline

	lea si,allNumbers       ;打印第一个字符
    mov ax,[si]              
	call numToAsc
      
    mov bx,1                ; 用bx来计数
    mov dl,6				; 有几个数，mov几
    mov dh,0
    dec dx                  ; 由于是从第二个数开始检测，因此要dx减1
    
    lea si,allNumbers
    mov di,si
    
    add si,2                ;从第二个数开始检测,si要加2
    mov cx,dx
p1:  
	push cx
	mov ax,[si]             ;ax是正在检测的数
	
	mov cx,bx
p2:
	push cx

	mov dx,[di]
	cmp ax,dx               ;判断是否相等
	jne continueCheck
	cmp ax,dx
	je notPrint
	
continueCheck:	
	add di,2
	pop cx
	jmp continueCheck2

notPrint:                   ;注意在loop里跳出后是否有pop cx
	pop cx
	jmp nextCheck

continueCheck2:	
	loop p2

print2:
	push ax
	push bx
	push cx
	push dx
	
	call numToAsc
	
	pop dx
	pop cx
	pop bx
	pop ax 
	
nextCheck:	
	lea di,allNumbers
	inc bx 	
	
	pop cx
	add si,2
	loop p1
    
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
CODES ENDS
    END START

