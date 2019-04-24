//*******************************************************************************************************//
//
//  Program name: arbitration_nios0
//  Creation date: 10/29/18
//  Author : Jeanne Christman
//  Class : CPET-562 - Embedded Systems Design I
//
//  Description : This program is one side of a chat application in a system that has two NIOS II processors
//                accessing the same RAM. After displaying a welcome message, this program operates forever
//                in a loop.  First it polls the receive UART to determine if a character has been typed on 
//		          the keyboard.  If it has, the character is echoed to the screen and stored in RAM. A 1 bit
//                flag is set in LOC + 4 so that the other processor knows that there is a char-
//                stored in SRAM.  The second part of the loop polls LOC + 12 to see if there is a flag from the 
//                other processor.  If there is, it takes the character stored in LOC + 8 and displays it on the 
//                terminal window.
//********************************************************************************************************//

//*****************************************************************************
//                    Include Files
//*****************************************************************************
#include "system.h"                 // for QSYS parameters#include "sys/alt_irq.h"            // for IRQ support#include <stdio.h>

//*****************************************************************************
//                  Define symbolic constants
//*****************************************************************************

// create standard embedded type definitions
typedef signed char sint8;        // signed 8 bit values
typedef unsigned char uint8;        // unsigned 8 bit values
typedef signed short sint16;       // signed 16 bit values
typedef unsigned short uint16;       // unsigned 16 bit values
typedef signed long sint32;       // signed 32 bit values
typedef unsigned long uint32;       // unsigned 32 bit values
typedef float real32;       // 32 bit real values

//*****************************************************************************
//                     Define private data
//*****************************************************************************

uint16* BridgePtr = (uint16*) AVALON_BRIDGE0_BASE;
uint32* JtagUartPtr = (uint32*) JTAG_UART_0_BASE;

//*****************************************************************************
//                     Define private functions
//*****************************************************************************

//*****************************************************************************
// NAME: Send String to JTAG UART
//
// DESCRIPTION:
//    This function displays to the JTAG_UART like a printf
//
// INPUTS:
//    prompt - pointer to string to display
//    count  - number of characters
// OUTPUTS:
//    none
// RETURN:
//    none
//*****************************************************************************
void jtag_display(uint8* prompt, uint32 count) {
	uint32 i;

	for (i = 0; i < count; i++) {
		*JtagUartPtr = prompt[i];
	} /* for */
} /* jtag_display */

//*****************************************************************************
//                              MAIN
//*****************************************************************************

int main(void) {
	int wspace, rv;  //these are for parsing the uart data
	char character;

	jtag_display((uint8*) "Welcome to ESD I chat room for CPU 0", 36);

	while (1) //run continuous loop
	{
		//poll the receive Uart to see if a character has been entered
		//if a valid character has been read, RV bit (bit 15) = 1;

		rv = *JtagUartPtr;
		if ((rv & 0x00008000) != 0)
		//read character
        {

			character = rv & 0x000000FF;

			//echo it if transmitter is ready
			wspace = *(JtagUartPtr + 1);
			if ((wspace & 0xffff0000) != 0) //if transmitter is ready
			{
				*JtagUartPtr = character;  //send character to uart
				//also store character and set flag;
				*(BridgePtr) = character;
				*(BridgePtr + 4) = 1;
			}


		}

		//now read flag from other CPU
		if (*(BridgePtr + 12) == 1)
		{
			*(BridgePtr + 12) = 0; //clear flag
			character = *(BridgePtr + 8);  //get the character

			//if there is a character, print it
			*(JtagUartPtr) = character;  //send character to uart
		}
	}
	return (0);

}

