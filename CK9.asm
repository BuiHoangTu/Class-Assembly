.eqv PICTURE_ROW 16 #number of rows of picture 
.eqv D_END 21
.eqv C_START 22
.eqv C_END 41
.eqv E_START 42
.data

    #original one contain 16 strings 
    String1: .asciiz  "                                          *************\n"
    String2: .asciiz  "**************                            *3333333333333*\n"
    String3: .asciiz  "*222222222222222*                         *33333********\n"
    String4: .asciiz  "*22222******222222*                       *33333*\n"
    String5: .asciiz  "*22222*      *22222*                      *33333********\n"
    String6: .asciiz  "*22222*       *22222*      *************  *3333333333333*\n"
    String7: .asciiz  "*22222*       *22222*    **11111*****111* *33333********\n"
    String8: .asciiz  "*22222*       *22222*  **1111**       **  *33333*\n"
    String9: .asciiz  "*22222*      *222222*  *1111*             *33333********\n"
    String10: .asciiz "*22222*******222222*  *11111*             *3333333333333*\n"
    String11: .asciiz "*2222222222222222*    *11111*              *************\n"
    String12: .asciiz "***************       *11111*\n"
    String13: .asciiz "      ---              *1111**\n"
    String14: .asciiz "    / o o \\             *1111****    *****\n"
    String15: .asciiz "    \\   > /              **111111***111*\n"
    String16: .asciiz "     -----                 ***********    tubh.hust.edu.vn\n"
    ImgArray: .space 64
    Message0: .ascii  "------------Menu-----------\n"
    Phan1:    .ascii  "1. In ra chu\n"
    Phan2:    .ascii  "2. In ra chu rong\n"
    Phan3:    .ascii  "3. Thay doi vi tri\n"
    Phan4:    .ascii  "4. Doi mau cho chu\n"
    Thoat:    .ascii  "5. Thoat\n"
    Nhap:     .asciiz  "Nhap gia tri: "
    ChuD:     .asciiz  "Nhap mau cho chu d(0->9): "
    ChuC:     .asciiz  "Nhap mau cho chu c(0->9): "
    ChuE:     .asciiz  "Nhap mau cho chu e(0->9): "
.text

#store row address into ImgArray
addi $s0, $0, 1    #bien dem =0 
la $s1, ImgArray
la $a0, String1
StoreArray:
    sw $a0, 0($s1)        
	beq $s0, PICTURE_ROW, main
    NextStr:
       	lb  $t0,0($a0)
       	addi $a0, $a0, 1
       	bne $t0,$0,NextStr
       	nop
        	
    addi $s0, $s0, 1
    addi $s1, $s1, 4

    j StoreArray
    nop

#procedure print_char
#detect color and change it, print line  
#@param_in 
#   $s1:address 
#   $a1:color (number)
#   $a2:line_len
#registers : t0
#-----------------------------------------------------
print_char:

li $v0,11
add $t0,$0,0 #length counter
pcloop:
    bge $t0,$a2,endpc
    lb $a0,0($s1)
	blt $a0,0x30, pcprint 
	bgt $a0,0x39,pcprint
    nop 
    addi $a0,$0,$a1
    pcprint: syscall
    addi $t0,$t0,1
    addi $s1,$s0,1
    j pcloop
    nop
jr $ra 
nop

#procedure change_color
#change character color 
#@param_in
#   $a0,$a1,$a2 color of D,C,E
#use registers 
#   $t0,$t1,$t2
#------------------------------------------------------------------
change_color:
    addi $s0, $0, 0    #bien dem tung hang =0
    la $s2,String1    # $s2 la dia chi cua string1
        
    Loop2:    
	beq $s0,PICTURE_ROW, main #all rows are printed
	nop    
    CheckBorder:
        lb $t2, 0($s2)    # $t2 luu gia tri cua tung phan tu trong string1
	beq $t2, $0, End2 # if t2 = \0, it is end of row
	nop
	
	#check colored 
	li $t5,0x30 #ascii of 0
	slt $t6,$t2,$t5
	li $t5,0x39 #ascii of 9
	sgt $t7,$t2,$t5
	add $t7,$t6,$t7 #if $t2 is not a number => $t7 ==1
	beq $t7, 1, PrintBorder #neu t2 != number thi in luon
	nop
    IsNotBorder:
	addi $t2, $0, 0x20 # thay doi $t2 thanh dau cach neu khong phai la vien
    PrintBorder:
    li $v0, 11 # print char
    add $a0, $t2, $0 
    syscall
    
    addi $s2 $s2 1 #sang chu tiep theo
    j CheckBorder
    nop 
End2:     
    addi $s2,$s2,1 #sang hang tiep theo
    addi $s0 $s0, 1 # tang bien dem hang += 1
    j Loop2
    nop
#----------------------------------------------------------------------------------

main:
    la $a0, Message0    # nhap menu
    li $v0, 4
    syscall
    
    li $v0, 5 #chon menu
    syscall
    
    #switch-case
    #Case1
        beq $v0 1 Menu1
        nop
    #Case2
        beq $v0 2 Menu2
        nop
    #Case3
        beq $v0 3 Menu3
        nop
    #Case4
        beq $v0 4 Menu4
        nop
    #Case5:
        beq $v0 5 Exit
        nop
    #defaul
        j main
        nop
