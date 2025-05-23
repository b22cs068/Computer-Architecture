.data
prompt:      .asciiz "Enter a value for n: "      # Prompt message
result_msg:  .asciiz "Catalan number C(n) = "    # Result message
catalan:     .word 1                            # Precompute base case C(0) = 1
table:       .space 400                        # Space for storing intermediate Catalan numbers (table size: 100 integers)

.text
.globl main

main:
    # Print prompt message
    li   $v0, 4                     # System call for print string
    la   $a0, prompt                # Load address of prompt message
    syscall

    # Read integer from user
    li   $v0, 5                     # System call for reading integer
    syscall
    move $a0, $v0                   # Store the input value in $a0 (n)

    # Call recursive Catalan subroutine
    jal  catalan_recursive

    # Store result in $t0 (C(n))
    move $t0, $v0                   # Store result in $t0

    # Print result message
    li   $v0, 4                     # System call for print string
    la   $a0, result_msg            # Load address of result message
    syscall

    # Print Catalan number (C(n))
    move $a0, $t0                   # Move result to $a0
    li   $v0, 1                     # System call for print integer
    syscall

    # Exit program
    li   $v0, 10                    # System call for exit
    syscall


# Subroutine for recursive Catalan number calculation with memoization
catalan_recursive:
    # Check if the result is already in the table
    la   $t0, table                # Load address of the table
    mul  $t1, $a0, 4               # Calculate offset for table entry (4 bytes per integer)
    add  $t0, $t0, $t1             # Address of table entry
    lw   $t2, 0($t0)               # Load value from table
    beq  $t2, $zero, compute       # If value is 0, not computed, jump to compute

    # Return memoized result
    move $v0, $t2                  # Return the value in $v2
    jr   $ra                       # Return from subroutine

compute:
    # Base case: if n == 0, return 1
    li   $t2, 0                    # Load 0 into $t2
    beq  $a0, $t2, base_case       # If n == 0, jump to base_case

    # Recursive case: sum(C(i) * C(n-1-i)) for i = 0 to n-1
    addi $sp, $sp, -8              # Allocate space on the stack
    sw   $ra, 4($sp)               # Save return address
    sw   $a0, 0($sp)               # Save current n

    li   $t1, 0                    # Initialize sum = 0 (for the final result)
    li   $t2, 0                    # Initialize i = 0

recursion_loop:
    bge  $t2, $a0, end_recursion   # If i >= n, exit loop

    # Calculate C(i)
    move $a0, $t2                  # Set n = i
    jal  catalan_recursive          # Recursive call to get C(i)
    move $t3, $v0                  # Store C(i) in $t3

    # Calculate C(n-1-i)
    lw   $a0, 0($sp)               # Restore original n
    sub  $a0, $a0, $t2             # a0 = n - i
    addi $a0, $a0, -1              # a0 = n - 1 - i
    jal  catalan_recursive          # Recursive call to get C(n-1-i)
    move $t4, $v0                  # Store C(n-1-i) in $t4

    # Multiply C(i) * C(n-1-i) and add to sum
    mul  $t5, $t3, $t4             # t5 = C(i) * C(n-1-i)
    add  $t1, $t1, $t5             # sum += C(i) * C(n-1-i)

    # Increment i and repeat
    addi $t2, $t2, 1               # i++
    j    recursion_loop             # Repeat loop

end_recursion:
    move $v0, $t1                  # Return the result in $v0

    # Store the result in the table
    la   $t0, table                # Load address of the table
    mul  $t1, $a0, 4               # Calculate offset for table entry (4 bytes per integer)
    add  $t0, $t0, $t1             # Address of table entry
    sw   $v0, 0($t0)               # Store the result in table

    # Restore registers and return
    lw   $ra, 4($sp)               # Restore return address
    lw   $a0, 0($sp)               # Restore original n
    addi $sp, $sp, 8               # Clean up stack
    jr   $ra                       # Return from subroutine

base_case:
    li   $v0, 1                    # Return 1 (C(0) = 1)
    la   $t0, table                # Load address of the table
    mul  $t1, $a0, 4               # Calculate offset for table entry
    add  $t0, $t0, $t1             # Address of table entry
    sw   $v0, 0($t0)               # Store result in table
    jr   $ra                       # Return from subroutine
