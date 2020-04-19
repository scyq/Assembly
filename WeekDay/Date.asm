enterline macro
	mov dl,10
	mov ah,02
	int 21h
endm

DATAS SEGMENT
    hintY db 'Please enter the Year:(1583 ~ 9999)$'
    hintM db 'Please enter the Month:$'
    hintD db 'Please enter the Day:$'
    err db 'Date does not exist!$'
    wrong db 'Wrong Input Syntax!$'
    Monday db 'It is Monday.$'
    Tuesday db 'It is Tuesday.$'
    Wednesday db 'It is Wednesday.$'
    Thursday db 'It is Thursday.$'
    Friday db 'It is Friday.$'
    Saturday db 'It is Saturday.$'
    Sunday db 'It is Sunday.$'
    flag db 0
    buf db 10,?,10 dup(0)
    year dw 0
    month dw 0
    day dw 0
    ans dw 0
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
	mov ah,2		; set position
	mov bh,0		; page 0
	mov dh,0		; line 0
	mov dl,0		; column 0
    int 10h
    
    lea dx,hintY	
    mov ah,09
    int 21h
    
    enterline
    
inyear:
    call ascToNum
    cmp ax,9999
    ja wrongyear
    cmp ax,1583
    jb wrongyear
    jmp rightyear
wrongyear:
	lea dx,wrong
	mov ah,09
	int 21h
	enterline
	jmp inyear
	
rightyear:
	lea di,year
	mov [di],ax
    call leapYear
    enterline
    
    lea dx,hintM
    mov ah,09
    int 21h
    
    enterline
    
    call ascToNum
    call checkMonth
    
    enterline
    
    lea dx,hintD
    mov ah,09
    int 21h
    
    enterline
    
    call ascToNum
    call checkDay
    
    enterline
    
    call cal
    
    lea di,ans
    mov ax,[di]
    cmp ax,0
    je sun
    cmp ax,1
    je mon
    cmp ax,2
    je tue
    cmp ax,3
    je wed
    cmp ax,4
    je thur
    cmp ax,5
    je fri
    cmp ax,6
    je sat

sun:
	lea dx,Sunday
	mov ah,09
	int 21h
	enterline
	jmp exit
	
mon:
	lea dx,Monday
	mov ah,09
	int 21h
	enterline
	jmp exit
	
tue:
	lea dx,Tuesday
	mov ah,09
	int 21h
	enterline
	jmp exit
	
wed:
	lea dx,Wednesday
	mov ah,09
	int 21h
	enterline
	jmp exit
	
thur:
	lea dx,Thursday
	mov ah,09
	int 21h
	enterline
	jmp exit

fri:
	lea dx,Friday
	mov ah,09
	int 21h
	enterline
	jmp exit
	
sat:
	lea dx,Saturday
	mov ah,09
	int 21h
	enterline
	jmp exit
    
exit:
    MOV AH,4CH
    INT 21H
    
; judege whether it is leap year
; ax saves the year
leapYear proc			
	mov bx,ax		; bx saves the year
	lea di,year
	mov [di],bx		; save the data

; y % 4 == 0 && y % 100 != 0
first:				
	xor dx,dx		; result is to big
	mov cx,4
	div cx
	;remainder in dx
	cmp dx,0
	jne second		; y % 4 != 0 -> second condition
	mov ax,bx
	xor dx,dx
	mov cx,100
	div cx			
	cmp dx,0		
	je	second		; y % 100 == 0 -> second yes
	jne yes

; year % 400==0 && year % 3200 != 0
second:
	xor dx,dx		; prepare for division
	mov ax,bx		; dx(0000) || ax 
	mov cx,400		
	div cx
	;remainder in dx
	cmp dx,0
	jne no			; year % 400 != -> not leap year
	xor dx,dx
	mov ax,bx
	mov cx,3200
	div cx
	cmp dx,0
	je 	no			; year % 400 == 0 -> not leap year
	jne yes
	
yes:
	mov flag,1
	jmp e
no:
	mov flag,0
	jmp e

e:
	ret
leapYear endp	

ascToNum proc	
again:
	lea dx,buf		;从键盘接收输入数值放入buf缓冲区
    mov ah,10
    int 21h
    
    mov cl,buf+1	;获取实际键入字符数，置于CX寄存器中
    xor ch,ch
    
    xor di,di		;累加器清0
    
    xor dx,dx		;DX寄存器清0
    
    mov bx,1		;由于从个位数开始算起，因而将所乘权值设为1
    
    lea si,buf+2	;将si指向接收到的第1个字符位置
    add si,cx		;因为从个位算起，所以将si指向最后1个接收到的个位数
    dec si
    
cov:
	mov al,[si]		;取出个位数给al
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
    cmp dx,0		;判断结果是否超出16位数范围，如超出则报错
    jne error1 
    mov bx,ax
    
    dec si			;si指针减1，指向前一数位
    loop cov    	;按CX中的字符个数计数循环
   
suc:
	mov ax,di		;将最终转换结果从di中放置到ax中
	jmp stop