#---------------------------------in ra binh thuong-------------------------------   
Menu1:    
    addi $s0, $0, 0    #bien dem =0   
    la $s1,ImgArray
        li $v0, 4
    Loop1: 
        lw $a0, 0($s1)       
        syscall
        addi $s0, $s0, 1
        addi $s1,$s1,4
        beq $s0, PICTURE_ROW, main
        nop
        j Loop1
        nop

#------------------------ chi in ra vien cac chu------------------------------------
Menu2:     
    addi $s0, $0, 0    #bien dem tung hang =0
    la $s2,String1    # $s2 la dia chi cua string1
        
    Loop2:    
	beq $s0,PICTURE_ROW, main #all rows are printed
	nop    
    CheckBorder:
        lb $t2, 0($s2)    # $t2 luu gia tri cua tung phan tu trong string1
	beq $t2, $0, End2 # if t2 = \0, it is end of row
	nop
	
	#check colored 
	li $t5,0x30 #ascii of 0
	slt $t6,$t2,$t5
	li $t5,0x39 #ascii of 9
	sgt $t7,$t2,$t5
	add $t7,$t6,$t7 #if $t2 is not a number => $t7 ==1
	beq $t7, 1, PrintBorder #neu t2 != number thi in luon
	nop
    IsNotBorder:
	addi $t2, $0, 0x20 # thay doi $t2 thanh dau cach neu khong phai la vien
    PrintBorder:
    li $v0, 11 # print char
    add $a0, $t2, $0 
    syscall
    
    addi $s2 $s2 1 #sang chu tiep theo
    j CheckBorder
    nop 
End2:     
    addi $s2,$s2,1 #sang hang tiep theo
    addi $s0 $s0, 1 # tang bien dem hang += 1
    j Loop2
    nop
#################doi vi tri chu ############
Menu3:    
    addi $s0, $0, 0    #bien dem tung hang =0
    la $s1, ImgArray
    la $s2,String1 #$s2 luu dia chi cua string1
Lap2:    
    lw $s2, 0($s1) 
    beq $s0, PICTURE_ROW, End3
    #tao thanh 3 string nho
    sb $0 D_END($s2)
    sb $0 C_END($s2)

    #doi vi tri
    li $v0, 4 
    la $a0 E_START($s2) #in chu E
    syscall
    
    li $v0, 4 
    la $a0 C_START($s2) # in chu C
    syscall
    
    li $v0, 4 
    la $a0 0($s2) # in chu D
    syscall
    
    li $v0, 4 
    la $a0 66($s2)
    syscall
    # ghep lai thanh string ban dau
    addi $t1 $0 0x20
    sb $t1 21($s2)
    sb $t1 43($s2)
    sb $t1 65($s2)
    
    addi $s0 $s0 1
    addi $s2 $s2 68
    j Lap2
End3:
    addi $a0,$0,' '
    sb $a0 D_END($s2)
    sb $a0 C_END($s2)
    j main
    nop

############ doi mau cho chu ################
Menu4: 
    NhapmauD:    
        li     $v0, 4        
        la     $a0, ChuD
        syscall
    
        li     $v0, 5        # lay mau cua ki tu D
        syscall

        blt    $v0,0, NhapmauD
        bgt    $v0,9, NhapmauD
        nop
        addi     $s3 $v0 48    #$s3 luu mau cua chu D
    NhapmauC:
        li     $v0, 4        
        la     $a0, ChuC
        syscall
    
        li     $v0, 5        # lay mau cua ki tu C
        syscall

        blt    $v0, 0, NhapmauC
        bgt    $v0, 9, NhapmauC
        nop
        addi     $s4  $v0 48    #$s4 luu mau cua chu C
    NhapmauE:
        li     $v0, 4        
        la     $a0, ChuE
        syscall
    
        li     $v0, 5        # lay mau cua ki tu E
        syscall

        blt    $v0, 0, NhapmauE
        bgt    $v0, 9, NhapmauE
        nop
        addi     $s5 $v0 48    #$s5 luu mau cua chu E
PrintColor:
    la $s0, ImgArray    
    li $s6,0 #line counter 
EachLine:
    beq $s6,PICTURE_ROW,main
    lw $s1,0($s0)
    InD:
        
        add $a1, $s3,$0 #color of D
        addi $v0,$0, D_END
        sub $a2, $v0,$s1

        jal print_char
        
        addi $s1,$s1,1 #next char -> into C

    InC:
        
        add $a1, $s4,$0 #color of C
        addi $v0,$0, C_END
        addi $a2, $v0,- C_START

        jal print_char
        
        addi $s1,$s1,1

    InE:
        
        add $a1, $s4,$0 #color of E
        lw $v0,4($s0)
        addi $a2, $v0,- E_START

        jal print_char
        
    addi $s0,$s0,4
    addi $s6,$s6,1

Exit:
