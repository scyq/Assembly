enterline macro		;定义回车换行的宏指令
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
ascnum macro err,buf,result          ;带空格宏定义
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
    
    
    
hhh:mov al,[si]		;取出个位数给al
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
   
output:   	mov ax,di		;将最终转换结果从di中放置到ax
   	
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

;--------------------------------------------宏定义结束




DATAS SEGMENT
    num db 50
		db ?
		db 50 dup(?)  ;缓冲区
	
	err db 'ERROR$'
	A dw 6 dup(?)     ;题目要求多少个数字就输入几个问号
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
    
    lea dx,MSG1             ;输入提示
    mov ah,9
    int 21h
    
    ascnum err,num,A    ;输入,带空格分开的数据最后在A里
    
    mov dx,0
	mov ax,6                ;6根据实际情况改数值
	mov dx,0
	lea si,A
	mov cx,ax
	
average:
	push cx
	add dx,[si]             ;dx是6个和
	add si,2
	pop cx
	loop average
	
	call num_ascii
	enterline
	
	mov ax,dx               ;ax是6个和
	mov bl,6
	mov bh,0
	div bl ;al:shang ah:yu
	
	mov dl,al               ;打印商
	mov dh,0               
	call num_ascii
	
	push ax
	push dx
	
	lea dx,point            ;打印小数点
    mov ah,9
    int 21h 
    
    pop dx
    pop ax
	
	mov bl,10               ;余数乘10
	mov cl,ah
	mov ch,0
	mov ax,cx
	mul bl;resut in ax
	
	mov bx,6
	div bl					;al:shang ah:yu
	
	mov dl,al               ;打印第一位小数
	mov dh,0
	call num_ascii
	
	mov bl,10
	mov cl,ah
	mov ch,0
	mov ax,cx
	mul bl
	
	mov bx,6
	div bl;al:shang ah:yu
	
	mov dl,al               ;打印第二位小数
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
    
;均在标号后面加了N
num_ascii:
	push cx
	push ax
	push bx
	push di
	push si
	push dx
	mov ax,dx            ;(有效数值为0~65535)  待转换数放置于AX寄存器中
    
    mov bx,10000		 ;初始数位权值为10000
    
covN:xor dx,dx			 ;将dx:ax中的数值除以权值
	div bx
	mov cx,dx			 ;余数备份到CX寄存器中
	
	cmp flag,0			 ;检测是否曾遇到非0商值
	jne nor1N			 ;如遇到过，则不管商是否为0都输出显示
	cmp ax,0			 ;如未遇到过，则检测商是否为0
	je contN		     ;为0则不输出显示
	
nor1N:
	mov dl,al			 ;将商转换为ascii码输出显示
	add dl,30h
	mov ah,2
	int 21h
	
	mov flag,1			 ;曾遇到非0商，则将标志置1
	
contN:
	cmp bx,10			 ;检测权值是否已经修改到十位了
	je outerN			 ;如果相等，则完成最后的个位数输出显示
	
	xor dx,dx			 ;将数位权值除以10
	mov ax,bx
	mov bx,10
    div bx
    mov bx,ax
    
    mov ax,cx			 ;将备份的余数送入AX
    jmp covN    			 ;继续循环
   
outerN:
	mov dl,cl			 ;最后的个位数变为ascii码输出显示
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











