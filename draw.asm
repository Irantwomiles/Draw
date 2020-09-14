#############################################################################################
#
# Montek Singh
# COMP 541 Final Projects
# Apr 5, 2018
#
# This is a MIPS program that tests the MIPS processor and the VGA display,
# using a very simple animation.
#
# This program assumes the memory-IO map introduced in class specifically for the final
# projects.  In MARS, please select:  Settings ==> Memory Configuration ==> Default.
#
# NOTE:  MEMORY SIZES.
#
# Instruction memory:  This program has 150 instructions.  So, make instruction memory
# have a size of at least 256 locations.
#
# Data memory:  Make data memory 64 locations.  This program only uses two locations for data,
# and a handful more for the stack.  Top of the stack is set at the word address
# [0x100100fc - 0x100100ff], giving a total of 64 locations for data and stack together.
# If you need larger data memory than 64 words, you will have to move the top of the stack
# to a higher address.
#
#############################################################################################
#
# THIS VERSION HAS LONG PAUSES:  Suitable for board deployment, NOT for Vivado simulation
#
#############################################################################################


.data 0x10010000 			# Start of data memory

.text 0x00400000			# Start of instruction memory
main:
	lui	$sp, 0x1001		# Initialize stack pointer to the 64th location above start of data
	ori 	$sp, $sp, 0x0100	# top of the stack is the word at address [0x100100fc - 0x100100ff]
	
	#li	$fp, $sp(-4)

	###############################################
	# ANIMATE character on screen                 #
	#                                             #
	# To eliminate pauses (for Vivado simulation) #
	# replace the two "jal pause" instructions    #
	# by nops.                                    #
	###############################################

canvas_init:
	
	li	$a0, 0
	li	$a1, 0			#x
	li	$a2, 0			#y
	li	$t0, 39			#Max X 39
	li	$t1, 30			#Max Y - (1 row) 29
	
loop_outer:

	inner_loop:
		beq $a2, $t1, exit_inner
		jal putChar_atXY
		
		addi $a2, $a2, 1
		
		j inner_loop
	
	exit_inner:
	
	beq $a1, $t0, exit_loop
	addi $a1, $a1, 1
	li	$a2, 0
	
	j loop_outer
	
exit_loop:
#Color Values: 0:white, 1:red, 2:blue, 3:green, 4:yellow, 5:pink, 6:purple, 7:aqua, 8:Orange, 9:erasor

	li	$a0, 1
	li	$a1, 0			
	li	$a2, 29			
	jal putChar_atXY
	
	li	$a0, 2
	li	$a1, 1			
	li	$a2, 29			
	jal putChar_atXY
	
	li	$a0, 3
	li	$a1, 2			
	li	$a2, 29			
	jal putChar_atXY
	
	li	$a0, 4
	li	$a1, 3			
	li	$a2, 29			
	jal putChar_atXY
	
	li	$a0, 5
	li	$a1, 4			
	li	$a2, 29			
	jal putChar_atXY
	
	li	$a0, 6
	li	$a1, 5			
	li	$a2, 29			
	jal putChar_atXY
	
	li	$a0, 7
	li	$a1, 6			
	li	$a2, 29			
	jal putChar_atXY
	
	li	$a0, 8
	li	$a1, 7			
	li	$a2, 29			
	jal putChar_atXY
	
	li	$a0, 10
	li	$a1, 8			
	li	$a2, 29			
	jal putChar_atXY
	
	li	$a0, 11
	li	$a1, 9			
	li	$a2, 29			
	jal putChar_atXY
	
	li	$a0, 12
	li	$a1, 10			
	li	$a2, 29			
	jal putChar_atXY
	
	li	$a0, 13
	li	$a1, 11			
	li	$a2, 29			
	jal putChar_atXY
	
	li	$a0, 14
	li	$a1, 12			
	li	$a2, 29			
	jal putChar_atXY
	
	li	$a0, 15
	li	$a1, 13			
	li	$a2, 29			
	jal putChar_atXY
	
	li	$a0, 9
	li	$a1, 14			
	li	$a2, 29			
	jal putChar_atXY




