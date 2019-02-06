# ---------------------------------------------------------------
# Assembly language program that reads data from the switches
# and displays it on the LEDs.
# ---------------------------------------------------------------

.text

# define a macro to move a 32 bit address to a register

.macro MOVIA reg, addr
  movhi \reg, %hi(\addr)
  ori \reg, \reg, %lo(\addr)
.endm

# define constants
.equ Switches, 0x11010    #find the base address of Switches in the system.h file
.equ LEDs,     0x11000    #find the base address of Switches in the system.h file

#Define the main program
.global main
main: 	#load r2 and r3 with the addresses
  movia r2, Switches
  movia r3, LEDs

loop: 	#read from r2 and store to r3
  ldbio r4, 0(r2)
  stbio r4, 0(r3)
  br    loop
