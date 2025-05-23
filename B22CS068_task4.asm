.data
   str1: .space 64 # Reserved 64 bytes space for the input string
   prompt: .asciiz"Enter a String: "
   length_msg: .asciiz "Length= "
   reverse: .space 64
   length: .word 0 #label for storing length initialised to zero
   print_isPalindrome_msg: .asciiz "P"
   print_isNotPalindrome_msg: .asciiz "NP"
   newline:.asciiz "\n" #string containing newline
   reversed_word_msg: .asciiz "Reversed Word: "

.text
.globl main
main:
   #INPUT the string
   
   la $a0, prompt # Load the address of the prompt message into $a0
   li $v0, 4   # Print string syscall
   syscall     #execute the syscall
   
   la $a0, str1 #
   li $a1, 64
   li $v0, 8
   syscall
   
   la $a0, newline
    li $v0, 4
    syscall
   
   
   la $t0, str1  #load address of str1 into $t0
   li $t1, 0     #initialise the counter to zero
   
   
   #SUBTASK 4: 
   find_length:
     lb $t2, 0($t0)
     beq $t2, $zero, end_length
     addi $t0, $t0, 1
     addi $t1, $t1,1
     j find_length
     
   end_length:
    
    la $t3, length
    sw $t1, 0($t3)
    
    
    #print the length of the string
    la $a0, length_msg
    li $v0, 4
    syscall 
    
    li $v0, 1
    move $a0,$t1
    syscall
    
    la $a0, newline
    li $v0, 4
    syscall
    
    #reverse
    la $t0 , str1
    add $t2, $t0, $t1 #add the length of the string to the base address of string
    addi $t2, $t2, -1 #point to the last character
    move $t4, $t1
    la $t5,reverse
    
    reverse_string:
    beq $t4, $zero, end_reverse 
    lb $t3, 0($t2) #load thge last character into $t3
    sb $t3, 0($t5)
    addi $t5, $t5,1
    addi $t4, $t4, -1
    addi $t2, $t2, -1
    j reverse_string
    
     end_reverse:
     la $a0, reversed_word_msg
     li $v0, 4
     syscall 
     
     la $a0, reverse
     li $v0, 4
     syscall 
     
     la $a0, newline
     li $v0, 4
     syscall
     
     #palindrome
     
     la $t0, str1
     la $t1, reverse
     la $t2, length
     li $t5, 0 # initialising the loop counter to zero
     lw $t6, 0($t2)
    
     palindrome:
     lb $t3, 0($t0)
     lb $t4, 0($t1)     
     bne $t4,$t3, not_Palindrome
     addi $t5, $t5, 1
     addi $t0, $t0,1
     addi $t1, $t1,1
     bne $t5, $t6, palindrome
     
     #if all characters are equal
     la $a0, print_isPalindrome_msg
     li $v0, 4
     syscall
     j end_program
    
     not_Palindrome:
     
     la $a0, print_isNotPalindrome_msg
     li $v0, 4
     syscall
          
     end_program:
     li $v0, 10
     syscall
 
