enterline macro		;����س����еĺ�ָ��
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
    lea dx,buf		;�Ӽ��̽���������ֵ����buf������
    mov ah,10
    int 21h
    
    enterline		;�س�����
    mov cl,buf+1	;��ȡʵ�ʼ����ַ���������CX�Ĵ�����
    xor ch,ch
    
    lea si,buf+2	;��siָ����յ��ĵ�1���ַ�λ��
    add si,cx		;��Ϊ�Ӹ�λ�������Խ�siָ�����1�����յ��ĸ�λ��
    dec si          ;���һ��������ַ��ǻس�����ǰ�ƶ�1λ
    mov bp,0
    
cov: xor di,di		;�ۼ�����0
    
    xor dx,dx		;DX�Ĵ�����0
    
    mov bx,1		;���ڴӸ�λ����ʼ�������������Ȩֵ��Ϊ1
    
    
    
hhh:
	mov al,[si]		;ȡ����λ����al
	cmp al,20h      ;�ж��ǲ��ǿո�
	jz output       ;����ǿո��
	cmp al,'0'		;�߽��飺������벻��0-9�����֣��ͱ���
	jb error
	cmp al,'9'
	ja error

	
	
    sub al,30h		;��al�е�ascii��תΪ����
    xor ah,ah
    mul bx			;����������λ��Ȩֵ
    cmp dx,0		;�жϽ���Ƿ񳬳�16λ����Χ���糬���򱨴�
    jne error
    
    add di,ax		;���γɵ���ֵ�����ۼ���di��
    
    
    jc error		;����ֵ����16λ����Χ����
    
        
    mov ax,bx		;��BX�е���λȨֵ����10
    mov bx,10
    mul bx
    mov bx,ax
    
    dec si			;siָ���1��ָ��ǰһ��λ
    
    lea cx,buf+2    ;cx�����λ�ĵ�ַ
    cmp si,cx
    jae hhh         ;��si���ڻ����cxʱ��ת�ص�hhh
    ;jmp hhh    	;��CX�е��ַ���������ѭ��
   
output:   	
	mov ax,di		;������ת�������di�з��õ�ax
   	
   	mov result[bp],ax       ;bp�൱����ƫ����
   	add bp,2
   	dec si
   	lea cx,buf+2
    cmp si,cx      ;�ж����ǲ��Ǽ�⵽�����������λ
    jb stop        ;jb�����ڻ򲻸��ڡ�����Ѿ������λ�������
    jmp cov        ;����ͽ��Ĵ����ۼ���Ȩֵ����� ���´�����һ������

error:				;����������ʾ
	lea dx,err
    mov ah,9
    int 21h
    enterline 
    
    jmp star 		;������򷵻���ʼ����������  
        
stop:
   pop di
   pop si
   pop dx
   pop cx
   pop bx
   pop ax
   
endm
;-------------------------------------------------------------------------

;ʵ��ð�����򣬲��������������
DATAS SEGMENT
   A dw 10 dup(?);;;;;��ĿҪ����ٸ����־����뼸���ʺ�
   N=$-A 			;����������ռ���ֽ���
   err db 'ERROR$'
   num db 50,?,20 dup(?)  ;��Ϊnum��20λ�ģ��������س����������Լ���10���ַ�
DATAS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS
START:MOV AX,DATAS
      MOV DS,AX
      
      ascnum err,num,A  ;����
      
      MOV SI,0		;SI��������;ǰһ�����ĵ�ַ
      MOV CX,N/2-1	;����ѭ��������M(M=N/2)������Ҫ��ѭ��M-1��
      CALL BUBBLE	;����BUBBLE��ԭ����������
	  ;�����������    
      MOV CX,N/2	;ѭ��M�����������M����
      MOV SI,0		;SI������������ 
      MOV DI,0    	;��DI��¼���ֵ�λ��
      MOV BP,N+5	;���ڱ����洢��ת������ַ���λ��
SHOW: PUSH CX		;ѭ��������ջ
      MOV DX,0		;���ڽ�Ҫ����16λ����Ҫ�ø�16λΪ0
	  MOV AX,[SI]   ;��16λΪ��������
	  CALL DTOC		;����DTOC��ʮ������ת��Ϊ�ַ���
	  CALL SHOW_STR ;����SHOW_STR��һ����ת���õ����ַ������
	  ADD SI,2		;��һ����
	  POP CX		;ѭ��������ջջ
	  LOOP SHOW   
            
    MOV AH,4CH
    INT 21H
    
BUBBLE PROC
L1:	PUSH CX			;��ѭ��������ջ
	LEA SI,A		;SI����DATAS���ݶε�����
L2: MOV AX,A[SI]	;��ǰһ��������AX
	CMP AX,A[SI+2]	;�Ƚ�ǰ��������
	JBE NEXT		;���ǰһ����С�ڻ���ں�һ������������ֵıȽ�
	XCHG AX,A[SI+2]	;���򣬽���ǰ����������λ��
	MOV A[SI],AX
NEXT:ADD SI,2		;��һ����
	 LOOP L2		;ע���ڲ�ѭ���Ĵ����Ѿ�ȷ����
	 POP CX			;��ѭ��������ջ
	 LOOP L1		;��һ�ֱȽ�
	 RET
BUBBLE ENDP
;��ʮ������ת��Ϊ�ַ�������������
DTOC PROC
  S:MOV CX,10       ;������10������CX��   
    CALL DIVDW 		;����DIVDW����
    ADD CL,30H 		;������ת��ΪASCII�룬����������ʾ��
    MOV DS:[BP],CL  ;��ASCII��ŵ��ڴ��� 
    INC DI			;��DI��¼ѭ���Ĵ���
    PUSH AX    		;����16λ��ջ
    ADD AX,DX  		;����λ���λ��ӣ������ж��Ƿ��Ѿ�����  
    JZ BACK   		;�����󷵻ص��ô� 
    POP AX			;����16λ��ջ
    DEC BP		    ;������ת������ַ����������������SHOW_STR
    JMP S  
BACK:POP AX         ;Ϊ�˵õ���ȷ��IPֵ����Ҫ��ջһ��
     RET 
DTOC ENDP

;�ӳ����忪ʼ,�����Ƿ��뱻�����ĸ���λ������
;��ʽ��X/N=int(H/N)*65536+[rem(H/N)*65536+L]/N   
DIVDW PROC
 	PUSH AX   		;��16λ��ջ
    MOV AX,DX   	;����16λд��AX,
    MOV DX,0  		;����16λ����
    DIV CX    		;���µ�����10,
    MOV BX,AX 		;����int(H/N)ת�Ƶ�BX��Ĭ������rem(H/N)��DX
    POP AX    		;����16λ��ջ��
    DIV CX          ;��[rem(H/N)*65536+L]��10,Ĭ��������DX
    MOV CX,DX       ;������ת�Ƶ�CX
    MOV DX,BX       ;����int(H/N)ת�Ƶ�dx,�൱��int(H/N)*65536
    RET             ;�ӳ��������       
DIVDW ENDP
        
;ʵ���ַ��������        
SHOW_STR PROC
S2:MOV AH,2			;�������ת������ַ���
   MOV DL,DS:[BP]
   INT 21H
   INC BP			;˳�����
   DEC DI			;���ֵ�λ����һ
   JZ OK			;�ַ���������˾ͽ���
   JMP S2			;����������
OK:MOV AH,2		    ;����ո�
   MOV DL,0
   INT 21H
   RET		
SHOW_STR ENDP    
         
CODES ENDS
    END START














