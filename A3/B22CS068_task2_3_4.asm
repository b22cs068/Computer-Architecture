.data
   str1: .space 64 # Reserved 64 bytes space for the input string
   prompt: .asciiz "Enter a String: "
   length_msg: .asciiz "Length= "
   reverse: .space 64
   length: .word 0 #label for storing length initialised to zero
   print_isPalindrome_msg: .asciiz "P"
   print_isNotPalindrome_msg: .asciiz "NP"
   reversed_word_msg: .asciiz "Reversed Word: "
   newline:.asciiz "\n" #string containing newline
   

.text
.globl main
main:
   #INPUT the string
   
   la $a0, prompt # Load the address of the prompt message into $a0
   li $v0, 4   # Print string syscall
   syscall     #execute the syscall
   
   la $a0, str1 #Load address of str1 to $a0
   li $a1, 64   #maximum input length
   li $v0, 8  #syscall for reading a string
   syscall    #executing syscall
   
   la $a0, newline  #add address of newline to $a0 register
    li $v0, 4 #syscall for printing string
    syscall #execute syscall
   
   
   la $t0, str1  #load address of str1 into $t0
   li $t1, 0     #initialise the counter to zero
   
   
   #SUBTASK 4: FIND LENGTH OF STRING
   find_length: #loop begin 
     lb $t2, 0($t0) # load byte into $t2
     beq $t2, $zero, end_length #check if loaded byte is null
     nop
     addi $t0, $t0, 1 #if not null move to the next byte address
     addi $t1, $t1,1 #increment the counter by 1
     j find_length #repeat until null is reached
     
   end_length: #on reaching null
    add $t1,$t1,-1 #asubtract one as it has counted null 
    la $t3, length  #load address of label 'length' into $t3
    sw $t1, 0($t3)  #store the length at the given address
    
    
    #print the length of the string
    la $a0, length_msg # load the adress of the length message
    li $v0, 4 #syscall for printing string
    syscall  #executing syscall
    
    li $v0, 1  #load the print integer syscall code into $v0
    move $a0,$t1  #move the string length from $t1 to $a0
    syscall  #execute syscall for printing integer
    
    #add newline
    la $a0, newline  
    li $v0, 4
    syscall
    
    
    #SUBTASK 3: REVERSE STRING
    #reverse
    la $t0 , str1  #load address of str1 to $t0
    add $t2, $t0, $t1 #add the length of the string to the base address of string
    addi $t2, $t2, -1 #point to the last character
    move $t4, $t1 #move the length of string to $t4
    la $t5,reverse  #load the address to store the reverse word in $t5
    
    reverse_string: #loop
    beq $t4, $zero, end_reverse # if entire string is reversed then end the loop 
    nop
    lb $t3, 0($t2) #load thge last character into $t3
    sb $t3, 0($t5) #store the last character at $t5 address
    addi $t5, $t5,1 # move to the next byte in reversed word
    addi $t4, $t4, -1 #decrement the counter
    addi $t2, $t2, -1 #move to the previous character in the original string
    j reverse_string #iterate again
    
     sb $zero, 0($t5) #null terminated reversed string
     end_reverse: #when the loop terminates
     la $a0, reversed_word_msg #load the address of the message reverse word
     li $v0, 4 #syscall for printing string
     syscall #execute syscall
     
     la $a0, reverse #load address for storing the reverse word at label 'reverse'
     li $v0, 4 #syscall for printing string
     syscall #execute syscall
     
     #newline
     la $a0, newline 
     li $v0, 4
     syscall
     
     #SUBTASK 2: CHECK IF PALINDROME
     #palindrome
     
     la $t0, str1  #load address of str1 into $t0
     la $t1, reverse #load reverse string from reverse to $t1
     la $t2, length #load length of string fron length to $t2
     li $t5, 0 # initialising the loop counter to zero
     lw $t6, 0($t2) #load length of string into $t6
    
     palindrome: #loop
     lb $t3, 0($t0)  #load the current character of the original string into $t3
     lb $t4, 0($t1)     #load the current character of the reverse string into $t4
     bne $t4,$t3, not_Palindrome  #check is both the character are equal, if not then exit the loo
     nop
     addi $t5, $t5, 1  #increment the counter by 1
     addi $t0, $t0,1  #move to the next byte address of the original string
     addi $t1, $t1,1  #move to the next byte address of the reverse string
     bne $t5, $t6, palindrome # if the loop counter is not equal to the length of the string then repeat the loop else exit
     nop
     #if all characters are equal
     la $a0, print_isPalindrome_msg #print meassage address
     li $v0, 4  #syscall for printing string
     syscall #execute syscall
     j end_program #end the program
    
     not_Palindrome: #if the characters are not equal exit the loop
     
     la $a0, print_isNotPalindrome_msg #load the print message address
     li $v0, 4 #syscall for printing string
     syscall #execute syscall
          
     end_program: #end program
     li $v0, 10 #load the exit syscall code into $v0
     syscall #execute the syscall to terminate the program
 
