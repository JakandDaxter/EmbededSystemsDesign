//*****************************************************************************
//*********  Copyright 2018, Rochester Institute of Technology  ***************
//*****************************************************************************
//
//      NAME: Custom Component Test Program
//
//  FILENAME: custom_component.c
//
//   CREATED:  09/07/2018
//
// ============================================================================
//
//   DESCRIPTION:
//    The following program loads data into a custom component that contains a  
//    register with 8 32-bit locations/ After it loads the custom component
//    it waits for an interrupt from the custom component.
//
//
//*****************************************************************************
//*****************************************************************************


//*****************************************************************************
//                    Include Files
//*****************************************************************************
#include "system.h"                 // for QSYS parameters
#include "sys/alt_irq.h"            // for IRQ support


//*****************************************************************************
//                  Define symbolic constants
//*****************************************************************************



// create standard embedded type definitions
typedef   signed char   sint8;        // signed 8 bit values
typedef unsigned char   uint8;        // unsigned 8 bit values
typedef   signed short  sint16;       // signed 16 bit values
typedef unsigned short  uint16;       // unsigned 16 bit values
typedef   signed long   sint32;       // signed 32 bit values
typedef unsigned long   uint32;       // unsigned 32 bit values
typedef         float   real32;       // 32 bit real values




//*****************************************************************************
//                     Define private data
//*****************************************************************************


uint32* CustomIpPtr = (uint32*)MY_CUSTOM_IP_0_BASE;
uint32* JtagUartPtr = (uint32*)JTAG_UART_0_BASE;


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
void jtag_display (uint8* prompt, uint32 count)
{
  uint32 i;

  for (i = 0; i < count; i++)
  {
    *JtagUartPtr = prompt[i];
  } /* for */
} /* jtag_display */


//*****************************************************************************
// NAME: Custom IP Interrupt Service Routine
//
// DESCRIPTION:
//    This function represents the Interrupt Service Routine for the
//    Custom IP Component within the QSYS hardware. If the Custom IP
//    Component produces an interrupt
//
// INPUTS:
//    context  - the Altera ISR requires this. The context is a pointer
//               used to pass context-specific information to the ISR,
//               and can point to any ISR-specific information
// OUTPUTS:
//    none
// RETURN:
//    none
//*****************************************************************************
// This is the interrupt handler if the IP produces and interrupt
void customIpIsr(void *context )
{
  jtag_display((uint8*)"Error", 5);
} /* customIpIsr */


//*****************************************************************************
//                              MAIN
//*****************************************************************************

int main(void)
{

  uint32 i;

  // ------------------------------------------------------------------
  // register the Interrupt Service Handlers
  // ------------------------------------------------------------------
  alt_ic_isr_register (MY_CUSTOM_IP_0_IRQ_INTERRUPT_CONTROLLER_ID,
                       MY_CUSTOM_IP_0_IRQ, customIpIsr, 0, 0);

  /* this loop loads the IP's 8 registers with large integers*/

  for (i = 0; i < 8; i++)
  {
    *(CustomIpPtr + i) = 10000 * i;
  } /* for */

  // wait for interrupt
  while (1)
  {

  }  /* while */

  return 0;
} /* main */
