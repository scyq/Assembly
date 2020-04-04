DATAS SEGMENT
    flag db 0 			;flag of numToAsc procedure		
    prime db 0			;flag of prime judge
    judgeNumber db 1	;the number waits to be judged, ++first so start from 1
    sum dw 0			;the sum of prime
    count db 0			;the counts
    startHint db 'The prime number below 100 are:$'
    sumHint db 'The sum of them is:$'
    countHint db 'The count of them is:$'
DATAS ENDS

STACKS SEGMENT
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
   	lea dx,startHint
   	mov ah,09
   	int 21h
   	
   	   	
main:
	mov dl,10
   	mov ah,02				;enter a line
   	int 21h
	mov cx,10				;a line contains 10 number
line:				
	mov bl,judgeNumber		;judgeNumber++
	inc bl
	cmp bl,100				;compare judgeNumber to 100
	jae endloop
	mov judgeNumber,bl
	cmp bl,2
	je output
	call primeJudge		
	mov bl,prime
	cmp bl,1			
	jne line				;if not a prime
	
output:
	; if it is prime
	mov al,judgeNumber
	mov ah,0				;ax = judgeNumber
	mov bx,sum
	add bx,ax				;low ++
	mov sum,bx	
	xor bx,bx
	mov bl,count			
	inc bl
	mov count,bl			;count++
	push cx
	call numToAsc
	call pause				;pause
	pop cx
	
loop line
	jmp main				;a line end


endloop:
	
	;if end
	mov dl,10
   	mov ah,02				;enter a line
   	int 21h
	
	lea dx,countHint		;output hint
   	mov ah,09
   	int 21h
   	
   	mov dl,10
   	mov ah,02				;enter a line
   	int 21h
   	
	xor ax,ax
	mov al,count
	call numToAsc
	
	mov dl,10
   	mov ah,02				;enter a line
   	int 21h
	
	lea dx,sumHint			;output sum
   	mov ah,09
   	int 21h
   	
   	mov dl,10
   	mov ah,02				;enter a line
   	int 21h
	
	xor ax,ax
	mov ax,sum
	call numToAsc
   
    
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
    
pause proc
	mov ah,86h			;bios pause function, unit is us
	;pause time saves dw in cx(high) and dx(low)
	mov cx,19h
	mov dx,9848h			;0x199848 I dont know how long
	int 15h
	ret
pause endp

primeJudge proc
	mov prime,0				;initialize
	mov al,ds:[2]			;ax = judgeNumber
	mov ah,0				;high is zero
	cmp al,3
	je yes					;3 is special
	mov dl,2				
	div dl					;if the number is even above 2 it's not
	cmp ah,0				;compare remainder to 0
	je no
	inc dl					;if it is odd then start from 3
	mov al,ds:[2]			;restart 
	mov ah,0
judge:
	div dl
	cmp ah,0				;compare remainder to 0
	je no
	mov al,ds:[2]			;restart
	mov ah,0
	inc dl					
	cmp dl,judgeNumber		;stop loop
	jb judge

yes:
	mov prime,1				;never jump to no
	jmp quit
	
no:
	mov prime,0				;it's not prime
	jmp quit
    
quit:
	ret
primeJudge endp
    
    
CODES ENDS
    END START
   