li	$s0, 20		# X Position of the Cursor
li	$s1, 15		# Y Position of the Cursor
li	$s2, 15		# CURRENT Color Value of the cursor
li	$s3, 15		# PREV Value under cursor
li	$s4, 1		# Should cursor draw (0 no, 1 yes)
li	$s5, 20		# prev x
li	$s6, 15		# prev y
li	$s7, 0

animate_loop:
	
	li	$a0, 0
	jal	sound_off
	
	easter_egg:
	li $a1, 0		# set x to current x
	li $a2, 0		# set y to current y
	jal getChar_atXY
	
	bne	$v0, 1, end_easter_egg
	
	li $a1, 39		# set x to current x
	li $a2, 0		# set y to current y
	jal getChar_atXY

	li	$a0, 1	
	jal	put_leds
	
	bne	$v0, 2, end_easter_egg
	
	li $a1, 39		# set x to current x
	li $a2, 28		# set y to current y
	jal getChar_atXY
	
	li	$a0, 2	
	jal	put_leds
	
	bne	$v0, 3, end_easter_egg
	
	li $a1, 0		# set x to current x
	li $a2, 28		# set y to current y
	jal getChar_atXY
	
	li	$a0, 3	
	jal	put_leds
	
	bne	$v0, 4, end_easter_egg
	
	li	$a0, 4	
	jal	put_leds
	
	li	$a0, 10		# pause for 2/4 second
	jal	pause
	
	j	crazy
	
	end_easter_egg:
	
	beq $s4, 1, draw	#$s4 == 1
	j end_draw
	
	draw:
	
	move $a0, $s2		# set character value to the one selected
	move $a1, $s0		# set x to current x
	move $a2, $s1		# set y to current y
	
	jal putChar_atXY
	
	j animation_end

	end_draw:
	
	#li	$a0, 50			# pause for 2/4 second
	#jal	pause
	
	blink:
	
	beq	$s7, 1, flip
	
	li	$s7, 1
	
	move $a0, $s2		# set character value to the one selected
	move $a1, $s0		# set x to current x
	move $a2, $s1		# set y to current y
	
	jal putChar_atXY
	j end_blink
	
	flip:
	
	li	$s7, 0
	
	li $a0, 0		# set character value to the one selected
	move $a1, $s0		# set x to current x
	move $a2, $s1		# set y to current y
	
	jal putChar_atXY
	
	end_blink:
	
	animation_end:
	
	li	$a0, 25			# pause for 2/4 second
	jal	pause
	
	
	#li	$v0, 5		# Draw white cursor, switch after each animation loop


key_loop:
	jal get_key	# $v0 will be 0 if no, $v0 1-N if yes
	beq $v0, $0, animate_loop	# no key found, going back up

key1:
	bne	$v0, 1, key2
	move	$s5, $s0		# setting the prev value of x
	move	$s6, $s1		# setting the curr value of y
	
	addi	$s0, $s0, -1 		# move left
	slt	$t8, $s0, $0		# make sure X >= 0
	
	beq	$t8, $0, under_1
	li	$s0, 0	
	
	under_1:
	
	beq 	$s4, 1, skip_1
	
	move $a0, $s3
	move $a1, $s5		# set x to current x
	move $a2, $s6		# set y to current y
	jal putChar_atXY
	
	skip_1:
	
	move $a1, $s0		# set x to current x
	move $a2, $s1		# set y to current y
	jal getChar_atXY
	
	move 	$s3, $v0

			# else, set X to 0
	j	animate_loop

key2:
	bne	$v0, 2, key3
	move	$s5, $s0		# setting the prev value of x
	move	$s6, $s1		# setting the curr value of y

	addi	$s0, $s0, 1 		# move right
	slti	$1, $s0, 40		# make sure X < 40
	
	bne	$1, $0, under_2
	li	$s0, 39	
	
	under_2:
	
	beq 	$s4, 1, skip_2
	
	move $a0, $s3
	move $a1, $s5		# set x to current x
	move $a2, $s6		# set y to current y
	jal putChar_atXY
	
	skip_2:
	
	move $a1, $s0		# set x to current x
	move $a2, $s1		# set y to current y
	jal getChar_atXY
	
	move 	$s3, $v0
	
		# else, set X to 39
	j	animate_loop

