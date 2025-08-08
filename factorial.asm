.text
.globl fact
main:
        li      $a0, 5
        jal     fact
        move    $a0, $v0
        li      $v0, 1          #load print
        syscall                 #print
        li      $v0, 10         #load exit
        syscall                 #exit
fact:
        # frame allocation
        subu    $sp, $sp, 32    #sfract
        sw      $a0, 32($sp)
        sw      $ra, 16($sp)
        sw      $fp, 8($sp)
        addiu   $fp, $sp,32

        #main code
        bgtz    $a0, more       #check a0>0
        li      $v0, 1
        j       ret
more:
        addi    $a0, $a0, -1    #smore
        jal     fact
        lw      $a0, 32($sp)
        mul     $v0, $v0, $a0
        j       ret
ret:
        lw      $ra, 16($sp)    #sret
        lw      $fp, 8($sp)
        addiu   $sp, 32
        jr      $ra