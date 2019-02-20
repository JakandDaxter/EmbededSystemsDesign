--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*********  Copyright 2012, Rochester Institute of Technology  ***************
--*****************************************************************************
--
--       LAB NAME:  Custom Component demo
--
--      FILE NAME:  custom_ip.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--      This component is for demonstration purposes.  It does not do 
--      anything very useful. It is designed to become a custom component 
--      int the SOPC builder and demonstrates some of the available 
--      interfaces.  The component has 8 32-bit registers that can
--      be loaded from the CPU.  It makes the contents of those registers 
--      visible to other VHDL components in the system via the data_out 
--      interface. An interrupt is generated when an error condition is 
--      detected.
--
--
--  REVISION HISTORY
--  _______________________________________________________________________
-- |  DATE    | USER | Ver |  Description                                  |
-- |==========+======+=====+================================================
-- |          |      |     |
-- | 09/07/18 | JWC  | 1.0 | 
-- |          |      |     |
--
--*****************************************************************************
--*****************************************************************************

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY custom_ip IS
  PORT(
    clk        : IN std_logic;          -- 50 Mhz system clock
    reset_n    : IN std_logic;          -- active low system reset
    write      : IN std_logic;          -- active high write enable
    address    : IN std_logic_vector(2 DOWNTO 0);  --address of register to be written to (from CPU)
    writedata : IN std_logic_vector(31 DOWNTO 0);  --data from the CPU to be stored in the component
    --
    ext_addr_export  : IN  std_logic_vector(2 DOWNTO 0);  --address of register to be read from (from other VHDL)
    invalid_export   : IN  std_logic;  --this is a signal to tell the component that there has been an invalid request
    ext_data_export  : OUT std_logic_vector(31 DOWNTO 0);  --data visible to other components
    irq : OUT std_logic  --signal to interrupt the processor                      
    );
END ENTITY custom_ip;

ARCHITECTURE rtl OF custom_ip IS

  -- ram_type is a 2-dimensional array or inferred ram.  
  -- It stores eight 32-bit values
  TYPE ram_type IS ARRAY (7 DOWNTO 0) OF std_logic_vector (31 DOWNTO 0);
  SIGNAL Registers : ram_type;          --instance of ram_type

  --internal signal to address ram
  SIGNAL internal_addr : std_logic_vector(2 DOWNTO 0);  
  SIGNAL ext_addr  : std_logic_vector(2 DOWNTO 0);  
  SIGNAL invalid  : std_logic;  
  SIGNAL ext_data  : std_logic_vector(31 DOWNTO 0);  
  
BEGIN

  ext_addr <= ext_addr_export;
  invalid <= invalid_export;
  ext_data_export <= ext_data;

  --this process loads data from the CPU.  The CPU provides the address, 
  --the data and the write enable signal
  PROCESS(clk, reset_n)
  BEGIN
    IF (reset_n = '0') THEN
      --Registers <= (OTHERS => "00000000000000000000000000000000");
    ELSIF (clk'event AND clk = '1') THEN
      IF (write = '1') THEN
        Registers(to_integer(unsigned(address))) <= writedata;
        --when write enable is active, the ram location at the given address
        --is loaded with the input data
      END IF;
    END IF;
  END PROCESS;


--this process updates the internal address on each clock edge.
  latch : PROCESS(clk, reset_n)
  BEGIN
    IF (reset_n = '0') THEN
      internal_addr <= (OTHERS => '0');
    ELSIF (clk'event AND clk = '1') THEN
      internal_addr <= ext_addr;
    END IF;
  END PROCESS;

  --output the data being requested
  ext_data <= Registers(conv_integer(internal_addr));  

  --this process interrupts the processor if it receives and invalid signal
  interrupts : PROCESS(invalid)
  BEGIN
    IF (invalid = '1') THEN
      irq <= '1';
    ELSE
      irq <= '0';
    END IF;
  END PROCESS;

END ARCHITECTURE rtl;         
