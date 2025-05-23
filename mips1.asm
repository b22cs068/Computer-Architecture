.data 
result_msg: .asciiz "The result is:"

.text
.globl main
main:
       li $t0,10
       li $t1,5
       add $t2,$t0,$t1
       
       la $a0, result_msg
       li $v0,4
       syscall
       
       move $a0, $t2
       li $v0, 1
       syscall
       
       mul $t3,$t1,$t0
       la $a1, result_msg
       li $v1, 4
       syscall
       
       move $a1,$t3
       li $v1,1
       syscall