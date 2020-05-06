DATAS SEGMENT
    bin dw 10 dup(?)    ;��Ŷ����ƽ��
    buf db 5 dup(?)      ;���ʮ������ ������λ�ϵ���ֵ ��100�����Ϊ 1,0,0
    msg1 db 'please input a hex number',13,10,'$'
    msg2 db 'the dec number:',13,10,'$'
    crlf db 13,10,'$'    ;�س�����
DATAS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS
START:
    MOV AX,DATAS
    MOV DS,AX
    
       mov bx,0        ;��ʼ��bx
       
       LEA dx,msg1        ;�����ʾ�ַ���
       mov ah,9
       int 21h
       
 input:
       mov ah,1        ;����һ���ַ�
       int 21h
       
       sub al,30h        ;��al�е�ascii��ת������ֵ
       jl init
   
       cmp al,10        ;���������0-9֮����ת
       jl toBin
       
       sub al,27h        ;��ת��Ϊa-f
       cmp al,0ah        ;������ַ���aС
       jl init            ;��������
       cmp al,10h        ;������ַ���f��
       jge init        ;��������
       
  toBin:            ;ת��Ϊ�����ƣ���������ϳ������ϵ���ֵ
       mov cl,4        
       shl bx,cl        ;bx����4λ
       mov ah,0        
       add bx,ax        ;������󲢴�ascii��ת������ֵ��bx���
       mov bin,bx        ;ת���ɶ���������浽�ڴ�bin
       jmp input        ;��������
       
  init:                ;��ʼ��,׼��ת��
      mov ax,bin        
      mov bx,10        
      mov si,4        ;ѭ���ĴΣ������λ
      
  toDec:            ;תΪ������λ�ϵ���ֵ����100ת��Ϊ1,0,0 ��λΪ1...
      mov dx,0        
      div bx            ;��10���õ�����λ�ϵ���ֵ
      mov [buf+si],dl    ;����Ϊ��λ�ϵ�ֵ����һ��ѭ��Ϊ��λ���ڶ���Ϊʮλ...���浽�ڴ���
      dec si            
      cmp ax,0        ;���Ƿ�Ϊ0��Ϊ0�㷨����
      ja toDec
  

      lea dx,crlf            ;��ʾ��ʾ
      mov ah,9
      int 21h
      lea dx,msg2
      mov ah,9
      int 21h
      
  output:                ;����ڴ��д�ŵĸ�����λ�ϵ���ֵ
      inc si
      mov dl,[buf+si]
      add dl,30h            ;תΪascii
      mov ah,2
      int 21h
      cmp si,4
      jb output
      
   
    mov ah,1
    int 21h
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
