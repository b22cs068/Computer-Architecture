.data
regular_hours: .asciiz"Enter the number of regular hours worked."
overtime_hours: .asciiz"Enter the number of overtime hours worked."
hourly_wage: .asciiz" Enter the hourly wage."
gross_salary_message: .asciiz"Gross Salary:"
deduction_msg: .asciiz"Total Deduction:"
net_salary_msg: . asciiz"Net Salary"
newline: .asciiz"\n"

tax_percentage: .word 8
insurance_percentage: .word 14

 
.text
.globl main

main:

employee_loop:
#printing the promt message stored in regular_hours
  li $v0, 4
  la $a0, regular_hours
  syscall
# reading the integer value from the user for the number of regular hours worked
  li $v0, 5
  syscall
  move $t0, $v0
#printing the promt message stored in overtime_hours 
  li $v0, 4
  la $a0, overtime_hours
  syscall
  
#read overtime_hours
  li $v0, 5
  syscall
  move $t1,$v0
  
 #printing the prompt message stored in hourly_wage
 li $v0,4
 la $a0, hourly_wage
 syscall
 
#read value for hourly wages
 li $v0, 5
 syscall
 move $t2, $v0
 
 #calculate regular salary
 #regular salary = hourly wage * regular_hours
 
   mul $t3, $t2, $t0
   
#calculating overtime pay
   mul $t4,   