 .section .text
.globl make_node
.globl insert
.globl get
.globl getAtMost


make_node :
    addi sp,sp,-16
    sd ra,8(sp)
    sd a0,0(sp)

    addi a0,x0,24 # space of 24 bytes (with padding)
    call malloc 

    ld t0,0(sp) # laoding the value of int from stack

    sw t0,0(a0) #val
    sd x0,8(a0) #left
    sd x0,16(a0) #right

    ld ra,8(sp)
    addi sp,sp,16
    ret 

insert : 
    addi sp,sp,-32
    sd ra,24(sp)
    sd a0,16(sp) # root
    sd a1,8(sp) # val

    add a0,x0,a1
    call make_node # calling make node for creating the node of given value

    ld a1,8(sp) # value 
    ld t0,16(sp) # root
    add t1,x0,a0    # t1 = newnode

    bnez t0,loop # checking if root is null or not if not null then go to loop
    add a0,x0,t1 # if root is NULL then return the address of the newnode
    ld ra ,24(sp)
    addi sp,sp,32
    ret

    loop : 
        lw t2,0(t0) # curr node's value

        blt a1,t2,left # if val < curr then go left 

        ld t4,16(t0) # right child 
        beqz t4,exit_loop # if right child is NULL then insert here 
        add t0,x0,t4 # move to right
        j loop

        left :
            ld t4,8(t0) # left child
            beqz t4,exit_loop # if left child is NULL then insert here
            add t0,x0,t4 # move to left 
            j loop
    
    exit_loop : 
        lw t2,0(t0)
        blt a1,t2,left_insert # if value is less than parent insert on left side 

        sd t1,16(t0) #insert on right side
        j exit

    left_insert:
            sd t1,8(t0) #insert on left side 
        j exit

    

    exit :
        ld ra ,24(sp)
        ld a0,16(sp) # return the root
        addi sp,sp,32
        ret 

get : 
    addi sp,sp,-16
    sd ra,8(sp)

    addi t0,a0,0 # t0 = root 
    
    loop_get : 
        beqz t0,exit_get # if root == NULL return NULL
        lw t2,0(t0) # curr value
        beq t2,a1,exit_get # found
        blt a1,t2,left_get # if val < curr go left 
        ld t0,16(t0) # go right
        j loop_get

        left_get : 
            ld t0,8(t0) # go left 
            j loop_get

    exit_get :
        addi a0,t0,0 # return node pointer or NULL
        ld ra,8(sp)
        addi sp,sp,16
        ret

getAtMost : 
    addi sp,sp,-16
    sd ra,8(sp)

    addi t0,a1,0 # t0 = root 
    addi t1,x0,-1 # t1 = answer (init -1)

    loop_getAtMost : 
        beqz t0,exit_getAtMost # if NULL then its done 
        lw t2,0(t0) # curr value
        bgt t2,a0,left_getAtMost #if curr > val go left 
        lw t1,0(t0)     # update answer 
        ld t0,16(t0)    # go right to find bigger answer if  it exists
        j loop_getAtMost

        left_getAtMost :
            ld t0,8(t0) # go left 
            j loop_getAtMost
    
    exit_getAtMost : 
        addi a0,t1,0 # return answer 
        ld ra,8(sp)
        addi sp,sp,16

        ret


        