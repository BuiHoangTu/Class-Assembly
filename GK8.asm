.data 
	buffer: .space 40
	end_buff: .asciiz
	num_of_students : .asciiz "enter number of students : "
	enter_name : .asciiz "enter your name : "
	enter_score: .asciiz "enter your score : "
	enter: .asciiz "\n"
	
.text

	#save number of students
	li $v0, 4
	la $a0, num_of_students
	syscall
	li $v0,5 #read number of students
	syscall
	add $t0,$0,$v0 #t0 is number of students : n
	#--------------------------------------------------
	# procedure memory allocate
	# register:
		# $t2 bytes of a unit
		# $t3 amount of memory to allocate
		# $s0 pointer point to head of point array
		# $s1 pointer point to head of string array
	#--------------------------------------------------
	# array of point
	li $t2,-4
	mult $t0,$t2
	mflo $t3 #number of stack needed for point
	add $sp,$sp,$t3
	add $s0,$sp,$0 #head of point array
	#array of name	
	li $t2,-40
	mult $t0,$t2
	mflo $t3 #number of stack needed for name
	add $sp,$sp,$t3
	add $s1,$sp,$0 #head of name array
	
	#--------------------------------------------------
	# procedure input, loop n times
	# register:
		# $t2 index of students
		# $s2 pointer point to array
		# $s3 pointer point to string
	#--------------------------------------------------
	li $t2,0
	add $s2,$0,$s0 #move pointer of point
	add $s3,$0,$s1 #move pointer of string
	Loop:
		addi $t2,$t2,1
		bgt $t2,$t0,end_inp #for i : 1->20, t2:index
		nop

		#print enter line
		li $v0, 4
		la $a0, enter_name 
		syscall 
		
		li $v0,8        #take in input
		add $a0, $s3,$0  #load byte space into array pointer
		li $a1, 40      # max length
		syscall
		
		#-------------------------------------------------------
		# procedure check input point
		# registers:
			# $t1 : register check for entered point > 10
			# $t3 : register check for entered point < 0
			# $t4 : register check for entered point < 0 or >10
		#-------------------------------------------------------
		re_score:
			li $v0,4
			la $a0, enter_score
			syscall
			
			li $v0,5 #read int
			syscall
			sgt $t1,$v0,10
			sgt $t3,$0,$v0
			add $t4,$t1,$t3
			bne $t4,$0, re_score
			nop
			#if pass both, save to point array
		sw $v0, 0($s2)	
		
		#move pointer, index
		addi $s3,$s3,40
		addi $s2,$s2,4
		
		j Loop #for i : 1->n
		nop
	end_inp: 
	
	
	#sort from here
	#-------------------------------------------------------
	# procedure sort (descending selection sort using pointer)
	# register:
		# $t1 index of students
		# $s2 pointer point to array
		# $s3 pointer point to string
		# $t3 min of unsorted part
		# $t6 current point
		# $t8,$t7 tmp for switching 
	#-------------------------------------------------------
	li $t1,0
	add $s2,$0,$s0 #move pointer of point
	add $s3,$0,$s1 #move pointer of string
	sort: 
		beq $t1,$t0,done_sort
		lw $t3,0($s2) #min = point[0]
		add $t2,$t1,$0
		# stack move 
		add $t5,$s2,$0
		add $t4,$s3,$0
		bb_loop:
			#a[j] move
			addi $t5,$t5,4
			addi $t4,$t4,40
			addi $t2,$t2,1
			
			beq $t2,$t0,done_bb
			lw $t6,0($t5) #this (a[i])
			slt $t7, $t6,$t3
			bne $t7,$0,bb_loop
			## switch
			#switch point 
			add $t8,$t6,$0
			add $t6,$t3,$0
			add $t3,$t8,$0
			sw $t3,0($s2)
			sw $t6,0($t5) 		
			li $s6,0
			#switch name
			switchloop:
				add $s5,$s3,$s6 #index 1
				add $s4,$t4,$s6 #index 2
				lw $t7,0($s5) #t7 to change first
				lw $t8,0($s4) #t8 buffer
				sw $t7,0($s4)
				sw $t8 0($s5)
				addi $s6,$s6,4
				beq $s6,40,switch_out
				nop
				j switchloop
				nop
				switch_out:
			
		done_bb:
		addi $t1,$t1,1
		addi $s2,$s2,4 #next position on stack
		addi $s3,$s3,40
		j sort
	done_sort:
	#--------------------------------------------------
	# procedure print, loop n times
	# register:
		# $t1 index of students
		# $t4 pointer point to array
		# $t5 pointer point to string
	#--------------------------------------------------
	li $t1,0
	add $t4,$0,$s0 #to top point
	add $t5,$0,$s1	#top string
	print_all:
		beq $t1,$t0,done_print
		nop
		#print_name
		li $v0,4
		add $a0,$0,$t5
		syscall
		
		li $v0,1 
		lw $a0, 0($t4)
		syscall
		
		li $v0,4
		la $a0,enter
		syscall
		
		addi $t1,$t1,1
		addi $t4,$t4,4
		addi $t5,$t5,40
		j print_all
		nop
	done_print:
		
			
				
					
						
	
