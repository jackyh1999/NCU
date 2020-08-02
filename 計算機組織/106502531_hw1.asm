	.text
	# $t0 = temp of input, $t1 = remainder, $t2 = array index, $t3 = $t2 * 4, $t4 = 10
	# $s0 = input, $s1 = array's ptr, $s2 = content of array, $s3 = a boolean variable
	.globl main
main:	
	li $t2,-1	# $t2 = array index
	li $t4,10	# $t4 = 10 (for calculate)
	li $s3,0	# $s3 = a boolean variable (false)
	la $s1,prime_array	# $s1 = offset array
	
	li $v0,5	# read int
	syscall
	move $s0,$v0	# $s0 = input int
	
check:
	beq $t2,3,check_emirp	# if $t2 == 3, goto (label)check_emirp
	
	addi $t2,$t2,1	# $t2 ++
	sll $t3,$t2,2	# $t3 = index*4(word's size)
	add $s1,$s1,$t3	# $s1 += $t3 
	lw $s2,($s1) 	# $s2 = int($s1)
	
	divu $s0, $s2	# $s0 / $s2
	mfhi $t1	# $t1 = remainder
	beq $s0,$s2,prime	# if input is in prime array, goto (label)prime
	beq $t1,$zero,check_not_prime	# if remainder == 0, goto (label)check_not_prime
	bne $t1,$zero,check	# if remainder != 0, loop check 
	
check_emirp:
	beq $s3,1,emirp	# if $s3 == true,  goto (label)emirp
			
	li $s3,1	# $s3 = true(is Prime)
	li $t2,-1	# initialize $t2, $s1
	la $s1,prime_array
	
	divu $s0,$t4	# $s0 / 10 
	mfhi $t1	# $t1 = remainder
	mflo $t3	# $t3 = quotient
	li $s0,0	# initialize $s0 = 0
	mult $t1,$t4
	mflo $t1
	add $s0,$t1,$t3	# $s0 = remainder*10 + quotient
	
	j check		# check whether $s0 's inverse is a prime
	
check_not_prime:
	beq $s3,1,prime	# if $s0 is a prime but its inverse isn't a prime, goto (label)prime
	j not_prime 	# else it's not a prime, so goto (label)not_prime
	
not_prime:
	li $v0,4	# print string "not prime\n"
	la $a0,not_prime_str
	syscall
	li $v0,10
	syscall
	
prime:
	li $v0,4	# print string "Prime\n"
	la $a0,Prime_str
	syscall
	li $v0,10
	syscall
	
emirp:
	li $v0,4	# print string "emirp\n"
	la $a0,emirp_str
	syscall
	li $v0,10
	syscall
	
	.data
prime_array: 	.word 2, 3, 5, 7
Prime_str:	.asciiz "Prime\n"
not_prime_str:	.asciiz "not prime\n"
emirp_str:		.asciiz "emirp\n"
