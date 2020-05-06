DATAS SEGMENT
    bin dw 10 dup(?)    ;存放二进制结果
    buf db 5 dup(?)      ;存放十进制数 各个数位上的数值 如100，存放为 1,0,0
    msg1 db 'please input a hex number',13,10,'$'
    msg2 db 'the dec number:',13,10,'$'
    crlf db 13,10,'$'    ;回车换行
DATAS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS
START:
    MOV AX,DATAS
    MOV DS,AX
    
       mov bx,0        ;初始化bx
       
       LEA dx,msg1        ;输出提示字符串
       mov ah,9
       int 21h
       
 input:
       mov ah,1        ;输入一个字符
       int 21h
       
       sub al,30h        ;把al中的ascii码转换成数值
       jl init
   
       cmp al,10        ;输入的数在0-9之间跳转
       jl toBin
       
       sub al,27h        ;再转换为a-f
       cmp al,0ah        ;输入的字符比a小
       jl init            ;结束输入
       cmp al,10h        ;输入的字符比f大
       jge init        ;结束输入
       
  toBin:            ;转换为二进制，把输入组合成意义上的数值
       mov cl,4        
       shl bx,cl        ;bx左移4位
       mov ah,0        
       add bx,ax        ;把输入后并从ascii码转换来的值与bx相加
       mov bin,bx        ;转换成二进制数后存到内存bin
       jmp input        ;继续输入
       
  init:                ;初始化,准备转换
      mov ax,bin        
      mov bx,10        
      mov si,4        ;循环四次，最大到万位
      
  toDec:            ;转为各个数位上的数值，如100转换为1,0,0 百位为1...
      mov dx,0        
      div bx            ;除10法得到各个位上的数值
      mov [buf+si],dl    ;余数为该位上的值，第一次循环为个位，第二次为十位...；存到内存中
      dec si            
      cmp ax,0        ;商是否为0，为0算法结束
      ja toDec
  

      lea dx,crlf            ;显示提示
      mov ah,9
      int 21h
      lea dx,msg2
      mov ah,9
      int 21h
      
  output:                ;输出内存中存放的各个数位上的数值
      inc si
      mov dl,[buf+si]
      add dl,30h            ;转为ascii
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
