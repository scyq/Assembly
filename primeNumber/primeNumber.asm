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
    ;��ת����������AX�Ĵ�����     
    mov bx,10000		;��ʼ��λȨֵΪ10000
    
cov:xor dx,dx			;��dx:ax�е���ֵ����Ȩֵ
	div bx
	mov cx,dx			;�������ݵ�CX�Ĵ�����
	
	cmp flag,0			;����Ƿ���������0��ֵ
	jne nor1			;�����������򲻹����Ƿ�Ϊ0�������ʾ
	cmp ax,0			;��δ���������������Ƿ�Ϊ0
	je cont				;Ϊ0�������ʾ
	
nor1:
	mov dl,al			;����ת��Ϊascii�������ʾ
	add dl,30h
	mov ah,2
	int 21h
	
	mov flag,1			;��������0�̣��򽫱�־��1
	
cont:
	cmp bx,10			;���Ȩֵ�Ƿ��Ѿ��޸ĵ�ʮλ��
	je outer			;�����ȣ���������ĸ�λ�������ʾ
	
	xor dx,dx			;����λȨֵ����10
	mov ax,bx
	mov bx,10
    div bx
    mov bx,ax
    
    mov ax,cx			;�����ݵ���������AX
    jmp cov    			;����ѭ��
   
outer:
	mov dl,cl			;���ĸ�λ����Ϊascii�������ʾ
	add dl,30h
	mov ah,2
	int 21h  

space:					;���һ���ո�
	mov ax,32 			;�ո�
	mov dl,al
	mov ah,2
	int 21h
	mov flag,0			;��ԭ���������������ǰ��0
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
   





