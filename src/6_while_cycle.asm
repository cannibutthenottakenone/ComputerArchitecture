    # from the professor's slides
    # C code:
    # .
    # while(save[i]==k)
    #   i = i + j

.data
save:   .byte   69 69 69 69 69 69 69 69 69 69 69 69 69 69 69 69 69 69 69 69 69 69 69 69 69 69 69 69 69 69 69 79 32 69 79 33

.text
main:                                                                                                                       #start main
    nop                                                                                                                     #start main
    move    $s1,    $zero                                                                                                   # i
    li      $s2,    69                                                                                                      # k
    li      $s3,    1                                                                                                       #j
    la      $s4,    save                                                                                                    # address of save
loop:
    nop                                                                                                                     #start loop
    add     $t0,    $s4,    $s1                                                                                             #address of save[i]
    lb      $t2,    ($t0)                                                                                                   #save[i]
    bne     $t2,    $s2,    exit                                                                                            # save[i] == k
    nop
    j       loop                                                                                                            #loop back up
    add     $s1,    $s1,    $s3                                                                                             # I = i + j (delay slot)
    nop

exit:
