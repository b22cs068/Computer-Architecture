.data
prompt: .asciiz "Enter the value of n: "
result_msg: .asciiz "The nth Catalan number is: "
new_line: .asciiz "\n"

.text
main:
    # Print prompt message
    li $v0, 4
    la $a0, prompt
    syscall

    # Read integer input (n)
    li $v0, 5
    syscall
    move $t0, $v0          # Save n in $t0

    # Initialize memoization array
    addi $t1, $t0, 1       # $t1 = n + 1
    sll $t1, $t1, 3        # $t1 = 8 * (n + 1) (8 bytes per entry)
    li $v0, 9              # Syscall for sbrk (memory allocation)
    move $a0, $t1
    syscall
    move $s0, $v0          # $s0 = base address of memo array

    # Initialize memo array: C[0] = 1
    li $t2, 1
    sw $t2, 0($s0)         # C[0] = 1

    # Initialize memo array entries to 0 (for C[1] to C[n])
    li $t2, 1              # Start from index 1
    li $t3, 0              # $t3 = index for loop
    addi $t4, $s0, 8       # $t4 = base address + 8 (start of C[1])

init_loop:
    bge $t2, $t0, compute_catalan
    sw $zero, 0($t4)       # C[i] = 0
    addi $t2, $t2, 1       # i++
    addi $t4, $t4, 8       # Move to next location (8 bytes)
    j init_loop

compute_catalan:
    # Compute Catalan numbers using tabulation
    li $t2, 0              # Start i = 0

outer_loop:
    bgt $t2, $t0, print_result # If i > n, finish
    li $t3, 0              # $t3 = j

inner_loop:
    bge $t3, $t2, done_inner_loop # If j >= i, finish

    # Compute C[j] * C[i - j - 1]
    sll $t4, $t3, 3        # $t4 = j * 8 (address offset)
    add $t4, $t4, $s0      # $t4 = base address + offset
    lw $t5, 0($t4)         # Load C[j]

    sub $t6, $t2, $t3      # Compute (i - j)
    sub $t6, $t6, 1        # Compute (i - j - 1)
    bgez $t6, compute_c_i_minus_j # If i - j - 1 >= 0

    li $t7, 0              # C[i - j - 1] = 0 for invalid index
    j store_partial_result

compute_c_i_minus_j:
    sll $t7, $t6, 3        # $t7 = (i - j - 1) * 8 (address offset)
    add $t7, $t7, $s0      # $t7 = base address + offset
    lw $t7, 0($t7)         # Load C[i - j - 1]

store_partial_result:
    mul $t5, $t5, $t7      # Multiply C[j] * C[i - j - 1]
    sll $t7, $t2, 3        # $t7 = i * 8 (address offset)
    add $t7, $t7, $s0      # $t7 = base address + offset
    lw $t6, 0($t7)         # Load current C[i]
    add $t6, $t6, $t5      # Add to C[i]

    sw $t6, 0($t7)         # Store updated C[i]

    addi $t3, $t3, 1       # j++
    j inner_loop

done_inner_loop:
    addi $t2, $t2, 1       # i++
    j outer_loop

print_result:
    # Print result message
    li $v0, 4
    la $a0, result_msg
    syscall

    # Print result
    sll $t2, $t0, 3        # $t2 = n * 8 (address offset)
    add $t2, $t2, $s0      # $t2 = base address + offset
    lw $a0, 0($t2)         # Load C[n]
    li $v0, 1
    syscall

    # Print new line
    li $v0, 4
    la $a0, new_line
    syscall

    # Exit program
    li $v0, 10
    syscall
