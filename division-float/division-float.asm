


DATAS SEGMENT
    ;�˴��������ݶδ���  
    err 'number too large$'
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    MOV AH,4CH
    INT 21H
    
division proc
re:
 	cmp result2,256 ;�жϳ�����С�Ƿ񳬹�һ���ֽ�
 	jb continue     ;û�г�������תcontinue����ִ��
 	jmp again       ;��תagain�����������
again:
 	lea dx,err      ;���������������ʾ
    mov ah,9
    int 21h
    enterline
    lea dx,str6     ;����ڶ�������ʾ
    mov ah,9
    int 21h
    ascnum err,num2,result2 ;�����������
    jmp re          ;���س����ӳ���ͷ�����ж�
continue:
 mov dx,result1
 numasc dx,flag  ;�����һ������
 lea dx,o4       ;���/��
 mov ah,9    
 int 21h
 xor dx,dx
 mov dx,result2
 mov result3,dl
 xor dh,dh       ;ֻ������λ��һ���ֽڣ�
 numasc dx,flag  ;����ڶ�������
 lea dx,op       ;���=��
 mov ah,9
 int 21h
 
 cmp result3,1  ;���������1���������⴦��
 je outtt    
 
 mov ax,result1
 mov bl,result3
 cmp ah,bl       ;�Ƚϱ������ĸ�λ�ͳ����Ĵ�С
 jae error2      ;�������ĸ�λ���ڵ��ڳ�������������������תerror2��������
 div bl          ;ִ�г���
 mov result4,ah  ;��result4��������
 xor ah,ah 
 mov dx,ax      ;�������������
 numasc dx,flag  ;���������
 lea dx,point    ;���С����
 mov ah,9
 int 21h 
 
 xor ah,ah       ;���ah
 mov al,result4  ;�ѵ�һ�����̵���������al
 mov bl,10
 mul bl          ;�ѵ�һ�����̵�������10
 div result3     ;��һ�����̵�������10��Ľ���ٳ��Գ���
 
 mov result5,ah  ;�ڶ������̵���������result5
 xor ah,ah       ;���ah,����al�е���
 mov dx,ax       
 numasc dx,flag  ;����̣�С������һλ����
 mov al,result5
 mul bl          ;�ڶ������̵�������10
 div result3     ;�ڶ������̵�������10�ٳ��Գ���
 
 mov result6,ah  ;���������̵���������result5
 xor ah,ah       ;���ah,����al�е���
 mov dx,ax
 numasc dx,flag  ;����̣�С�����ڶ�λ����
 mov al,result6
 mul bl          ;���������̵�������10
 div result3     ;���������̵�������10�ٳ��Գ���

 shr result3,1   ;result3Ϊ�����Ķ���֮һ����������ȡ������
 cmp ah,result3
 jae plus        ;��ת����λ
 jmp noplus
plus:
 inc al          ;��λ���
 xor ah,ah
 mov dx,ax
 numasc dx,flag  ;���������
 jmp fin
noplus:
 xor ah,ah       ;����λ���
 mov dx,ax
 numasc dx,flag  ;���������
 enterline
 lea dx,de      ;��ʾ���������ʮ���Ƶ�
 mov ah,9    
 int 21h
 jmp fin
error2:
 lea dx,err2      ;���������Ϣ
 mov ah,9
 int 21h
 enterline
 lea dx,str10    ;����ִ�в�����ʾ
    mov ah,9
    int 21h
    enterline
    lea dx,str5    ;�����һ������ʾ
    mov ah,9
    int 21h
    ascnum err,num1,result1
CODES ENDS
    END START
