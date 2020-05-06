DATAS SEGMENT
	str2	db	10,13,'please input the binary string:',10,13, '$'
	str21	db	'the hexadecimal string is:',10,13, '$'
DATAS ENDS

STACKS SEGMENT para stack
    dw 100h dup(0)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
    charin macro					
		mov ah,01h				
		int 21h					
endm

numin macro
		charin
		sub al,48
endm

charout	macro outchar			
		push ax
		push dx
		mov dl, outchar
		mov ah, 02h				
		int 21h					
		pop dx
		pop ax
endm
numout	macro outnum
		push ax
		push dx
		mov dl, outnum
		add dl, 48				
		mov ah, 02h				
		int 21h					
		pop dx
		pop ax
endm

strout	macro stringout			
		push ax
		push dx
		lea dx, stringout		
		mov ah, 9				
		int 21h					
		pop	dx
		pop	ax
endm

endl  macro					
		push ax
		push bx
		push cx
		push dx
		
		mov dl, 0ah				
		mov ah, 2
		int 21h					
		mov dl, 0dh				
		int 21h					
		
		pop dx
		pop cx
		pop bx
		pop ax
endm


outax	macro	basenum			
		push ax
		push bx
		push cx
		push dx
		
		mov bx, basenum			
		call outaxp				
		
		pop dx
		pop cx
		pop bx
		pop ax
endm
outaxp	proc
		mov dx,0				
		mov cx,0			
outaxp_circle:
		cmp ax,0				
		je outaxp_next			
		div bx					
		push dx					
		mov dx,0				
		inc cx					
		jmp outaxp_circle	
outaxp_next:					
		pop ax
		cmp al,10						
	jb 	nout
		add al,55				
		charout al
		jmp cout
		
nout:	
	numout al
cout:	
	loop outaxp_next
	ret	
outaxp	endp


inax macro basenum			
		push bx
		push cx
		push dx
		
		mov cx, basenum			
		call inaxp						
		pop dx
		pop cx
		pop bx
endm
inaxp	proc
		mov	ax,	0
inaxp0:	
		push ax
inaxp1:	charin					
		cmp al, 13
		je	inaxe				
		cmp al, '0'
		jb	inaxp1			
		cmp al, '9'	
		ja	inaxnext1			
		sub	al, 48				
		jmp inaxnum				
inaxnext1:	
		cmp al, 'A'
		jb	inaxp1				
		cmp al, 'F'
		ja	inaxnext2			
		sub	al, 55				
		jmp inaxnum
inaxnext2:
		cmp al, 'a'
		jb	inaxp1				
		cmp al, 'z'
		ja	inaxp1				
		sub	al, 87					
		jmp inaxnum
inaxnum:
		mov bh, 0				
		mov bl, al
		pop	ax
		
		cmp ax, 0						
	je	inaxadd
		mul cx					
inaxadd:
		add ax, bx
		jmp inaxp0	
inaxe:	
	pop	ax						
	ret	
inaxp endp
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    
;bin_hex:	
	strout str2
	inax 2				
	endl
	strout str21
	outax 16					
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START





