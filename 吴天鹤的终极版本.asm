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
	A dw 10 dup(?)     ;题目要求多少个数字就输入几个问号!!!!!!!!!!!!!!!!!!
	point db '.$'
	flag db 0

    ;此处输入数据段代码  
DATAS ENDS



STACKS SEGMENT stack
    dw 256 dup(?)
STACKS ENDS




CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    ascnum err,num,A    ;输入,带空格分开的数据最后在A里
                        ;此处打印   
    mov cx,10           ;!!!!!!!!!!!!!!!!!!!!!!改成n
    lea si,A            ;在循环前面取地址
print:
	mov dx,[si]             
	call num_ascii
	add si,2
	
	mov dl,' '
    mov ah,2
	int 21h
	
	loop print
	
	enterline
	
;----------------------------------冒泡排序（在数据段A里）
Begin:   
	mov bx,0                ;bx是i  
    mov al,10                ;对6个进行冒泡排序!!!!!!!!!!!!!!!!!!!!!!!!!
    mov ah,0
    dec ax                  ;i<len-1外层循环次数
    mov cx,ax
s1: push cx                 ;压栈保护, s1是初始化内层循环
 
 	mov al,10                ;对六个进行冒泡排序（这里需要改）!!!!!!!!!!!!!!!!!!
 	mov ah,0
 	dec ax                  
 	sub ax,bx               ;j<len-1-i
 	
 	push bx                 ;内层bx作为j，压栈
 	
 	lea si,A        
 	mov bx,0                ;j从0开始
	mov cx,ax
s2:
	push cx	                ;冒泡排序交换过程
	mov ax,[si+bx]
	mov dx,[si+bx+2]
	cmp	ax,dx
	jb change               ;升序降序只需改这里,目前是降序
	cmp ax,dx
	ja notchange            ;升序降序只需改这里,目前是降序

notchange:
	add bx,2                ;由于是dw因此要+2
	jmp GO
	
change:        
	mov [si+bx+2],ax        ;交换过程
	mov [si+bx],dx
	add bx,2                  

GO:
	pop cx
    loop s2
    pop bx
    inc bx                  ;对应i+2
    pop cx
    loop s1


	mov cx,10           ;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    lea si,A            ;在循环前面取地址
print1:
	mov dx,[si]             
	call num_ascii
	add si,2
	
	mov dl,' '
    mov ah,2
	int 21h
	
	loop print1
;----------------------------------冒泡排序结束	
	enterline
;------------------------------------------利用冒泡排序找最大最小值
    
    lea si,A
    mov dx,[si]         	 ;最大值是第一个,由于是dw
    call num_ascii  
    
    mov dl,' '               ;打印空格
    mov ah,2
	int 21h
    
    lea si,A
    mov bl,20                ;最小值是最后一个,赋值为2n!!!!!!!!!!!!!!!!!!
    mov bh,0
    sub bx,2                 ;此处减二
    mov dx,[si+bx]
    call num_ascii	
    
;-------------------------------------------------------求平均数，保留两位小数
	enterline
	
	enterline
 
  	push ax
  	
  	lea si,A
  	mov ax,0
	mov cx,10               ;!!!!!!!!!!!!!!!!!!!!!
average:
	add ax,[si]             ;ax是n个和!!!!!!!!!!!!!
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
 	mov cx,10                ;权值为10
 	xor dx,dx                ;清空dx避免（dx|ax)/bx产生diverror
 	mov bx,10               ;!!!!!!!!!!!!!!!!改为n
 	div bx   
 	push dx                ;bx中保存余数
 
 	mov dx,ax
 	call num_ascii
 
 	lea dx,point            ;输出'.'
    mov ah,9
    int 21h
;----------------------------------------------多一位复制这里
    pop dx
    mov ax,dx           ;dx中保存余数
    mul cx
    div bx
    push dx
    mov dx,ax
 	call num_ascii          ;输出小数点后第一位数
;-------------------------------------------------------------
 
 	pop dx
 	mov ax,dx
 	mul cx
 	div bx
 	cmp dx,5              ;改成除数的一半!!!!!!!!!!!!!!!!!!1
    jae plus
    jmp noplus
plus:                     ;有进位输出
 	inc ax
 	mov dx,ax
 	call num_ascii        ;输出小数点后第二位数
 	enterline
 	jmp next
 
noplus:                   ;无进位输出
 	mov dx,ax
 	call num_ascii        ;输出小数点后第二位数
 	enterline
    jmp next
 
next: 
 	pop cx
 	pop ax
	
	
	
;------------------------------------------------------------------	
    

;-------------------------------------------------------带空格去重
	enterline

	lea si,A                ;打印第一个字符
    mov dx,[si]              
	call num_ascii
	
	mov dl,' '              ;打印空格
    mov ah,2
	int 21h
      
    mov bx,1                ;用bx来计数
    mov dl,10                ;!!!!!!!!!!!!!!!改为n
    mov dh,0
    dec dx                  ;由于是从第二个数开始检测，因此要dx减1
    
    lea si,A
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
	push dx
	
	mov dx,ax
	call num_ascii
	
	mov dl,' '               ;打印空格
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


