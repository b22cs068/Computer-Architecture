.data
prompt:      .asciiz "Enter n: "      # Prompt for user input
result_msg:  .asciiz "The nth Catalan number is: "  # Output message

.text
.globl main

main:
    # Print the prompt
    li $v0, 4
    la $a0, prompt
    syscall

    # Read the integer input n
    li $v0, 5
    syscall
    move $t0, $v0     # Store the input n in $t0

    # Call the catalan subroutine
    move $a0, $t0     # Pass n as argument in $a0
    jal catalan       # Call catalan subroutine
    move $t1, $v0     # Store the result (Catalan number) in $t1

    # Print the result message
    li $v0, 4
    la $a0, result_msg
    syscall

    # Print the Catalan number
    move $a0, $t1
    li $v0, 1
    syscall

    # Exit program
    li $v0, 10
    syscall

# Catalan Subroutine
# Inputs:
#   $a0 = n (integer)
# Outputs:
#   $v0 = C(n) (nth Catalan number)
catalan:
    # Base case: if n == 0, return 1
    beq $a0, $zero, base_case

    # Initialize sum p = 0
    li $t2, 0   # $t2 will hold the sum (p)

    # Loop through 0 to n-1
    move $t3, $zero  # $t3 will be the loop counter i

loop:
    bge $t3, $a0, end_loop  # if i >= n, exit the loop

    # Recursive call for C(i)
    move $a1, $t3      # Pass i as argument in $a1
    jal catalan        # Recursive call for C(i)
    move $t4, $v0      # Store C(i) in $t4

    # Recursive call for C(n-1-i)
    sub $t5, $a0, $t3  # Calculate n-i
    sub $t5, $t5, 1    # Calculate n-i-1
    move $a1, $t5      # Pass n-i-1 as argument in $a1
    jal catalan        # Recursive call for C(n-i-1)
    move $t6, $v0      # Store C(n-i-1) in $t6

    # Multiply C(i) and C(n-i-1) and add to sum
    mul $t7, $t4, $t6  # $t7 = C(i) * C(n-i-1)
    add $t2, $t2, $t7  # p += C(i) * C(n-i-1)

    # Increment loop counter i
    addi $t3, $t3, 1
    j loop

end_loop:
    move $v0, $t2      # Return the sum p as C(n)
    jr $ra             # Return to caller

base_case:
    li $v0, 1          # C(0) = 1
    jr $ra             # Return to caller
