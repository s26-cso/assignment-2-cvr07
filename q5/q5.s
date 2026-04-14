.section .rodata

filename: .string "input.txt"
mode: .string "r"

true: .string "Yes\n"
false: .string "No\n"

.section .text

.globl main

main : 
    addi sp,sp,-64
    sd ra,56(sp)
    sd s0,48(sp)
    sd s1,40(sp)
    sd s2,32(sp)
    sd s3,24(sp)
    sd s4,16(sp)
    sd s5,8(sp)
    sd s6,0(sp)

    la a0,filename
    la a1,mode
    call fopen

    addi s0,a0,0 #s0 = file pointer 

    addi a0,s0,0 # file pointer
    addi a1,x0,0 # offset
    addi a2,x0,2 # 2 signifies the end
    call fseek

    addi a0,s0,0  
    call ftell # to get the pointer after fseek
    beqz s1,is_pallindrome # for empty file

    addi s1,a0,0 # number of bytes

    addi s2,x0,0 # offset from start
    addi s3,x0,-1 # offset from en

    loop : 
        addi a0,s0,0 #file pointer
        addi a1,s2,0 # offset 
        addi a2,x0,0 # 0 signifies from start
        call fseek

        addi a0,s0,0 # file pointer 
        call fgetc

        addi s2,s2,1

        addi s4,a0,0 # character from the start 

        addi a0,s0,0 # file pointer 
        addi a1,s3,0 # offset
        addi a2,x0,2 # 2 signiies from the end
        call fseek

        addi a0,s0,0 # file pointer 
        call fgetc

        addi s5,a0,0 # character from the end 

        addi s3,s3,-1

        bne s4,s5,not_pallindrome # if both character are not equal then its not a pallindrome 

        sub t0,s2,s3 # sum of offsets 
        bge t0,s1,is_pallindrome # t0 >= n (n is total number of bytes then its a pallindrome)

        j loop;

is_pallindrome : 
    la a0,true
    call printf

    addi a0,s0,0
    call fclose

    ld ra,56(sp)
    ld s0,48(sp)
    ld s1,40(sp)
    ld s2,32(sp)
    ld s3,24(sp)
    ld s4,16(sp)
    ld s5,8(sp)
    ld s6,0(sp)

    addi sp,sp,64

    ret 

not_pallindrome:
    la a0,false
    call printf

    addi a0,s0,0
    call fclose

    ld ra,56(sp)
    ld s0,48(sp)
    ld s1,40(sp)
    ld s2,32(sp)
    ld s3,24(sp)
    ld s4,16(sp)
    ld s5,8(sp)
    ld s6,0(sp)

    addi sp,sp,64

    ret 


