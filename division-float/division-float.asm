


DATAS SEGMENT
    ;此处输入数据段代码  
    err 'number too large$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    MOV AH,4CH
    INT 21H
    
division proc
re:
 	cmp result2,256 ;判断除数大小是否超过一个字节
 	jb continue     ;没有超过则跳转continue继续执行
 	jmp again       ;跳转again重新输入除数
again:
 	lea dx,err      ;重新输入操作符提示
    mov ah,9
    int 21h
    enterline
    lea dx,str6     ;输入第二个数提示
    mov ah,9
    int 21h
    ascnum err,num2,result2 ;重新输入除数
    jmp re          ;跳回除法子程序开头重新判断
continue:
 mov dx,result1
 numasc dx,flag  ;输出第一个数字
 lea dx,o4       ;输出/号
 mov ah,9    
 int 21h
 xor dx,dx
 mov dx,result2
 mov result3,dl
 xor dh,dh       ;只保留低位（一个字节）
 numasc dx,flag  ;输出第二个数字
 lea dx,op       ;输出=号
 mov ah,9
 int 21h
 
 cmp result3,1  ;如果除数是1，进行特殊处理
 je outtt    
 
 mov ax,result1
 mov bl,result3
 cmp ah,bl       ;比较被除数的高位和除数的大小
 jae error2      ;被除数的高位大于等于除数，会除法溢出，则跳转error2重新输入
 div bl          ;执行除法
 mov result4,ah  ;用result4保存余数
 xor ah,ah 
 mov dx,ax      ;把余数部分清空
 numasc dx,flag  ;输出运算结果
 lea dx,point    ;输出小数点
 mov ah,9
 int 21h 
 
 xor ah,ah       ;清空ah
 mov al,result4  ;把第一次做商的余数送入al
 mov bl,10
 mul bl          ;把第一次做商的余数乘10
 div result3     ;第一次做商的余数乘10后的结果再除以除数
 
 mov result5,ah  ;第二次做商的余数送入result5
 xor ah,ah       ;清空ah,留下al中的商
 mov dx,ax       
 numasc dx,flag  ;输出商（小数点后第一位数）
 mov al,result5
 mul bl          ;第二次做商的余数乘10
 div result3     ;第二次做商的余数乘10再除以除数
 
 mov result6,ah  ;第三次做商的余数送入result5
 xor ah,ah       ;清空ah,留下al中的商
 mov dx,ax
 numasc dx,flag  ;输出商（小数点后第二位数）
 mov al,result6
 mul bl          ;第三次做商的余数乘10
 div result3     ;第三次做商的余数乘10再除以除数

 shr result3,1   ;result3为除数的二分之一（奇数向下取整数）
 cmp ah,result3
 jae plus        ;跳转至进位
 jmp noplus
plus:
 inc al          ;进位输出
 xor ah,ah
 mov dx,ax
 numasc dx,flag  ;输出运算结果
 jmp fin
noplus:
 xor ah,ah       ;不进位输出
 mov dx,ax
 numasc dx,flag  ;输出运算结果
 enterline
 lea dx,de      ;提示输出的数是十进制的
 mov ah,9    
 int 21h
 jmp fin
error2:
 lea dx,err2      ;输出报错信息
 mov ah,9
 int 21h
 enterline
 lea dx,str10    ;给出执行操作提示
    mov ah,9
    int 21h
    enterline
    lea dx,str5    ;输入第一个数提示
    mov ah,9
    int 21h
    ascnum err,num1,result1
CODES ENDS
    END START
