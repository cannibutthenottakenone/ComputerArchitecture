    # Assembly implementation of the tak function.
    #
    # this routine is meant to be executed without delay slot enabled

    # #Index
    # |  Label   |                             Explanation                               |
    # |----------|-----------------------------------------------------------------------|
    # | main     | Executed when the file is run solo                                    |
    # | askValue | "Main" helper, prints a request and reads an integer from the console |
    # | tak      | computes tak function, globally exported                              |
    # | |- p1    | main body of tak                                                      |
    # | |- ret   | return: loads the necessary data, closes the frame, returns           |




.data
welcomeStr:
    .ascii  "  _______    _          __                  _   _                                                            \n"
    .ascii  " |__   __|  | |        / _|                | | (_)                                                           \n"
    .ascii  "    | | __ _| | __    | |_ _   _ _ __   ___| |_ _  ___  _ __       _ __  _ __ ___   __ _ _ __ __ _ _ __ ___  \n"
    .ascii  "    | |/ _` | |/ /    |  _| | | | '_ \\ / __| __| |/ _ \\| '_ \\     | '_ \\| '__/ _ \\ / _` | '__/ _` | '_ ` _ \\ \n"
    .ascii  "    | | (_| |   <     | | | |_| | | | | (__| |_| | (_) | | | |    | |_) | | | (_) | (_| | | | (_| | | | | | |\n"
    .ascii  "    |_|\\__,_|_|\\_\\    |_|  \\__,_|_| |_|\\___|\\__|_|\\___/|_| |_|    | .__/|_|  \\___/ \\__, |_|  \\__,_|_| |_| |_|\n"
    .ascii  "                                                                  | |               __/ |                    \n"
    .ascii  "                                                                  |_|              |___/                     \n"
    .asciiz "\n\nWelcome!"

inputStr:
    .ascii  "\nInsert input "
inputInsert:
    .space  1                                                                                                                           #where input name letter will go
    .asciiz ": "

outputStr:
    .asciiz "\nResult: "

.text
    .globl  tak
main:
    li      $v0,        4                                                                                                               #|main|
    la      $a0,        welcomeStr
    syscall                                                                                                                             #print welcome string

    li      $a3,        88                                                                                                              #'X'
    jal     askValue
    move    $s0,        $v0

    addi    $a3,        $a3,            1                                                                                               #'Y'
    jal     askValue
    move    $a1,        $v0

    addi    $a3,        $a3,            1                                                                                               #'Z'
    jal     askValue
    move    $a2,        $v0
    move    $a0,        $s0

    jal     tak                                                                                                                         #call tak function

    move    $t0,        $v0                                                                                                             #putting the result aside
    la      $a0,        outputStr                                                                                                       #print "Result: "
    li      $v0,        4
    syscall
    move    $a0,        $t0                                                                                                             #print result
    li      $v0,        1
    syscall

    li      $v0,        10                                                                                                              #exit syscall
    syscall


askValue:
    # #input
    # - $a3: ASCII code for input name
    #
    # #output
    # - $v0: value from input, integer

    sb      $a3,        inputInsert                                                                                                     #|askvalue| add char in $a3 to input request string

    la      $a0,        inputStr                                                                                                        #print input request
    li      $v0,        4
    syscall

    li      $v0,        5                                                                                                               #ask for input
    syscall
    jr      $ra




tak:
    # #input
    # - $a0: x, integer
    # - $a1: y, integer
    # - $a2: z, integer
    #
    # #output
    # - $v0: computed value, integer
    #
    # #memory map
    # \\ = reserved
    #
    # frame size: 40bytes (36 + 4 padding to doubleword)
    # |  variable_name   |  dim |  fp-x | sp+x  |
    # |------------------|------|-------|-------|
    # | a0 aka x         |    4 |     0 |    40 |
    # | a1 aka y         |    4 |     4 |    36 |
    # | a2 aka z         |    4 |     8 |    32 |
    # | \\ a3            |    4 |    12 |    28 |
    # | ra               |    4 |    16 |    24 |
    # | \\ padding       |    4 |    20 |    20 |
    # | fp               |    4 |    24 |    16 |
    # | tak(x-1, y, z)   |    4 |    28 |    12 |
    # | tak(y-1, z, x)   |    4 |    32 |     8 |
    # | \\ padding       |    4 |    36 |     4 |
    # | --end of frame-- |      |    40 |     0 |



    addiu   $sp,        $sp,            -40                                                                                             #|tak| new frame
    sw      $a0,        40($sp)
    sw      $a1,        36($sp)
    sw      $a2,        32($sp)
    sw      $ra,        24($sp)
    sw      $fp,        16($sp)
    addiu   $fp,        $sp,            40

    blt     $a1,        $a0,            p1                                                                                              #if (y<x) {goto p1} else {return z}
    move    $v0,        $a2                                                                                                             #move $a2 (z) to $v0 for return
    j       ret

tak_p1:

    #calls tak(x-1, y, z)
    addi    $a0,        $a0,            -1                                                                                              #|tak->p1|
    jal     tak
    sw      $v0,        -28($fp)

    #calls tak(y-1, z, x)
    lw      $a0,        -4($fp)
    addi    $a0,        $a0,            -1
    lw      $a1,        -8($fp)
    lw      $a2,        ($fp)
    jal     tak
    sw      $v0,        -32($fp)

    #calls tak(z-1, x, y)
    lw      $a0,        -8($fp)
    addi    $a0,        $a0,            -1
    lw      $a1,        ($fp)
    lw      $a2,        -4($fp)
    jal     tak

    #calls tak(tak(x-1, y, z),tak(y-1, z, x),tak(z-1, x, y))
    lw      $a0,        -28($fp)
    lw      $a1,        -32($fp)
    move    $a2,        $v0
    jal     tak

    j       ret

tak_ret:
    lw      $ra,        -16($fp)                                                                                                        #|tak->ret|
    lw      $fp,        -24($fp)
    addiu   $sp,        $sp,            40
    jr      $ra
