    # Exercise:
    # write a routine that computes the maximum factorial representable in 32bits and stores all factorials up to and including that in a contiguous memory block
    # at the end of the routine v0 should contain nmax (the maximum input to the factorial) and v1 nmax!

    # What is going to happen
    # the code is going to multiply in a loop, checking for overflow each time.
    # when overflow happens (hi register > 0) it saves all values in data segment.
    # --
    # given that this is not meant to be a subroutine i won't save in the frame the registers i would otherwise
    # this routine is meant to be executed without delay slot enabled


.text
main:
    li      $t0,    1               # factorial to compute
    li      $t1,    1               # computed factorial

    move    $fp,    $sp             # set frame pointer to beginning of frame

FactL:
    addi    $sp,    $sp,    -4      # 1 word
    sw      $t1,    ($sp)

    addi    $t0,    $t0,    1

    mult    $t0,    $t1
    mflo    $t1
    mfhi    $t9

    bgt     $t9,    $zero,  Save
    addi    $t0,    $t0,    -1
    j       FactL

Save:
    li      $v0,    9               #use sbrk to find a space in memory
    move    $a0,    $t0             #copy value and reduce by one (remove failed increment)
    sll     $a0,    $a0,    2
    syscall

    move    $t9,    $fp
SaveL:
    addi    $t9,    $t9,    -4
    lw      $t8,    ($t9)
    sw      $t8,    ($v0)
    addi    $v0,    $v0,    4
    bgt     $t9,    $sp,    SaveL

    move    $v0,    $t0
    move    $v1,    $t8



