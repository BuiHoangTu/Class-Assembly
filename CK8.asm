.eqv buf_len 5000
.eqv disk_size 16
.data
	inp_ms: .asciiz "Nhap chuoi ky tu : "
	#d1-3 is virture disk
	d1: .space disk_size
	d2: .space disk_size
	d3: .space disk_size
	buffer: .space buf_len
	enter: .asciiz "\n"
	error_length: .asciiz "Do dai chuoi khong hop le! Nhap lai.\n"
	ms: .asciiz "Try again?"
	comma: .asciiz ","
#CLI design
	m: .ascii "      Disk 1                 Disk 2               Disk 3\n"
	m2: .asciiz "----------------       ----------------       ----------------\n"
	m3: .asciiz "|      "
	mspace: .asciiz "      "
	mopen: .asciiz "[[ "
	mclose: .asciiz "]]         "

#static var
	#s6 inp length
	#s5 inp length :8 => so lan lap 	
	#s0 buffer address

.text
j main 
nop 

#-----------------------------print block layer in disk------------------------------
	# procedure print_disk 
	# @param_in
		# $a0 : address of disk 1
	# registers : $s4
#------------------------------------------------------------------------------------
print_disk: 
	add $s4,$0,$a0
	
	li $v0, 4
	la $a0, m3 #left border
	syscall

	#print 4 chars
		li $v0, 11
		lb $a0, 0($s4)
		syscall
		lb $a0, 1($s4)
		syscall
		lb $a0, 2($s4)
		syscall
		lb $a0, 3($s4)
		syscall

	li $v0, 4
	la $a0, mspace
	syscall 
	la $a0, m3
	syscall

	jr $ra 
	nop
#-----------------------------print backup block in disk------------------------------
	# procedure print_backup 
	# @param_in
		# $a0 : address of disk 1
	# registers : $s4
#------------------------------------------------------------------------------------
print_backup: 
	add $s4,$0,$a0
	
	li $v0, 4
	la $a0, mopen #left border
	syscall

	#print hex
	li $v0, 34
	lw $a0, 0($s4)
	syscall 

	li $v0, 4
	la $a0, mclose
	syscall  


	jr $ra 
	nop

#--------------------main--------------------------------------------------------------

main:
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


#------------------------------mo phong RAID 5-------------------------------

split1:	
	add $t6, $0, $0	# so byte da dung (4 byte) so byte = buffer.len => end
	add $t5,$0,$0 # o nao chua backup

	#loaded disk address
	la $s1, d1 
	la $s2, d2
	la $s3, d3

print11:
	li $v0, 4
	la $a0, m #print cli
	syscall

add $t0, $s0,$0
b11:	
	lw $t1, 0($t0) #read block 1 from buffer
	lw $t2, 4($t0) #read block 2
	xor $a3, $t1, $t2 # backup
	#save to disk
		bne $t5, 0, bd12
		nop 
		#t5 ==0 => backup in disk3
		sw $t1, ($s1) #store in disk1
		sw $t2, ($s2) #store in disk 2
		sw $a3, ($s3) #store bk in 3
		j end_save
		nop
	bd12: #t5 != 0
		bne $t5,2,bd1
		nop
		# t5 == 2 => backup in disk 2
		sw $t1, ($s1) #data in disk1
		sw $a3, ($s2) #bk in disk 2
		sw $t2, ($s3) #dt in d3
		j end_save
		nop
	bd1:
		# t5 !=0,2 => t5 == 1 => backup in disk 2
		sw $a3, ($s1) #bk in disk1
		sw $t1, ($s2) #dt in disk 2
		sw $t2, ($s3) #dt in d3
	end_save:
#print d1 
	add $a0, $0, $s1 
	la $ra,endpd1
	beq $t5,1, print_backup
	nop
	j print_disk
	nop 
endpd1:

#print d2 
	add $a0, $0, $s2
	la $ra,endpd2
	beq $t5,2, print_backup
	nop
	j print_disk
	nop 
endpd2:

#print d3 
	add $a0, $0, $s3
	la $ra,endpd3
	beq $t5,0, print_backup
	nop
	j print_disk
	nop 
endpd3:

# next block of all disk
	addi $t0, $t0, 8 
	addi $s1, $s1, 4
	addi $s2, $s2, 4
	addi $s3,$s3,4

	addi $t6, $t6, 8 
	# t5 [0,2,1,0,2,1,...]
	addi $t5, $t5, -1
	bne $t5, -1, skip 
	nop 
	addi $t5,$0,2

	skip:
	bge $t6, $s6, exit1 #used bit >= len -> exit 
	nop

	li $v0, 11
	li $a0,'\n'#CLI next line 
	syscall 

	j b11
	nop

#-------------------------------ket thuc mo phong RAID 5-----------------------------------

#try again
exit1:	
	li $v0, 50
	la $a0, ms
	syscall
	beq $a0, $0, input
	nop


#---------------------------------------------------------------------------

exit:	
	li $v0, 10
	syscall

