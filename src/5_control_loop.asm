    # from the professor's slides
    # C code:
    # .
    # L1:
    # g = A[i]
    # i = i + j
    # if (i != h) goto L1


.data
A:  .half   68, 79, 78, 69, 82, 32, 75, 69, 66, 65, 66

.text
main:
    nop                                                 #start main
    move    $s1,    $zero                               # g
    li      $s2,    11                                  # h
    move    $s3,    $zero                               # i
    li      $s4,    1                                   # j
    la      $s5,    A                                   #address of A
L1:
    nop                                                 #start L1
    add     $t1,    $s3,    $s3                         #align to halfword
    add     $t2,    $t1,    $s5                         #address of A[i]
    lh      $t2,    ($t2)                               # t2 = A[i]

    move    $a0,    $t2                                 # print the retrieved value
    li      $v0,    11                                  # (they were secretly characters all along)
    syscall                                             #  even if they are signed halfwords it shouldn't be a problem cause both are sign extended but positive


    add     $s2,    $s2,    $t2                         # g = g+A[i]
    add     $s3,    $s3,    $s4                         # i = i + j
    bne     $s3,    $s2,    L1                          # if (i!=h) goto L1
    nop

