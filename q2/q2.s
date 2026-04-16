.section .rodata
fmt2: .string "%d"
.section .text
.globl main

main:
    addi sp,sp,-64
    sd ra,56(sp)
    sd s0,48(sp)
    sd s1,40(sp)
    sd s2,32(sp)
    sd s3,24(sp)
    sd s4,16(sp)
    sd s5,8(sp)
    sd s6,0(sp)

    # n = argc - 1
    addi s1,a0,0 # a0 =argc
    addi s1,s1,-1

    addi s2,a1,0   # a1 = argv
    addi s2,s2,8   # Skip argv[0]

    
    slli a0,s1,2    # malloc input array (n * 4 bytes)
    call malloc
    addi s0,a0,0       # s0 = input arr

    addi s3,x0,0        #s3 = iterator 
input_loop:
    bge s3,s1,exit_input
    slli t0,s3,3   # offset for argv (8 bytes per pointer)
    add t0,t0,s2
    ld a0,0(t0)    # Load pointer to string
    call atoi      
    
    slli t1,s3,2   # offset (4 bytes as int)
    add t1,t1,s0
    sw a0,0(t1)    # Store int in arr[s3]
    
    addi s3,s3,1
    j input_loop

exit_input:
    # malloc result array (n * 4 bytes)
    slli a0,s1,2
    call malloc
    mv s4,a0       

    # Initialize result array with -1
    li s3,0
    li t1,-1
initialize:
    bge s3,s1,exit_initialize
    slli t0,s3,2
    add t0,t0,s4
    sw t1,0(t0)
    addi s3,s3,1
    j initialize

exit_initialize:
    # malloc stack array (n * 4 bytes)
    slli a0,s1,2
    call malloc
    mv s6,a0       # s6 = stack base

    li s3,0        # i = 0
    mv t0,s6       # t0 = stack top pointer
    li t1,0        # t1 = stack size counter

nge_loop:
    bge s3,s1,finish

while_loop:
    # If stack empty, go to push
    beqz t1,push_step

    addi t2,t0,-4 # top element of stack
    lw t3,0(t2)      # t3 = index from stack top

    # Load arr[s3]
    slli t4,s3,2
    add t4,t4,s0
    lw t5,0(t4)      # t5 = current element

    # Load arr[stack_top]
    slli t6,t3,2
    add t6,t6,s0
    lw t6,0(t6)      # t6 = element at stack top

    ble t5,t6,push_step # if curr element <=  element at index = top element of stack then push

    # Pop: update result[stack_top_index] = current_element
    addi t0,t0,-4
    addi t1,t1,-1
    slli t2,t3,2
    add t2,t2,s4
    sw s3,0(t2)
    j while_loop # we will jump to while loop not nge loop till we do not find element in the stack which is gretaer than the current element or stack becomes empty

push_step:
    sw s3,0(t0)      # Push current index
    addi t0,t0,4
    addi t1,t1,1
    addi s3,s3,1     # Move to next array element
    j nge_loop

finish:
    # Print Loop
    li s3,0
print_loop:
    bge s3,s1,exit_print # s1 = n
    slli t0,s3,2
    add t0,t0,s4
    lw a1,0(t0)      # Load value from result array
    la a0,fmt2
    call printf

    addi t0,s1,-1
    beq t0,s3,skip_space
    li a0,32
    call putchar
    skip_space:      
    addi s3,s3,1
    j print_loop

exit_print:

    li a0,10         # Print newline
    call putchar

    li a0,0
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
