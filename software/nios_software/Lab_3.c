#include "io.h"
#include <stdio.h>
#include "system.h"
#include "alt_types.h"
#include "sys/alt_irq.h"
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_timer.h"
#include "altera_avalon_pio_regs.h"

// create standard embedded type definitions
typedef   signed char   sint8;              // signed 8 bit values
typedef unsigned char   uint8;              // unsigned 8 bit values
typedef   signed short  sint16;             // signed 16 bit values
typedef unsigned short  uint16;             // unsigned 16 bit values
typedef   signed long   sint32;             // signed 32 bit values
typedef unsigned long   uint32;             // unsigned 32 bit values
typedef         float   real32;             // 32 bit real values

volatile uint32 *TimerPtr           = (uint32 *) 0x11000;
volatile uint32 *LedPtr           	= (uint32 *) 0x11020;
volatile uint32 *Hex0Ptr      	    = (uint32 *) 0x11030;
volatile uint32 *KeyPtr       	    = (uint32 *) 0x11040;
volatile uint32 *SwitchPtr        	= (uint32 *) 0x11050;

volatile uint32 j					= 0; //used to increment through the array
volatile int *edge_capture;   			 //global variable to hold the edge capture value 
volatile uint32 SwitchValue			= 0; //this is the switch value i will write to  when im in the ISR
//************************************************************************************************************************//
//************************************************************************************************************************//
//************************************************************************************************************************//
// 1. Write a NIOS II C program that does the following:
// a. Displays 0 on hex0
// b. Checks to see if key1 is pushed (active low)
// i. If SW0 is high, increments the value on hex0 ii. If SW0 is low, decrements the value on hex0
// c. Do not increment or decrement the value on hex0 until key1 is released
//************************************************************************************************************************//

// int main(void)
// // ****************************************************************************/
// // /* Main Program   Part 1                                                    */
// // /*   polling to increment and decrement                                    */
// // ***************************************************************************
// {
//
// 	int j = 0;
// 	int startloop = 0;
// //	Set up the board and variables
// 	int current_Keyval,switch_val; //will store the value of what ever is being read
// //	   what is stored in the bucket
// 	char array_hexDisplay[] = {0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x2, 0x78, 0x0, 0x18}; //array to hold the hex constants
//
// 	*Hex0Ptr = array_hexDisplay[0] ;
// 	//current_Keyval = *KeyPtr; //reading the current value of the key
//
// /* 		if(current_Keyval == 15)
// 			{startloop = 0;}
// 		else{startloop=1;} */
//
// 		//while(startloop == 1){
// 	while(1){
// 	 for(int i = 0; i<10;i++)
// 	 {
// 		 *Hex0Ptr = array_hexDisplay[j] ;
// 		 	 current_Keyval = *KeyPtr; //reading the current value of the key
//
// 		 	 if(current_Keyval == 13)
// 		 	 {
// 		 		 current_Keyval = *KeyPtr; //reading the current value of the key
//
// 		 		 if(current_Keyval == 15){
//
// 		 			 switch_val = *SwitchPtr; //reading the current value of the key
//
// 		 			 if(switch_val == 1){
// 		 				 if(j == 10){j = 0;}
// 						 else{j++;} //increment the bucket of the array
// 		 	 	 	 }
// 		 			 else{
// 		 				 if(j == 0){j = 10; j--;}
// 				 		j--;
// 				 }
//
// 			 }
// 		 }
// 	 }
//  		}
//
//     return (0);
// }
//************************************************************************************************************************//
//************************************************************************************************************************//
//************************************************************************************************************************//
//************************************************************************************************************************//

// Write a NIOS II C program that does the following:
// 			a. Registers and enables a pushbutton interrupt for key1 
//						b. Displays 0 on led0
// 							c. Contains a pushbutton ISR that checks the state of SWO
// 			i. If SW0 is high, it increments the value on hex0 
//				ii. If SW0 is low, it decrements the value on hex0
//************************************************************************************************************************//
//************************************************************************************************************************//

//	   what is stored in the bucket
char array_hexDisplay[] = {0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x2, 0x78, 0x0, 0x18}; //array to hold the hex constants

void Pushbutton_isr(void* context, alt_u32 id)
// ****************************************************************************/
// /* Interrupt Service Routine                                                 */
// /*   Determines what caused the interrupt and calls the appropriate          */
// /*  subroutine.                                                              */
// /*                                                                           */
// /****************************************************************************
{
   int switch_val;
   *edge_capture = (volatile int*) context;
   
   *edge_capture = IORD_ALTERA_AVALON_PIO_EDGE_CAP(0x11040); //stores the edge capture
   IOWR_ALTERA_AVALON_PIO_EDGE_CAP(0x11040,0);
   IOWR_ALTERA_AVALON_PIO_IRQ_MASK(0x11040, 0x2);
   

   
		switch_val = *SwitchPtr; //reading the current value of the
		//if(edge_capture == 1){
			if(switch_val == 1)
				{

					if(j == 10)
					{
						j = 0; //restart the position of the array
					}
						else
							{
								j++;
							} //increment the bucket of the array normally
		 	 	 }
		 	else
			{
				if(j == 0)
					{
						j = 10; //if at the end restart the position of the array and decrement from there
						j--;
					}
				 		j--; //decrement normal operation
			}
			//}

			*Hex0Ptr = array_hexDisplay[j];

		//*(KeyPtr+1) = 1; //clear button interrupt for key 1

	// *(LedPtr) = *(SwitchPtr);
	// *(KeyPtr+3) = 0;

		
    return;
}

int main(void)
// ****************************************************************************/
// /* Main Program   Part 2                                                    */
// /*   pushbutton interrupt on key1                                         */
// ***************************************************************************
{
	 // this enables the NIOS II to accept a pushbutton interrupt
     // * and indicates the name of the interrupt handler
	//alt_irq_register(PUSHBUTTONS_IRQ,(void *) &edge_capture,Pushbutton_isr);
	
	alt_ic_isr_register(PUSHBUTTONS_IRQ_INTERRUPT_CONTROLLER_ID,
	                        PUSHBUTTONS_IRQ,
	                        Pushbutton_isr,
	                        0,
	                        0);
	
		
		*Hex0Ptr = array_hexDisplay[0];
		
			while(1); //keep looking for that key button press
				{
				}

    return (0);
}
//************************************************************************************************************************//
//************************************************************************************************************************//
//************************************************************************************************************************//
//************************************************************************************************************************//
//************************************************************************************************************************//
//******************This is the array that will hold the hex display values***********************************************//
//
// array_hexDisplay:
//
// 		.byte 0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x2, 0x78, 0x0, 0x18 #/* 0-9#
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
// #*********************************************************************************************************************#   // unsigned 8 bit values

