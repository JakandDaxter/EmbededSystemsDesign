# ---------------------------------------------------------------
#02/4/2019
# 				Its all in God's Hands with this one
#
# Aliana Tejeda, Lab 2, Count up and down in hex from 0-9 with switch0 and key 1
# ---------------------------------------------------------------

.text

.macro MOVIA reg, addr
  movhi \reg, %hi(\addr)			
  ori \reg, \reg, %lo(\addr)
.endm

	# define constants
			.equ Switches,    0x11020    			#the base address of Switches in the system.h file
			.equ Hex,         0x11000    			#the base address of HEX in the system.h file 
			.equ key,         0x11010	 			#the base address of the keys in the system.h file  
			.equ N, (END-array_hexDisplay) 			#defines symbol N to hold the number of elements in the array
			
	#Define the main program
.global main

main:
#****Write or read these in order to gain or push Information********************************************************#	
	
	  	  	movia r6,  Switches 		       		#loads the base address into register for future comparison
	 	   	movia r7,  Hex 					   		#loads the base address into the register for future manipulation
	  	  	movia r8,  key 					   		#loads the base address into register for future comparison
	 	   	movia r5, array_hexDisplay		   		#hopefully moves the array to this variable
			movia r10, 0x01	
			movia r4, 13                       		#see if a key is pressed or not
			movia r12, 0x40					   		# checking if zero 
			movia r13, 0x18					   		# checking if 9
#*********************************************************************************************************************#
#*********************************************************************************************************************#
#*********************************************************************************************************************#	
	     	movi r3, N 								#loop counter, N entries in A
			ldb r2, 0(r5) 							#read next entry in A[]
			stbio r2, 0(r7)
		
		 
LOOP:   ldbio r9, (r8) 						    	#read key1
		bne r9, r4, LOOP
		ldbio r11, 0(r6) 							#loading switch 0
		and  r11, r11, r10							#checking to see if the switch is a 1 or a 0
		bne r11, r0 , INCREMENT
		br DECREMENT
		

		
STOP: br STOP 										#endless loop to halt the program


RESTARTDOWN:
			#compeq r5 , 0x40  						#compare to see if what is in the register is 0
			addi r5, r5 , 10        				#if its at 0 then go to 9 if we are decrementing
			movia r3, N 							#restart counter
			br DECREMENT		    				#Go back to the subroutine
RESTARTUP:			
			#compeq r5 , 0x18  						#compare to see if what is in the register is 9
			subi r5, r5 , 10        				#if its at 9 then go to 0 if we are incrementing
			movia r3, N 							#restart counter
			br INCREMENT							#Go back to the subroutine
	
INCREMENT:
			cmpeq r11, r5 , r13  					#compare to see if what is in the register is 9
			beq r11, r10, RESTARTUP					#If r11 gets a 1 that means that the compare was true
			ldbio r9, (r8) 		    				#read key1
			beq r9, r4, INCREMENT   				#if the key hasnt been released yet, keep loading till it is
	        addi r5, r5, 1 							#go to next entry in A
			ldb r2, 0(r5) 							#read next entry in A[]
			stbio r2, (r7) 							#write to seven seg
			subi r3, r3, 1 							#decrement the loop counter
			bne r3, r0, LOOP 						#if r3!=0, go back to LOOP
			#movia r5, 0 							#start it back to 0
			#movia r3, N 
			br main
			
DECREMENT:
			ldb r2, 0(r5)
			cmpeq r11, r2 , r12  					#compare to see if what is in the register is 0
			beq r11, r10, RESTARTDOWN				#If r11 gets a 1 that means that the compare was true
			ldbio r9, (r8) 		    				#read key1
			beq r9, r4, DECREMENT   				#if the key hasnt been released yet, keep loading till it is
	        subi r5, r5, 1 							#go to next entry in A
	        ldb r2, 0(r5) 							#read next entry in A[]
	        stbio r2, (r7)							#write to seven seg
	        subi r3, r3, 1 							#decrement the loop counter
	        bne r3, r0, LOOP 						#if r3!=0, go back to LOOP
	        #movia r5, 0 							#start it back to 0
			#movia r3, N 
	        br main

#********This is the array that will hold the hex display values******************************************************#

array_hexDisplay:
	
		.byte 0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x2, 0x78, 0x0, 0x18 #/* 0-9 */#
		#segments			 #00000000
		#1000000 - 0  = 0x40
		#1111001 - 1  = 0x79
		#0100100 - 2  = 0x24
		#0110000 - 3  = 0x30
		#0011001 - 4  = 0x19
		#0010010 - 5  = 0x12
		#0000010 - 6  = 0x2
		#1111000 - 7  = 0x78
		#0000000 - 8  = 0x0
		#0011000 - 9  = 0x18
		
#*********************************************************************************************************************#	

END:	
	.end 
		 
