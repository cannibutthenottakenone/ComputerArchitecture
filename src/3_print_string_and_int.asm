.data
str:    .asciiz "the answer is: "
nstr:   .asciiz "\n"

.text
    j       main

newline:
    li      $v0,        4
    la      $a0,        nstr
    syscall
    jr      $ra

main:
    li      $v0,        4           #stirng print
    la      $a0,        str
    syscall

    li      $v0,        1           #int print
    li      $a0,        5
    syscall

    jal     newline
    nop