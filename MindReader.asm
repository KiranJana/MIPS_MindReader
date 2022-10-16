# Class: 		CS 2340.501
# Date:			Fall 2021
# Topic:		Number gussing game
# Team:			Marcos Murillo | Hari Kiran Jana | Anthony Ngo | Santana Lopez

.data
	# Print instructions
	printInstruc:	 		.asciiz 		"Select a number between 1 and 63, and the Mind Reader will reveal your number.\n"
	printInstruc2: 			.asciiz 		"If your number is displayed enter 'Y', if not enter 'N'\n"
	intro:				    .asciiz 		"\nHi! Do you want to play a game (y / n): "
	p2:				        .asciiz 		"Is your number on the card? (y / n): "
	wrongInput:			    .asciiz 		"Please enter correct input\n\n"
	finalRes: 			    .asciiz 		"You number is: "

	# Helper print staments
	printSpace: 			.asciiz 		" |   "
	newLine:	 		.asciiz 		"\n"

	# Holds numbers 
	storeAns:			.space 			256
	buffer: 			.word			0


.text
	main:
		# Start of program, will print "Hi! Do you want to play a game"
		jal 		startPro

		# After user enters game this will print instructions
		li 		$v0, 		4
		la 		$a0, 		printInstruc
		syscall
		
		la 		$a0, 		newLine
		li 		$v0, 		4
		syscall

		# In order to create random number (1,2,3,4,5,6)
		li 		$a1, 		7
		li 		$v0,		42
		syscall 
		
		addi 	$t1, 		$a0, 			1
		li 		$a1, 		2 					
		li		$v0, 		42
		syscall 								
		
		li 		$t2, 		5
		beq 	$a0, 		$zero, 		cardMath
		

	nextInLine:
		move 	    $t1, 		$a0
		and 		$t2, 		$a0, 			$a1 		
		beq 		$t2, 		$zero, 		    moveToNext
		beq 		$t2, 		$a1, 			moveToNext
		addi 		$t1, 		$t1,	 		8 		
	moveToNext:
		srl 		$v0, 		$t1, 			1 		
		jr 		    $ra
		
	cardMath:
		li 		$t2, 		3
		move 	$a0, 		$t1
		move 	$a1,		$t2
		jal 	inOrder
		move 	$t9, 		$v0
	
	# Prints final prediction result 
	cardDis:
		la 		$a0, 		newLine
		li 		$v0, 		4
		syscall

		li 		$v0, 		4
		la 		$a0, 		finalRes
		syscall

		move 	$a0, 		$t9
		li 		$v0, 		1
		syscall

		# Leave  Program
		la 		$a0,	 	newLine	
		li 		$v0, 		4
		syscall
		
		j 		main	

	# inOrder needs to iterate seven times and registers need to be laoded
	inOrder:
		add 	$t2, 			$zero, 	$zero
		move 	$t3, 			$a0 				
		move 	$t4, 			$a1 				
		add 	$t5, 			$zero, 	$zero
		
	# When it has iterated seven times it will halt and go to next
	beginToLoop:
		add 	$t1, 			$zero, 	7
		beq 	$t2, 			$t1, 		endLoop
		addiu 	$sp, 			$sp, 		-20 		
		sw 		$ra, 			16($sp) 			
		sw 		$t2, 			12($sp) 			
		sw 		$t3, 			8($sp)			
		sw 		$t4, 			4($sp)			
		sw 		$t5, 			($sp) 			
		move 	$a0, 			$t3 
		move 	$a1, 			$t4 
		jal 	nextInLine
		sw 		$v0, 			8($sp) 					
		move 	$t3, 			$v0
		add 	$t1, 			$zero, 	7
		beq 	$t3, 			$t1, 		addToLoop

		# Need to ask user if number is displayed
		li 		$v0, 			4
		la 		$a0, 			printInstruc2
		syscall
		
		la 		$a0, 			newLine
		li 		$v0, 			4
		syscall
	
		addi 		$t1, 			$zero, 	    1
		addi 		$t3, 			$t3, 		-1 			
		sllv 		$t1, 			$t1, 		$t3 			
		
		# Finally print card
		move 	$a0, 			$t1
		jal 	showCard
		la 		$a0, 			newLine
		li 		$v0, 			4
		syscall

		# Get the users number
		la 		$a0, 			storeAns
		li 		$a1, 			3
		li 		$v0, 			8
		syscall
		
		lb 		$t5, 			0($a0)
		bne 	$t5, 			'Y', 		addToLoop
		
		# Now that we have users number, use to pass it to cardMath
		lw 		    $t3, 			8($sp)
		addi 		$t1, 			$zero, 	    1
		addi 		$t3, 			$t3, 		-1 
		sllv 		$t1, 			$t1, 		$t3 
		
		#add card number to user sum
		lw 		$t5, 			($sp) 			
		add 	$t5, 			$t5, 		$t1
		sw 		$t5, 			($sp) 
		
	addToLoop:
		lw 		$ra, 			16($sp)
		lw 		$t2, 			12($sp)
		lw 		$t3, 			8($sp)
		lw 		$t4, 			4($sp)
		lw 		$t5, 			($sp)
		addiu 	$sp, 			$sp, 		20
		addi 	$t2, 			$t2, 		1
		j 		beginToLoop
		
	endLoop:
		move 	$v0, 			$t5
		jr 		$ra
	
	# Basic funciton to load card with numbers like the website 
	showCard: 
		move 	$s0, 			$a0 	
		li 		$s1, 			64 
		move 	$t2, 			$a0 	
		move 	$t6, 			$zero 
		addi 	$t2, 			$t2, 		-1
		

		
	disLoop: 
		addi 		$t2, 		$t2, 			1
		slt 		$t4, 		$t2, 			$s1
		beq 		$t4, 		$zero, 		    goodBye
		and 		$t3, 		$t2, 			$s0
		bne 		$t3, 		$s0, 			disLoop
		move 	    $a0, 	$t2
		li 		    $v0, 		1
		syscall
		
		addi 		$t6, 		$t6, 			1 
		andi 		$t5, 		$t6, 			7
		beq 		$t5, 		$zero, 		disNewLine
		la 		    $a0, 	printSpace
		li 		    $v0, 		4
		syscall
		
		j 		    disLoop

	disNewLine: 
		la 		$a0, 	newLine
		li 		$v0, 		4
		syscall
		
		j 		disLoop
	startPro:
		li 		$v0, 		4			
		la 		$a0, 		intro		
		syscall


		sw 		$zero,  	buffer
		li 		$v0, 		8				
		la 		$a0,		buffer				
		li 		$a1, 		20				
		syscall

		addi		$t1, 		$zero, 		110			
		addi		$t7,		$zero, 		121			
		lb 		    $t2, 		($a0)
		beq 		$t2, 		$t1, 			exit			
		bne 		$t2, 		$t7, 			errorChecker  		
		jr 		    $ra
	goodBye: 
		jr 		    $ra

	exit:
		li 		$v0, 		10
		syscall

	# This is used for error detection 
	errorChecker:
		li 		$v0, 		4	
		la 		$a0, 		wrongInput				
		syscall					
		j 		main					

