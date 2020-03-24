DATAS SEGMENT
    FLAG DB 0			;num转asc的标识
    HINT DB 'Ten natural number with different difference:$' ;提示
DATAS ENDS

STACKS SEGMENT

STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
	
	LEA DX,HINT ;给出提示
	MOV AH,09
	INT 21H
	MOV DX,10	;换行
	MOV AH,02
	INT 21H
	
	
	MOV AX,0	
	CALL NUM	;输出
	MOV AX,1
	MOV CX,8	;循环次数
	PUSH AX		;压栈保护
	PUSH CX
	CALL NUM
	POP CX
	POP AX
	
MAIN:
	ADD AX,AX	;加上到0，是目前的最大差值
	INC AX		;再加1，这个差不可能出现过
	PUSH AX
	PUSH CX
	CALL NUM
	POP CX
	POP AX
LOOP MAIN
   
EXIT: ;程序出口
    MOV AH,4CH
    INT 21H
    
; Num转ASC码子程序
NUM:         
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
	MOV FLAG,0			;还原，这样输出不会有前导0
RET

CODES ENDS
    END START




