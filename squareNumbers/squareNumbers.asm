NUM MACRO
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
ENDM

;judge it is
JUDGE MACRO	
	;idiv quotient in AL, remainder in AH (dw operate)
	;number to judge is in BX			
	MOV DL,64H			;dec 100 = hex 64
	MOV AX,BX			;divident is in ax
	DIV DL				;ab in AL, cd in AH
	PUSH BX
	ADD AL,AH			;AL now saves ab + cd
	MOV AH,0			;AX now Saves ab + cd
	MUL AX				;square (ab + cd), result in ax
	POP BX				;BX is still the Number
	CMP AX,BX
	JE SUCCESS
	JNE ENDJ
SUCCESS:
	MOV AX,BX			;ready to output
	PUSH BX				;protect
	PUSH CX
	NUM				
	POP CX
	POP BX
	JMP ENDJ
	
ENDJ:
	INC BX				;BX++
	ENDM


DATAS SEGMENT
	HINT DB	'The answers that satisfy abcd = (ab+cd)^2 are:$'
	FLAG DB 0			;num转asc的标识
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    MOV BX,1000			;starter
    MOV CX,9000			;1000~9999
    
    LEA DX,HINT			;output hint
    MOV AH,09
    INT 21H
    
    MOV DL,10			;enter a line
    MOV AH,02			
   	INT 21H				

MAIN:
	JUDGE			
LOOP MAIN		
    
    
EXIT:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START




