    # Assembly implementation of the tak function
    # Created by Ijuo Takeuchi, it does not compute
    # anything useful, but it is a widely used
    # banchmark
    #
    # personal note, i so don't like using delay slots

.text
    .globl  tak
main:
    nop                             #main starts
    li      $a0,    18              #x
    li      $a1,    12              #y


    jal     tak
    li      $a2,    6               #z (loaded in the delay slot)

    move    $a0,    $v0
    li      $v0,    1               #load print
    syscall                         #print
    li      $v0,    10              #load exit
    syscall                         #exit


tak:
    # #memory map
    # \\ = reserved
    #
    # frame size: 40bytes (36 + 4 padding to doubleword)
    # variable_name     dim     fp-x    sp+x
    # a0 aka x          4       0       40
    # a1 aka y          4       4       36
    # a2 aka z          4       8       32
    # \\ a3             4       12      28
    # ra                4       16      24
    # \\ padding        4       20      20
    # fp                4       24      16
    # tak(x-1, y, z)    4       28      12
    # tak(y-1, z, x)    4       32      8
    # \\ padding        4       36      4
    # --end of frame--          40      0


    nop                             #tak starts
    # debug instruction
    addiu   $t0,    $t0,        1
    addiu   $sp,    $sp,        -40 #new frame
    sw      $a0,    40($sp)
    sw      $a1,    36($sp)
    sw      $a2,    32($sp)
    sw      $ra,    24($sp)
    sw      $fp,    16($sp)
    addiu   $fp,    $sp,        40

    blt     $a1,    $a0,        p1  #return condition
    move    $v0,    $a2
    j       ret

p1:
    nop                             #p1 starts

    #calls tak(x-1, y, z)
    addi    $a0,    $a0,        -1
    jal     tak
    nop
    sw      $v0,    -28($fp)

    #calls tak(y-1, z, x)
    lw      $a0,    -4($fp)
    addi    $a0,    $a0,        -1
    lw      $a1,    -8($fp)
    lw      $a2,    ($fp)
    jal     tak
    nop
    sw      $v0,    -32($fp)

    #calls tak(z-1, x, y)
    lw      $a0,    -8($fp)
    addi    $a0,    $a0,        -1
    lw      $a1,    ($fp)
    lw      $a2,    -4($fp)
    jal     tak
    nop

    #calls tak(tak(x-1, y, z),tak(y-1, z, x),tak(z-1, x, y))
    lw      $a0,    -28($fp)
    lw      $a1,    -32($fp)
    move    $a2,    $v0
    jal     tak
    nop

    j       ret

ret:
    nop                             #ret starts
    lw      $ra,    -16($fp)
    lw      $fp,    -24($fp)
    addiu   $sp,    $sp,        40
    jr      $ra
    nop
