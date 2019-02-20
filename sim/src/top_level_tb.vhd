-------------------------------------------------------------------------------
-- Jodi-Ann Morgan
-- Lab 6 test bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity top_level_tb is
end top_level_tb;

architecture arch of top_level_tb is

component top_level is
  Port(
       clk                                      : in std_logic; 
	   mr                                       : in std_logic;--pushbutton
	   ms                                       : in std_logic;--pushbutton
	   execute                                  : in std_logic;--pushbutton
	   resetBtn									: in std_logic;--pushbutton
       switch									: in std_logic_vector(7 downto 0);--A and B
	   op										: in std_logic_vector(1 downto 0);--chooses the ALU operation 
       Hex0,Hex1,Hex2                         	: out std_logic_Vector(6 downto 0);
       LED                                   	: out std_logic_Vector(4 downto 0) --outputs the states
);
end component; 

signal mrbutton                         : std_logic := '0';
signal msbutton                         : std_logic := '0';
signal executebt                         : std_logic := '0';
signal opsig							:std_logic_vector(1 downto 0);

signal switch_sig                      : std_logic_vector (7 downto 0):= "00000000";   
signal   Hex_0,Hex_1,Hex_2            : std_logic_vector(6 downto 0);
constant period                       : time := 20 ns;                                              
signal clk                            : std_logic:= '0';
signal reset                          : std_logic:= '0';--active low reset
signal LEDS                           :std_logic_Vector(4 downto 0);--outputs the states
begin

-- bcd iteration
sequential_tb : process 
    begin
      report "****************** sequential testbench start ****************";
      wait for 80 ns;   
         switch_sig <= "00000101";
		 opsig		<= "00";--add
		 wait for 50 ns;
		 executebt	<= '1';
		 wait for 100 ns;
		 executebt  <= '0';
		 wait for 100 ns;
		 executebt	<= '1';
		 wait for 100 ns;
		 executebt  <= '0';
		 wait for 100 ns;
		 msbutton <='1';
		 wait for 100 ns;
		 msbutton <='0';
		 wait for 100 ns;
		 mrbutton <='1';
		 wait for 100 ns;
		 mrbutton <='0';
		 
  end process; 

-- clock process
clock: process
  begin
    clk <= not clk;
    wait for period/2;
end process; 
 
-- reset process
async_reset: process
  begin
    wait for 2 * period;
    reset <= '1';--active low reset
    wait;
end process;

-- --button process
-- buttons: process
-- begin 
-- button <= not button; 
-- wait for period; 
-- end process; 

-- --input process
-- inputs: process
-- begin 
-- Input_Sig <= std_logic_vector(unsigned(Input_Sig)+ 1); 
-- wait for 8*period; 
-- end process; 


uut: top_level 
  port map(        
  clk                        =>  clk,      
  mr                         =>  mrbutton,      
  ms                         =>  msbutton ,      
  execute                    =>  executebt,      
  resetBtn		             =>  reset,
  switch		             => switch_sig, 
  op			             =>  opsig,      
  Hex0						 => Hex_0,
  Hex1						 => Hex_1,
  Hex2						 => Hex_2,                
  LED                   	 =>  LEDS            
                   
  );
end arch;