error1:
	cmp cx,1
	jbe suc
	
error:				;给出错误提示
	lea dx,wrong
    mov ah,9
    int 21h
    
    enterline 
    
    jmp again 		;如出错则返回起始点重新输入

stop:   
	ret
ascToNum endp

; check whether month is right or not
checkMonth proc

cM:
	; ax saves the month
	cmp ax,1
	jb bad
	cmp ax,12
	ja bad
	jmp good
	
bad:
	lea dx,err
	mov ah,09
	int 21h
	enterline
	
	call ascToNum	; proc will return to here
	jmp cM			; check again

good:
	lea di,month
	mov [di],ax		; save the data
	ret
checkMonth endp

checkDay proc
cD:
	; ax saves the day
	cmp ax,1		; no less than 1
	jb nono
	
	lea di,month
	mov bx,[di]
	cmp bx,1
	je Jan
	cmp bx,2
	je Feb
	cmp bx,3
	je Mar
	cmp bx,4
	je Apr
	cmp bx,5
	je May
	cmp bx,6
	je Jun
	cmp bx,7
	je July
	cmp bx,8
	je Aug
	cmp bx,9
	je Sep
	cmp bx,10
	je Oct
	cmp bx,11
	je Nov
	cmp bx,12
	je Decem
	
Jan:
	cmp ax,31		; no more than 31
	ja nono
	jmp okok
Feb:
	lea di,flag		; judge leap year or not
	mov bx,[di]
	cmp bx,1
	je leap
	jne nleap
leap:
	cmp ax,29		; leap year no more than 29
	ja nono
	jmp okok
nleap:
	cmp ax,28
	ja nono
	jmp okok
Mar:
	cmp ax,31		; no more than 31
	ja nono
	jmp okok
Apr:
	cmp ax,30		; no more than 30
	ja nono
	jmp okok
May:
	cmp ax,31		; no more than 31
	ja nono
	jmp okok
Jun:
	cmp ax,30		; no more than 30
	ja nono
	jmp okok
July:
	cmp ax,31		; no more than 31
	ja nono
	jmp okok
Aug:
	cmp ax,31		; no more than 31
	ja nono
	jmp okok
Sep:
	cmp ax,30		; no more than 30
	ja nono
	jmp okok
Oct:
	cmp ax,31		; no more than 31
	ja nono
	jmp okok
Nov:
	cmp ax,30		; no more than 30
	ja nono
	jmp okok
Decem:
	cmp ax,31		; no more than 31
	ja nono
	jmp okok
nono:
	lea dx,err
	mov ah,09
	int 21h
	enterline
	
	call ascToNum	; proc will return to here
	jmp cD			; check again
	
okok:
	lea di,day
	mov [di],ax		; save the data
	ret
checkDay endp

cal proc
	; Kim Larsen Formula
	; (d+2*m+3*(m+1)/5+y+y/4-y/100+y/400-y/3200+1)%7
	; si temply saves the answer
	
	lea di,month
	mov ax,[di]
	cmp ax,1
	je spec
	cmp ax,2
	je spec
	jmp ncal

spec:
	add ax,12		; m += 12
	mov [di],ax
	lea di,year
	mov ax,[di]
	dec ax			; year --
	mov	[di],ax
	
ncal:	
	xor dx,dx
	mov si,0
	lea di,day
	add si,[di]		; d
	
	lea di,month
	mov bx,[di]		
	mov bh,0		; bl = month
	 
	xor ax,ax
	mov al,bl		; al = month
	mov dl,2
	mul dl			; m * 2, result in ax
	add si,ax		; d+2*m
	
	xor ax,ax
	mov al,bl		; al = month
	inc al
	mov dl,3
	mul dl			; 3 * ( m + 1 ), result in ax
	mov dl,5
	div dl			
	mov ah,0		; ax is the 3*(m+1)/5
	add si,ax		; d+2*m+3*(m+1)/5
	
	lea di,year
	mov bx,[di]
	
	add si,bx		; d+2*m+3*(m+1)/5+y
	
	xor dx,dx
	mov ax,bx		; ax = year
	mov cx,4
	div cx
	add si,ax		; d+2*m+3*(m+1)/5+y+y/4
	
	xor dx,dx
	mov ax,bx		; ax = year
	mov cx,100
	div cx
	sub si,ax		; d+2*m+3*(m+1)/5+y+y/4-y/100
	
	xor dx,dx
	mov ax,bx		; ax = year
	mov cx,400
	div cx
	add si,ax		; d+2*m+3*(m+1)/5+y+y/4-y/100+y/400
	
	xor dx,dx
	mov ax,bx		; ax = year
	mov cx,3200
	div cx
	sub si,ax		; d+2*m+3*(m+1)/5+y+y/4-y/100+y/400-y/3200
	
	inc si			; d+2*m+3*(m+1)/5+y+y/4-y/100+y/400-y/3200+1
	
	xor dx,dx
	mov ax,si
	mov cx,7		
	div cx			; remainder in dx
	lea di,ans
	mov [di],dx
	ret
cal endp
CODES ENDS
    END START



