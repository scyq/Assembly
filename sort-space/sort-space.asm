enterline macro		;定义回车换行的宏指令
	mov dl,13
	mov ah,2
	int 21h
	mov dl,10
	mov ah,2
	int 21h
endm
;----------------------------------------------------------------------------------

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
;-------------------------------------------------------------------------

;实现冒泡排序，并将排序后的数输出
DATAS SEGMENT
   A dw 10 dup(?);;;;;题目要求多少个数字就输入几个问号
   N=$-A 			;计算数字所占的字节数
   err db 'ERROR$'
   num db 50,?,20 dup(?)  ;因为num是20位的，所以连回车在内最多可以键入10个字符
DATAS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS
START:MOV AX,DATAS
      MOV DS,AX
      
      ascnum err,num,A  ;输入
      
      MOV SI,0		;SI遍历数字;前一个数的地址
      MOV CX,N/2-1	;设置循环次数，M(M=N/2)个数需要，循环M-1次
      CALL BUBBLE	;调用BUBBLE将原来的数排序
	  ;输出排序后的数    
      MOV CX,N/2	;循环M次输出排序后的M个数
      MOV SI,0		;SI遍历排序后的数 
      MOV DI,0    	;用DI记录数字的位数
      MOV BP,N+5	;用于遍历存储的转化后的字符的位置
SHOW: PUSH CX		;循环次数入栈
      MOV DX,0		;由于将要进行16位除需要置高16位为0
	  MOV AX,[SI]   ;低16位为排序后的数
	  CALL DTOC		;调用DTOC将十进制数转换为字符串
	  CALL SHOW_STR ;调用SHOW_STR将一个数转化得到的字符串输出
	  ADD SI,2		;下一个数
	  POP CX		;循环次数出栈栈
	  LOOP SHOW   
            
    MOV AH,4CH
    INT 21H
    
BUBBLE PROC
L1:	PUSH CX			;将循环次数入栈
	LEA SI,A		;SI遍历DATAS数据段的数字
L2: MOV AX,A[SI]	;将前一个数存于AX
	CMP AX,A[SI+2]	;比较前后两个数
	JBE NEXT		;如果前一个数小于或等于后一个数则继续本轮的比较
	XCHG AX,A[SI+2]	;否则，交换前后两个数的位置
	MOV A[SI],AX
NEXT:ADD SI,2		;下一个数
	 LOOP L2		;注意内层循环的次数已经确定了
	 POP CX			;将循环次数出栈
	 LOOP L1		;下一轮比较
	 RET
BUBBLE ENDP
;将十进制数转换为字符串并储存起来
DTOC PROC
  S:MOV CX,10       ;将除数10，放入CX中   
    CALL DIVDW 		;调用DIVDW程序
    ADD CL,30H 		;把数字转换为ASCII码，这样就能显示了
    MOV DS:[BP],CL  ;把ASCII码放到内存中 
    INC DI			;用DI记录循环的次数
    PUSH AX    		;将低16位入栈
    ADD AX,DX  		;将高位与低位相加，接着判断是否已经除尽  
    JZ BACK   		;除尽后返回调用处 
    POP AX			;将低16位出栈
    DEC BP		    ;逆序存放转化后的字符，便于主程序调用SHOW_STR
    JMP S  
BACK:POP AX         ;为了得到正确的IP值，需要出栈一次
     RET 
DTOC ENDP

;子程序定义开始,功能是分离被除数的各个位的数字
;公式：X/N=int(H/N)*65536+[rem(H/N)*65536+L]/N   
DIVDW PROC
 	PUSH AX   		;低16位入栈
    MOV AX,DX   	;将高16位写入AX,
    MOV DX,0  		;将高16位置零
    DIV CX    		;将新的数除10,
    MOV BX,AX 		;将商int(H/N)转移到BX，默认余数rem(H/N)在DX
    POP AX    		;将低16位出栈，
    DIV CX          ;将[rem(H/N)*65536+L]除10,默认余数在DX
    MOV CX,DX       ;将余数转移到CX
    MOV DX,BX       ;将商int(H/N)转移到dx,相当于int(H/N)*65536
    RET             ;子程序定义结束       
DIVDW ENDP
        
;实现字符串的输出        
SHOW_STR PROC
S2:MOV AH,2			;输出数字转化后的字符串
   MOV DL,DS:[BP]
   INT 21H
   INC BP			;顺序输出
   DEC DI			;数字的位数减一
   JZ OK			;字符串输出完了就结束
   JMP S2			;否则继续输出
OK:MOV AH,2		    ;输出空格
   MOV DL,0
   INT 21H
   RET		
SHOW_STR ENDP    
         
CODES ENDS
    END START