key3:
	bne	$v0, 3, key5
	
	move	$s5, $s0		# setting the curr value of x
	move	$s6, $s1		# setting the prev value of y
	
	addi	$s1, $s1, -1 		# move up
	slt	$1, $s1, $0		# make sure Y >= 0
	
	beq	$1, $0, under_3
	li	$s1, 0			# else, set Y to 0
	
	under_3:
	
	beq 	$s4, 1, skip_3
	
	move $a0, $s3
	move $a1, $s5		# set x to current x
	move $a2, $s6		# set y to current y
	jal putChar_atXY
	
	skip_3:
	
	move $a1, $s0		# set x to current x
	move $a2, $s1		# set y to current y
	jal getChar_atXY
	
	move 	$s3, $v0
	
	j	animate_loop

key5:
	bne	$v0, 5, key6
	
	beq 	$s4, 1, set_zero
	
	li	$s4, 1
	
	li	$a0, 25			# pause for 2/4 second
	jal	pause
	
	j animate_loop
	
	set_zero:
	li	$s4, 0
	
	enter_release:
	
	jal get_key
	
	bne $v0, 8, enter_release
	
	j	animate_loop

key6:
	bne	$v0, 6, key4
	
	bne	$s1, 28, animate_loop	# check if Y is 1 before the last row (29 is max)

	slti	$t7, $s0, 15  		
	beq	$t7, 0, animate_loop	# if x < 16 (Where my colors are)
	
	move	$a1, $s0
	move	$a2, $s1
	addi	$a2, $a2, 1
	
	jal getChar_atXY
	
	li	$a0, 1
	sll	$a0, $v0, 12
	jal put_sound
	
	li	$a0, 25			# pause for 2/4 second
	jal	pause
	
	beq $v0, 9, erasor
	
	addi 	$s2, $v0, 0
	j	animate_loop
	
	erasor:
	li	$s2, 0	# If the erasor is chosen, set the cursor to the white character
	j	animate_loop
	


key4:
	bne	$v0, 4, key_loop		# read key again
	
	move	$s6, $s1		# setting the prev value of y
	move	$s5, $s0		# setting the curr value of x
		
	addi	$s1, $s1, 1 		# move down
	slti	$1, $s1, 28		# make sure Y < 29
	
	bne	$1, $0, under_4
	li	$s1, 28			# else, set Y to 29
	
	under_4:
	
	beq 	$s4, 1, skip_4
	
	move $a0, $s3
	move $a1, $s5		# set x to current x
	move $a2, $s6		# set y to current y
	jal putChar_atXY
	
	skip_4:
	
	move $a1, $s0		# set x to current x
	move $a2, $s1		# set y to current y
	jal getChar_atXY
	
	move 	$s3, $v0
	
	j	animate_loop

						
crazy:											
	li	$a0, 0
	li	$a1, 0			#x
	li	$a2, 0			#y
	li	$t0, 39			#Max X 39
	li	$t1, 29			#Max Y - (1 row) 29
	
crazy_loop_outer:

	crazy_inner_loop:
	
		beq $a2, $t1, crazy_exit_inner
		
		jal	pause
		
		addi	$a0, $a0, 1
		
		beq	$a0, 14, reset_color
		
		jal putChar_atXY
		
		addi $a2, $a2, 1
		
		
		j crazy_inner_loop
		
		reset_color:
	
		li	$a0, 1
		
		jal putChar_atXY
		
		addi $a2, $a2, 1
		
		j crazy_inner_loop
	
	crazy_exit_inner:
	
	beq $a1, $t0, crazy_exit_loop
	addi $a1, $a1, 1
	li	$a2, 0
	
	j crazy_loop_outer
	
crazy_exit_loop:

li	$a0, 100
jal	pause

j canvas_init
						
				# program won't reach here, but have it for safety
end:
	j	end          	# infinite loop "trap" because we don't have syscalls to exit


######## END OF MAIN #################################################################################



.include "proc_board.asm"
