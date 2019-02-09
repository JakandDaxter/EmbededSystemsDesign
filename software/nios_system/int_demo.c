//  This is a C program written for the timer interrupt demo.  The
//  program assumes a nios_system with a periodic interrupt timer
//  and an 8-bit output PIO named leds. */
//
//
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

uint32* TimerPtr    = (uint32*)TIMER_0_BASE;
uint8* LedPtr      = (uint8*)LEDS_BASE;



void timer_isr(void *context)
// ****************************************************************************/
// /* Interrupt Service Routine                                                 */
// /*   Determines what caused the interrupt and calls the appropriate          */
// /*  subroutine.                                                              */
// /*                                                                           */
// /****************************************************************************
{
    unsigned char current_val;
    
    //clear timer interrupt
    *TimerPtr = 0;

    
    current_val = *LedPtr;  // read the leds
    
    *LedPtr = current_val + 1;   // change the display

    return;
}

int main(void)
// ****************************************************************************/
// /* Main Program                                                              */
// /*   Enables interrupts then loops infinitely                                */
// /****************************************************************************
{
     // this enables the NIOS II to accept a TIMER interrupt
     // * and indicates the name of the interrupt handler
	alt_ic_isr_register(TIMER_0_IRQ_INTERRUPT_CONTROLLER_ID,TIMER_0_IRQ,timer_isr,0,0);
    
    *LedPtr = 0;  // initial value to leds
     
    while(1);
    return 0;
}
