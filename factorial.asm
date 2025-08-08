.text
.globl fact
main:
        li      $a0, 12        #12! is the greatest factorial that a 32bits signed int can handle
        jal     fact
        nop
        move    $a0, $v0
        li      $v0, 1          #load print
        syscall                 #print
        li      $v0, 10         #load exit
        syscall                 #exit
fact:
        # frame allocation
        subu    $sp, $sp, 24    #sfract
        sw      $a0, 24($sp)
        sw      $ra, 8($sp)

        #main code
        bgtz    $a0, more       #check a0>0
        nop
        li      $v0, 1
        j       ret
        nop
more:
        addi    $a0, $a0, -1    #smore
        jal     fact
        nop
        lw      $a0, 24($sp)
        mul     $v0, $v0, $a0
        j       ret
        nop
ret:
        lw      $ra, 8($sp)    #sret
        addiu   $sp, $sp, 24
        jr      $ra
        nop
