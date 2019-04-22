library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;


entity Top is

	port(		----- Clock -----
		
			clock  					         :in  std_logic;
			
				----- KEY -----
			KEY 							 :in std_logic;
			
				----- switch -----
			SW								 :in std_logic; --connect this to selection so that i know which filter to apply
				----- Adio Data Coming in -----
			
			data_in					    	 :in  signed(15 downto 0); --audio sample,in the 16 bit fized point format (15 bits assumed deciaml)
			
				----- filter enable -----
			
			--filter_en 				    	 :in  std_Logic; -- this enables the interal registers and coincides with a new audio sample			
			
				----- Output the filtered data -----
			
			data_out						 :out signed(15 downto 0) --this is the filtered audio signal out, in 16 bit fixed
			
	    );	
		
			end Top;
			
architecture lowandHigh_pass_filter of Top is
---------------------------------------------
--Creation of 2D array
----------------------------------------------
--							        rows   , columns		This long of a data set
type Low_High_Pass is array (0 to 16, 0 to 1) of signed(15 downto 0);

signal Filter_array : Low_High_Pass :=  
          
                        ( 
                      -- Low            High
                        (X"0051"   , X"003E"),
                        (X"00BA"   , X"FF9A"),
                        (X"01E1"   , X"FE9E"),
                        (X"0408"   , X"0000"),
                        (X"071A"   , X"0535"),
                        (X"0AAC"   , X"05B2"),      --will be indexing this filter to get the numbers
                        (X"0E11"   , X"F5AC"),
                        (X"107F"   , X"DAB7"),
                        (X"1161"   , X"4C91"),
                        (X"107F"   , X"DAB7"),                                                                        
                        (X"0E11"   , X"F5AC"),
                        (X"0AAC"   , X"05B2"),
                        (X"071A"   , X"0535"),                                                                        
                        (X"0408"   , X"0000"),
                        (X"01E1"   , X"FE9E"),
                        (X"00BA"   , X"FF9A"),
                        (X"0051"   , X"003E")
                        
                        );
															
--------------------------                        
-- Component Declarations
--------------------------
component nios_system is
	
		port (
			
			clk_clk         : in std_logic                    := 'X';             -- clk
			
			reset_reset_n   : in std_logic                    := 'X';             -- reset_n
			
			switches_export : in std_logic 						  := 'X'  -- export
		
		);
	
	end component nios_system;

--------------------------                        
-- Signal Declarations
--------------------------
    
signal Input_data 			 : signed(15 downto 0)   := (others => '0');

signal output_data 			 : signed(15 downto 0)   := (others => '0'); 
 
signal reset_n 				 : std_logic;
signal key0_d1 				 : std_logic;
signal key0_d2 				 : std_logic;
signal key0_d3 				 : std_logic;

-----------------------------------------------------			  
-----------------------------------------------------																	

BEGIN
 
-----------------------------------------------------			  		  
  ----- Syncronize the reset
-----------------------------------------------------  
  synchReset_proc : process (clock) begin
  
    if (rising_edge(clock)) then
      
	  key0_d1 <= KEY;
      
	  key0_d2 <= key0_d1;
      
	  key0_d3 <= key0_d2;
    
	end if;
  
  end process synchReset_proc;
-----------------------------------------------------	  
			reset_n <= key0_d3;

----------------------------------------------------
--------------------------                        
-- Port Map nios system
--------------------------
u0 : component nios_system
		
		port map (
		
			clk_clk         => clock,         --      clk.clk
			
			reset_reset_n   => reset_n,   --    reset.reset_n
			
			switches_export => SW  -- switches.export
		
		);
    
end lowandHigh_pass_filter;