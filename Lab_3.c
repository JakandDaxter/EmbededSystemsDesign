// 1. Write a NIOS II C program that does the following:
// 	a. Displays 0 on hex0
// 	b. Checks to see if key1 is pushed (active low)
// 			i. If SW0 is high, increments the value on hex0 ii. If SW0 is low, decrements the value on hex0
// 	c. Do not increment or decrement the value on hex0 until key1 is released
//
// 2. Open NIOS II Software Build Tools for Eclipse. Create a new App and BSP, generate the bsp,
// copy system.h to the app folder, move your C program to the app folder, build the project and choose Debug as NIOS II hardware.
// Click the run icon and verify your program works as expected.
// /* alt_types.h and sys/alt_irq.h need to be included for the interrupt
//   functions
//   system.h is necessary for the system constants
//   io.h has read and write functions

#include "io.h"
#include <stdio.h>
#include "system.h"
#include "alt_types.h"
#include "sys/alt_irq.h"
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_timer.h"

// create standard embedded type definitions
typedef   signed char   sint8;              // signed 8 bit values
typedef unsigned char   uint8;              // unsigned 8 bit values
typedef   signed short  sint16;             // signed 16 bit values
typedef unsigned short  uint16;             // unsigned 16 bit values
typedef   signed long   sint32;             // signed 32 bit values
typedef unsigned long   uint32;             // unsigned 32 bit values
typedef         float   real32;             // 32 bit real values

//set up pointers to peripherals

// uint* TimerPtr         = (uint*)TIMER_0_BASE;
// uint* LedPtr           = (uint*)LEDS_BASE;
// uint* Hex0Ptr      	   = (uint*)HEX0_BASE;
// uint* KeyPtr       	   = (uint*)PUSHBUTTONS_BASE;
// uint* SwitchPtr        = (uint*)SWITCHES_BASE;

uint* TimerPtr         = (uint*)0x11000;
uint* LedPtr           = (uint*)0x11020;
uint* Hex0Ptr      	   = (uint*)0x11030;
uint* KeyPtr       	   = (uint*)0x11040;
uint* SwitchPtr        = (uint*)0x11050;

unsigned char array_hexDisplay [] = {0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x2, 0x78, 0x0, 0x18}; //array to hold the hex constants
// void timer_isr(void *context)
// ****************************************************************************/
// /* Interrupt Service Routine                                                 */
// /*   Determines what caused the interrupt and calls the appropriate          */
// /*  subroutine.                                                              */
// /*                                                                           */
// /****************************************************************************
// {
//     unsigned char current_val;
//
//     //clear timer interrupt
//     *TimerPtr = 0;
//
//
//     current_val = *LedPtr;  // read the leds
//
//     *LedPtr = current_val + 1;   // change the display
//
//     return;
// }

int main(void)
// ****************************************************************************/
// /* Main Program                                                              */
// /*   Enables interrupts then loops infinitely                                */
// /****************************************************************************
{
     // this enables the NIOS II to accept a TIMER interrupt
     // * and indicates the name of the interrupt handler
	// alt_ic_isr_register(TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID,TIMER_0_IRQ,timer_isr,0,0);

	//Set up the board and variables
    *Hex0Ptr = 0x40;  // initial value to leds is zero
	unsigned char current_val = 0; //will store the value of what ever is being read
	unsigned char display = 0; //what is stored in the bucket
	*KeyPtr  = current_val; //reading the current value of the key
	int i = 0;

	for( i<11,i++)
	{
	if(current_val == 13)
	{
		i++; //increment the bucket of the array
		display = array_hexDisplay[i]; 
	}

	*Hex0Ptr = display; //store whatis in the array after it was incremented

	}
    return 0;
}


// #********This is the array that will hold the hex display values******************************************************#
//
// array_hexDisplay:
//
// 		.byte 0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x2, 0x78, 0x0, 0x18 #/* 0-9 */#
// 		#segments			 #00000000
// 		#1000000 - 0  = 0x40
// 		#1111001 - 1  = 0x79
// 		#0100100 - 2  = 0x24
// 		#0110000 - 3  = 0x30
// 		#0011001 - 4  = 0x19
// 		#0010010 - 5  = 0x12
// 		#0000010 - 6  = 0x2
// 		#1111000 - 7  = 0x78
// 		#0000000 - 8  = 0x0
// 		#0011000 - 9  = 0x18
//
// #*********************************************************************************************************************#