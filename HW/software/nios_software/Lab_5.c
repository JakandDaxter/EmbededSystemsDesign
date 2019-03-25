#include "io.h"
#include <stdio.h>
#include "system.h"
#include "alt_types.h"
#include "sys/alt_irq.h"
#include "altera_avalon_pio_regs.h"

// create standard embedded type definitions
typedef   signed char   sint8;              // signed 8 bit values
typedef unsigned char   uint8;              // unsigned 8 bit values
typedef   signed short  sint16;             // signed 16 bit values
typedef unsigned short  uint16;             // unsigned 16 bit values
typedef   signed long   sint32;             // signed 32 bit values
typedef unsigned long   uint32;             // unsigned 32 bit values
typedef         float   real32;             // 32 bit real values


volatile uint32 *KeyPtr       	    = (uint32 *) 0x11060;
volatile uint32 *SwitchPtr        	= (uint32 *) 0x11070;

uint32 *ServoPtr = (uint32 *) SERVO_CONTROLLER_0_BASE ; // servo base address

volatile int *HEX0 = (int *) HEX0_BASE; // HEX base address
volatile int *HEX1 = (int *) HEX1_BASE; // HEX base address
volatile int *HEX2 = (int *) HEX2_BASE; // HEX base address
volatile int *HEX3 = (int *) HEX3_BASE; // HEX base address
volatile int *HEX4 = (int *) HEX4_BASE; // HEX base address
volatile int *HEX5 = (int *) HEX5_BASE; // HEX base address

volatile uint32 j					= 0; //used to increment through the array
volatile int *edge_capture;   			 //global variable to hold the edge capture value 
volatile uint32 SwitchValue			= 0; //this is the switch value i will write to  when im in the ISR
volatile uint32 KeyValue			= 0; 
//************************************************************************************************************************//
unsigned char ServoReg0 = 45; // *(ServoPtr);
unsigned char ServoReg1 = 135; // *(ServoPtr + 1);

void pushbutton_isr(void *context)
{
	char HEX_Array[] = {0x40, 0x79,0x24,0x30,0x19,0x12,0x02,0x78,0x0,0x18};
    KeyValue = *(KeyPtr + 3); //read key value
    *(KeyPtr + 3) = KeyValue;
    
    SwitchValue = *SwitchPtr;  //reading the value of switches
    
	if (KeyValue ==(KeyValue & 0x8)) //ensures key 3 was pressed
	{
        //store min
		ServoReg0 = SwitchValue;
					//for min
			//tens
			*HEX5 = HEX_Array[ServoReg0/10];
			//ones
			*HEX4 = HEX_Array[ServoReg0%10];

	}

	else if (KeyValue ==(KeyValue & 0x4)) //ensures key 2 was pressed
	{
        //store max
						ServoReg1 = SwitchValue;

						*HEX2 = HEX_Array[ServoReg1/100];
						//tens
						*HEX1 = HEX_Array[(ServoReg1 - ((ServoReg1/100) * 100))/10];

						//ones
						*HEX0 = HEX_Array[ServoReg1%10];
								
	}
}
    
void servo_registor_isr(void *context)
{
	//Remember you will be loading the registers with the number of counts necessary to create 
	//the pulsewidth for the specified angle
	//used linear regression to determine formula
		//Reg0
	*(ServoPtr) = (555.55556 * ServoReg0) + 25000;
		//Reg1
	*(ServoPtr + 1) = (555.55556 * ServoReg1) + 25000;
 

}

int main(void)
{
	char HEX_Array[] = {0x40, 0x79,0x24,0x30,0x19,0x12,0x02,0x78,0x0,0x18};
	//initial write to servo
    
    *HEX3 = 0x3F;
	
alt_ic_isr_register(PUSHBUTTONS_IRQ_INTERRUPT_CONTROLLER_ID,
                                    PUSHBUTTONS_IRQ,
                                    pushbutton_isr,
                                        0,
                                        0);

*(KeyPtr + 2) = 0xF;//write to the pushbutton interrupt mask register, and set 3 mask bits to 1 (bit 0 is Nios II reset) */
 
//registers servo isr
alt_ic_isr_register(SERVO_CONTROLLER_0_IRQ_INTERRUPT_CONTROLLER_ID,
						SERVO_CONTROLLER_0_IRQ,
                                servo_registor_isr,
                                0,
                                0);
       *HEX5 = HEX_Array[ServoReg0/10];
       *HEX4 = HEX_Array[ServoReg0%10];
       *HEX2 = HEX_Array[ServoReg1/100];
       *HEX1 = HEX_Array[(ServoReg1 - ((ServoReg1/100) * 100))/10];
       *HEX0 = HEX_Array[ServoReg1%10];

//double dabble C edition
		while(1);
   return main();
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
// 		.byte 0x40, 0x79, 0x24, 0x30, 0x19, 0x12, 0x2, 0x78, 0x0, 0x18 #/*
// 		#segments			 #00000000
//		#gfedcba - #  = #
// 		#0111111 - '-' = 0x3F
// 		#1000000 - 0  = 0x40
// 		#1111001 - 1  = 0x79				 a
// 		#0100100 - 2  = 0x24			-----------
// 		#0110000 - 3  = 0x30		   |		   |
// 		#0011001 - 4  = 0x19		 f |		   |
// 		#0010010 - 5  = 0x12		   |		   | b
// 		#0000010 - 6  = 0x2 		   |	g	   |
// 		#1111000 - 7  = 0x78		    -----------
// 		#0000000 - 8  = 0x0 		   |		   |
// 		#0011000 - 9  = 0x18 		   |		   | c
// 		#0001000 - A  = 0x8   		 e |		   |
// 		#0000011 - B  = 0x3 		   |		   |
// 		#1000110 - C  = 0x46		    -----------
// 		#0100001 - D  = 0x21				 d
// 		#0000110 - E  = 0x6
// 		#0001110 - F  = 0x14
//		#0011000 - º  = ....
// #*********************************************************************************************************************#   // unsigned 8 bit values
