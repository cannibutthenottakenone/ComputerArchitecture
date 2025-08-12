    # from the professor's slides, with modifications
    # C code (professor slides):
    # switch (k) {
    #    case 0: f=i+j; break;
    #    case 1: f=g+h; break;
    #    case 2: f=g-h; break;
    #    case 3: f=i-j; break;
    #
    #
    # this project:
    # # Select saved register through a switch with address table
    #
    # this code is meant to be executed with delay slots disabled in the simulator

.data
jumpTable:
    .word   s0
    .word   s1
    .word   s2
    .word   s3
    .word   default                     # register $at (just for fun)

.text
main:
    # Setup test values for saved registers
    li      $s0,    01
    li      $s1,    11
    li      $s2,    21
    li      $s3,    31

switch:
    ori     $t1,    $zero,      4       # set number of cases
    la      $t2,    jumpTable           # load jump table address

    ori     $v0,    $zero,      5
    syscall                             # ask for selection (k)
    move    $t0,    $v0

    slt     $t9,    $t0,        $zero   # (intended: k >= 0) k < 0 ?
    bne     $t9,    $zero,      default
    slt     $t9,    $t0,        $t1     # k < n ?
    beq     $t9,    $zero,      default

    sll     $t0,    $t0,        2       # multiply index by word's lenght (logical shift by 2)
    add     $t0,    $t0,        $t2     # add index to beginning of table
    lw      $t0,    ($t0)               #load instruction address
    jr      $t0                         # jump

default:
    move    $v1,    $at
    j       exit
s0:
    move    $v1,    $s0
    j       exit
s1:
    move    $v1,    $s1
    j       exit
s2:
    move    $v1,    $s2
    j       exit
s3:
    move    $v1,    $s3
    j       exit


exit:
    li      $v0,    10
    syscall
