# Assembly code

.data 
	Number_of_student :	.word	3
	Name:	.asciiz	"Mai Nguyen Ngoc Huy", "Bui Hoang Tu 2020054","name3 MSSV"
	Score:	.word	5, 9, 1
	
	text:     	.asciiz " Minimum score required : "
	text1:		.asciiz " \n List the names of all students who have not passed the Math exam : \n\n"
	blank:		.asciiz " "
	newline:	.asciiz "\n"
	dot:		.asciiz ". "
.text
	# ------------------------------------------------------------------------------------
	# Procedure to save the number of students and the Minimum Score required to pass the exam
	# just work with interger number only
	# Register :
	# $t0 : The number of student
	# $s0 : Pointer point to head of string array
	# $s1 : Pointer point to head of score array
	# $t5 : Minimum score required to pass the exam
	# $s3, $s4, $s5 : Temporary variable to check the input condition of minimum score required
	# ------------------------------------------------------------------------------------
	minimum_score :
		li      	$v0,	4
    		la      	$a0,	text
    		syscall
    		
		li 	$v0,	5 				# read int input
		syscall
		add	$t5,	$0,	$v0			# Save the value just entered into the register $s5
		
		addi	$s3,	$0,	11			#
		slt 	$s4, 	$t5, 	$s3			#   check the student score condition
		addi	$s3,	$0,	-1			# ( Between from 0 and 10 )
		slt	$s5,	$s3,	$t5			#
		bne	$s5, 	$s4,	minimum_score	# 
	
	#  Save the number of student and set pointers to the head of the string array and the score array
	lw	$t0,	Number_of_student
	la 	$s0,	Name
	la	$s1,	Score
	
	li      $v0,	4
    	la      $a0,	text1
    	syscall
	
	# ------------------------------------------------------------------------------------
	# Procedure to compare each student's score with the minimum score required to print the student's 
	# information with 2 nested loops
	# ------
	# Register : 
	# $t0 : The number of student
	# $s0 : Pointer point to head of string array
	# $s1 : Pointer point to head of score array
	# $t5 : Minimum score required to pass the exam
	# $t1 : index of first loop
	# $t2 : pointer point to score array
	# $t3 : index for each string of string array in the second loop
	# $t6 : Temporary variable to save the value of the compare between student's score and minimum 
	# score required
	# $a1 : Variable to print order number
	# ------------------------------------------------------------------------------------
	name_loop:
		beq 	$t1,	$t0,	exit
		lw	$t2,	0 ($s1)
		slt	$t6,	$t2,	$t5			# Compare the student's score with the minimum 
								# score required 
		
		# Procedure print the ordinal number
		beq	$t6,	$0,	print_name
		add	$a1,	$a1,	1
    			
    		li      $v0,	4				# print a blank
    		la      $a0,	blank
    		syscall
    			
    		li	$v0,	1				# print the ordinal number
    		add	$a0,	$0,	$a1
    		syscall	
    		li      $v0,	4				
    		la      $a0,	dot
    		syscall
		
		# ------------------------------------------------------------------------------
		# Procedure to print student's name by printing each letter if the student's score meets the 
		# requirements of the question paper
		# ------------------------------------------------------------------------------
		print_name:
			li	$v0,	11
    			lb      	$a0,	0($s0)			# load the current $s0's input bytes
    			add 	$t3,	$0,	$a0		# save $s0 into $t3
    			
    			beq	$t6,	$0,	cancel
    			syscall
    			
    			cancel:				
				add 	$s0,	$s0,	1	# increase the byte of current string by 1
				bne 	$t3,	$0,	print_name	# if the byte not zero, continue loop
				nop
		
		beq	$t6,	$0,	skip	
		
		li      $v0,	4				# print a blank
    		la      $a0,	blank
    		syscall
		
		li 	$v0, 	1				# read number
  		lw	$a0,	0 ($s1)				# load the score to $a0 and print
  		syscall						#
		
		li	$v0,	4				# print a new line characters
    		la      	$a0,	newline
    		syscall
    		
		skip:	add	$s1,	$s1,	4
			add 	$t1,	$t1,	1
		
		j 	name_loop
	
	exit:
