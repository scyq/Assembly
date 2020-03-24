DATAS SEGMENT
    MINUS DB 46 DUP(0)  ; 保存差值 排列组合 C 10 2 = 45
    ANS DB 10 DUP(0)   ; 保存答案
    FLAG DB 0			;num转asc的标识
    HINT DB 'Ten natural number with different difference:$' ;提示
    ZERO DB 0
DATAS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS
START:
    MOV AX,DATAS
    MOV DS,AX

	LEA DX,HINT ;给出提示
	MOV AH,09
	INT 21H
	MOV DX,10	;换行
	MOV AH,02
	INT 21H
	
    MOV SI,0	;差值数组下标
    MOV DI,46	;答案数组下标       
    MOV AX,0	;ANS[0] = 0
    MOV BX,1    ;存放当前的数字
    
    MOV [DI],AX
    JMP NUM

MAIN_LOOP:
	MOV DX,BX	;记忆当前的数字
	MOV AX,[DI]	;检索最新的可行数
	SUB BX,AX	;得到与最新可行数的差
	MOV AX,BX	;记忆当前的差

CHECK:
	CMP BX,[SI]	;比较当前差值和差值表中的值
	JE FAIL		;相等肯定不行	
	MOV CX,0	
	CMP CX,[SI] ;[SI]为0说明这个位置没有差
	JE SUCCESS	;这个数可以
	JNE PLUS	;不相等，说明有数，但是和BX不相等SI++
	
PLUS:			;增加SI
	INC SI
	JMP CHECK
	
SUCCESS:
	INC DI		;答案+1
	MOV [DI],DX	;记录答案
	MOV [SI],AX	;更新差值表  
	
	MOV	AX,0	;还原SI指针
	MOV SI,AX
	MOV BX,[DI] ;将BX更新为可行数
	MOV AX,BX	;将要输出的存在AX里
	INC BX		;可行数+1，作为下一次的起点
	JMP	NUM

FAIL:
	MOV BX,DX	;把原来那个数还回来
	INC BX		;+1
	MOV AX,0	;还原SI
	MOV SI,AX
	JMP MAIN_LOOP


; Num转ASC码
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
	
JUMPBACK:
	MOV FLAG,0			;还原
	CMP DI,55
	JB MAIN_LOOP
	JE EXIT
  
    
EXIT: ;程序出口
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START

