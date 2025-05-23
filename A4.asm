.data
promt_msg: .asciiz "Enter an Ineger" 
catalan_number: .word 0
promt_result: .asciiz "Result: "
n: .word 0
.text
.globl main

main:

    la $a0, promt_msg
    li $v0, 4
    syscall
    
    la $a0, n
    li $v0, 5
    syscall 