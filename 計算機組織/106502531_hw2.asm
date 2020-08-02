	.text
	# $t0, $t1 = string pointer
	# $t2, $t3 = load byte 
	# $t4, $t5 = counter
	# $s0 = user1's input, $s1 = user2's input, $s2 = user2's guess' times, $s3, $s4 = number of A,B
	.globl main
main:	
	li $s2,0	# a int variable to record user2 guess how many times
	
	li $v0,4	# print string "User1 enter the number:\n"
	la $a0,text1
	syscall	
	li $v0,8	# read string
	la $a0,user1input
	li $a1,8
	syscall
	move $s0,$a0	# save string into $s0
	
	move $t0,$s0	# save string into $t0
	sub $t0,$t0,1	# $t0 -= 1 (for legal check)
	li $t4,0	# initialize counter $t4, $t5
	li $t5,0
user_legal_check1:
	beq $t4,2,legal	# if $t0 == 2, goto (label)legal
	add $t0,$t0,1	# $t0 +=1
	add $t4,$t4,1	# $t4 +=1
	move $t1,$t0	# $t1 = $t0
	move $t5,$t4	# $t5 = $t4
user_legal_check2:
	beq $t5,3,user_legal_check1	# if $t1 == 3, goto (label) user1_legal_check1
	add $t1,$t1,1	# $t1 += 1
	add $t5,$t5,1	# $t5 +=1
	lb $t2,($t0)	# $t2 = byte($t0)
	lb $t3,($t1)	# $t3 = byte($t1)
user_legal_check3:
	bne $t2,$t3,user_legal_check2	# if $t2 != $t3, goto  (label) user1_legal_check2
					# else $s0 is illegal
illegal:
	li $v0,4	# print string "WARNING: redundant digits\n"
	la $a0,Illegal
	syscall
	li $v0,10	# exit
	syscall
legal:
	bne $s2,$zero,user2_legal
	li $v0,4	# print string "Start-------------------\n"
	la $a0,Start
	syscall
game:
	add $s2,$s2,1	# user2 guess' times += 1
	li $s3,0	# initialize A, B 's number 
	li $s4,0
	
	li $v0,4	# print string "User2 guess:\n"
	la $a0,text2
	syscall
	li $v0,8	# read string
	la $a0,user2input
	li $a1,8
	syscall
	move $s1,$a0	# save string into $s1
	
	move $t0,$s1	# save string into $t0
	sub $t0,$t0,1	# $t0 -= 1
	li $t4,0
	li $t5,0
	j user_legal_check1
user2_legal:
	move $t0,$s0	# initialize $t0, $t4,
	sub $t0,$t0,1
	li $t4,0
check1:
	beq $t4,4,result	# if $t4 == 4, goto (label)result
	li $t5,0		# initialize $t1, $t5 
	move $t1,$s1
	sub $t1,$t1,1
	add $t0,$t0,1	# $t0 += 1
	add $t4,$t4,1	# $t4 += 1
	lb $t2,($t0)	# $t2 = ($t0) 
check2:
	beq $t5,4,check1	# if $t5 == 4, goto (label)check1
	add $t1,$t1,1	# $t1 += 1
	add $t5,$t5,1	# $t5 += 1
	lb $t3,($t1)	# $t3 = ($t1)
	beq $t2,$t3,oneB	# if $t2 == $t3, goto (label)oneB
	j check2		# else goto (label)check2
oneB:
	beq $t4,$t5,oneA	# if $t4 == $t5, goto (label)oneA
	add $s4,$s4,1		# else $t4 += 1 and goto (label)check2
	j check1	
oneA:
	add $s3,$s3,1	# $t5 += 1 and goto (label)check2
	j check1
result:
	li $v0,1	# print the number of A(int)
	move $a0,$s3
	syscall
	li $v0,4	# print string "A"
	la $a0,A
	syscall
	li $v0,1	# print the number of B(int)
	move $a0,$s4
	syscall
	li $v0,4	# print string "B"
	la $a0,B
	syscall
	beq $s3,4,win	# if the number of A == 4, goto (label)win
	beq $s2,8,lose	# if user2 tries over 8 times, goto (label)lose
	la $a0,endline
	syscall
	j game		# user2 try again
win:
	la $a0,Win	# print string " You win!\n"
	syscall
	li $v0,10
	syscall
lose:
	la $a0,Lose	# print string " You lose.\n"
	syscall
	li $v0,10	
	syscall
	
	.data
text1:	.asciiz "User1 enter the number:\n"
Start:	.asciiz "Start-------------------\n"
text2:	.asciiz "User2 guess:\n"
A:	.asciiz "A"
B:	.asciiz "B"
Win:	.asciiz " You win!\n"
Lose:	.asciiz " You lose.\n"
endline:	.asciiz "\n"
Illegal:	.asciiz "WARNING: redundant digits\n"
user1input:	.space 8
user2input:	.space 8
