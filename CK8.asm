.eqv buf_len 5000
.eqv disk_size 4
.data
	inp_ms: .asciiz "Nhap chuoi ky tu : "
	hex: .byte '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f' 
	#d1-3 is virture disk
	d1: .space disk_size
	d2: .space disk_size
	d3: .space disk_size
	array: .space 32
	buffer: .space buf_len
	enter: .asciiz "\n"
	error_length: .asciiz "Do dai chuoi khong hop le! Nhap lai.\n"
	ms: .asciiz "Try again?"
	comma: .asciiz ","
	#CLI design
		m: .ascii "      Disk 1                 Disk 2               Disk 3\n"
		m2: .asciiz "----------------       ----------------       ----------------\n"
		m3: .asciiz "|     "
		m4: .asciiz "     |       "
		m5: .asciiz "[[ "
		m6: .asciiz "]]       "

#static var
#	s6 inp length
#	s5 inp length :8 => so lan lap 	

.text
	la $s0, buffer
	
input:	
	li $v0, 4		# thong bao nhap chuoi (ten)
	la $a0, inp_ms
	syscall

	li $v0, 8 #save string to buffer
	la $a0, buffer
	li $a1, buf_len
	syscall


#-----------------------kiem tra do dai co chia het cho 8 khong--------------------------
length: 
	addi $t3, $0, 0 	# t3 = length
	add $t1,$0,$s0 #t1 = buffer
	find_end: 
		lb $t2, 0($t1) 		# t2 = buffer[i]
		beq $t2, 10, test_length 	# t2 = '\n' ket thuc xau
		nop
		addi $t3, $t3, 1 	# length++
		addi $t1, $t1, 1	# next in buffer i++
		j find_end
		nop

	test_length:
		srl $s5,$t3,3 #len :8 => so lan lap
		add $s6,$t3,$0
		andi $t1, $t3, 0x00000007 # xoa het cac bits cua $t3 ve 0, chi giu lai 3 bits cuoi
		beq $t1, $0, split1 # 3 byte cuoi bang 0 => ::8
		nop
		error1:	
		li $v0, 4
		la $a0, error_length
		syscall
		j input
#-------------------------------ket thuc kiem tra do dai----------------------------------


#----------------------------------------------------------

#------------------------------mo phong RAID 5-------------------------------
#-----------------------xet 6 khoi dau----------------------
#----------------lan 1: luu vao 2 khoi 1,2; xor vao 3-------
split1:	
	addi $t6, $0, 0	# so byte da dung (4 byte)

	#loaded disk address
	la $s1, d1 
	la $s2, d2
	la $s3, d3

print11:
	li $v0, 4
	la $a0, m #print cli
	syscall

	li $v0, 4
	la $a0, m3 #left vertical slash 
	syscall
add $t0, $s0,$0
b11:	
	lw $t1, 0($t0) #read block 1 from buffer
	sw $t1, ($s1) #store into disk1
b21:	
	lw $t2, 4($t0) #read block 2
	sw $t2, ($s2) #store in disk 2
b31:	
	xor $a3, $t1, $t2
	sw $a3, ($s3)
	# next block of all disk
	addi $t0, $t0, 8
	addi $s1, $s1, 4
	addi $s2, $s2, 4
	addi $s3,$s3,4

	addi $t6, $t6, 8
	bge $t6, $s6, exit1 #used bit >= len -> exit 
	nop
	j b11
	nop
#--------------------------------end 6 khoi dau---------------------------------------
	
exit1:	
	li $v0, 4
	la $a0, m2

#-------------------------------ket thuc mo phong RAID 5-----------------------------------

#-------------------------------------try again----------------------------------------
ask:
	li $v0, 50
	la $a0, ms
	syscall
	beq $a0, $0, input
	nop


#-----------------------------------end try again----------------------------------------

exit:	
	li $v0, 10
	syscall