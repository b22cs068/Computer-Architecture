.data
# Prompts and messages
prompt1:      .asciiz "Enter the first integer: "
prompt2:      .asciiz "Enter the second integer: "
sum_msg:      .asciiz "Sum: "
mul_msg:      .asciiz "Product: "
sub_msg:      .asciiz "Difference: "
newline:      .asciiz "\n"

.text
main:
    # --- Input: First integer ---
    li $v0, 4               # syscall to print string
    la $a0, prompt1         # load address of prompt1
    syscall

    li $v0, 5               # syscall to read integer
    syscall
    move $t0, $v0           # store the first integer in $t0

    # --- Input: Second integer ---
    li $v0, 4               # syscall to print string
    la $a0, prompt2         # load address of prompt2
    syscall

    li $v0, 5               # syscall to read integer
    syscall
    move $t1, $v0           # store the second integer in $t1

    # --- Addition ---
    add $t2, $t0, $t1       # $t2 = $t0 + $t1
    
    # Print addition result
    li $v0, 4               # syscall to print string
    la $a0, sum_msg         # load address of sum_msg
    syscall

    li $v0, 1               # syscall to print integer
    move $a0, $t2           # load result into $a0
    syscall

    li $v0, 4               # syscall to print string
    la $a0, newline         # print newline
    syscall

    # --- Multiplication ---
    mul $t3, $t0, $t1       # $t3 = $t0 * $t1
    
    # Print multiplication result
    li $v0, 4               # syscall to print string
    la $a0, mul_msg         # load address of mul_msg
    syscall

    li $v0, 1               # syscall to print integer
    move $a0, $t3           # load result into $a0
    syscall

    li $v0, 4               # syscall to print string
    la $a0, newline         # print newline
    syscall

    # --- Subtraction ---
    sub $t4, $t0, $t1       # $t4 = $t0 - $t1
    
    # Print subtraction result
    li $v0, 4               # syscall to print string
    la $a0, sub_msg         # load address of sub_msg
    syscall

    li $v0, 1               # syscall to print integer
    move $a0, $t4           # load result into $a0
    syscall

    li $v0, 4               # syscall to print string
    la $a0, newline         # print newline
    syscall

    # End the program
    li $v0, 10              # syscall to exit
    syscall
