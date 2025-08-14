
.text
.globl fattnr
main:
    li $a0, 5
fattnr:
    move $t0, $a0
loop:
    addi $a0, $a0, -1
    beq $a0, $zero, return
    mul $t0, $t0, $a0
    j loop
return:
    move $v0, $t0
