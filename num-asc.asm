enterline macro		;定义回车换行的宏指令
	mov dl,13
	mov ah,2
	int 21h
	mov dl,10
	mov ah,2
	int 21h
	
endm

DATAS SEGMENT
    ;此处输入数据段代码 
    output db 'AX Register Content is:$' 
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
    
begin: 
   	lea dx,output		;给出输出提示
    mov ah,9
    int 21h
    
    enterline			;回车换行
    
    mov ax,1234;(有效数值为0~65535)  待转换数放置于AX寄存器中
    
     
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
	enterline
	
stop:    
	MOV AH,4CH
    INT 21H
CODES ENDS
    END START




