data segment
menu 	db	10,13,'*************************************************'
		db	10,13,'*            please choice action:              *'
	 	db	10,13,'*            1.binary to hexadecimal            *'
	 	db	10,13,'*            2.binary to decimal                *'	 	
	 	db	10,13,'*            3.hexadecimal to binary            *'
	 	db	10,13,'*            4.hexadecimal to decimal           *'
	 	db	10,13,'*            5.decimal to binary                *'
	 	db	10,13,'*            6.decimal to hexadecimal           *'
		db	10,13,'*            0.exit                             *'
		db	10,13,'*************************************************',10,13,'$'
str2		db	10,13,'please input the binary string:',10,13, '$'
str21	db	'the hexadecimal string is:',10,13, '$'
str22	db	'the decimal string is:',10,13, '$'

str3		db	10,13,'please input the hexadecimal string:',10,13, '$'
str31	db	'the binary string is:',10,13, '$'
str32	db	'the decimal string is:',10,13, '$'

str4		db	10,13,'please input the decimal string:',10,13, '$'
str41	db	'the binary string is:',10,13, '$'
str42	db	'the hexadecimal string is:',10,13, '$'
data	ends

code segment
	assume cs:code,ds:data

charin macro					
		mov ah,01h				
		int 21h					
endm

numin macro
		charin
		sub al,48
endm

strin macro stringin			
		lea dx,stringin		
		mov ah,0ah				
		int 21h					
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
start:	
		mov ax,data			
		mov ds,ax				
display:		
		strout menu				
		charin					
		cmp al,'1'
		je bin_hex
		cmp al,'2'
		je bin_dec
		cmp al,'3'
		je hex_bin
		cmp al,'4'
		je hex_dec
		cmp al,'5'
		je dec_bin
		cmp al,'6'
		je dec_hex
		cmp al,'0'
		je exit
		jmp	display
bin_hex:	
		strout str2
		inax 2				
		endl
		strout str21
		outax 16				
		jmp display	
bin_dec:
		strout str2
		inax 2
		endl
		strout str22
		outax 10
		jmp display
hex_bin:	
		strout str3
		inax 16				
		endl
		strout str31
		outax 2				
		jmp display		
hex_dec:	
		strout str3
		inax 16				
		endl
		strout str32
		outax 10				
		jmp	display	
dec_bin:
		strout str4
		inax 10
		endl
		strout str41
		outax 2
		jmp display
dec_hex:
		strout str4
		inax 10
		endl
		strout str42
		outax 16
		jmp display
exit:	
		mov ah,4ch				
		int 21h	
code ends
	end start

