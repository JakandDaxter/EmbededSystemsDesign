-----------------------------------------------------------------------
--- Jodi-Ann Morgan
--- Lab 8 test bench
-----------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;


entity audio_filter_tb is
end audio_filter_tb;

architecture arch of audio_filter_tb is 

component audio_filter is 
Port (
		clk			: in std_logic;     --CLOCK_50
		reset_n		: in std_logic;     --active low reset
		filter_en 	: in std_logic;		--This is enables the internal registers and coincides with a new audio sample
		data_in		: in signed(15 downto 0); --Audio sample, in 16 bit fixed point format (15 bits of assumed decimal)
		data_out	: out signed(15 downto 0) --This is the filtered audio signal out, in 16 bit fixed point format
	);
end component;
SIGNAL sim_done : boolean := false;
constant period     : time := 20 ns;                                              
signal clk          : std_logic := '0';
signal reset_n        : std_logic ;--active low reset
signal filter_en        : std_logic:= '0'; 
signal data_in        : signed(15 downto 0):= (OTHERS => '0'); 
signal data_out        : signed(15 downto 0):= (OTHERS => '0');
type array_type1  is array (0 to 39) of signed(15 downto 0);
  signal audioSampleArray : array_type1 ;



begin

uut: audio_filter
  port map(
	clk			=> clk,
	reset_n		=> reset_n,
	filter_en 	=> filter_en,
	data_in		=> data_in,
	data_out	=> data_out
  );

-- clock process
clock: process
  begin
	clk <= not clk;
	wait for period/2;
end process; 
-- reset process
async_reset: process
  begin
  reset_n<= '0';
	wait for 2 * period;
	 --wait for period/2;
	reset_n <= '1';
	wait;
end process; 

stimulus : process is 
  file read_file : text open read_mode is "one_cycle_200_8k.csv";
  file results_file : text open write_mode is "output_waveform.csv";
  variable lineIn : line;
  variable lineOut : line;
  variable readValue : integer;
  variable writeValue : integer;
  
begin
  -- reset_n <= '0';
  -- wait for 100 ns;
  -- reset_n <= '1';
  -- Read data from file into an array
  for i in 0 to 39 loop
    readline(read_file, lineIn);
    read(lineIn, readValue);
    audioSampleArray(i) <= to_signed(readValue, 16);
    wait for 50 ns;
  end loop;
  file_close(read_file);
  
  -- Apply the test data and put the result into an output file
  for i in 1 to 100 loop
  for j in 0 to 39 loop
      -- Your code here...
	   for k in 1 to 1100 loop
          WAIT UNTIL rising_edge (clk);
      end loop;
	-- Read the data from the array and apply it to Data_In    
		data_in <= audioSampleArray(j);--16+16=32 bits;
	-- Remember to provide an enable pulse with each new sample 
	
-- Write filter output to file
      writeValue := to_integer(data_out);
      write(lineOut, writeValue);
      writeline(results_file, lineOut);
      
	  -- Your code here...
for l in 1 to 2 loop
          WAIT UNTIL rising_edge (clk);
      end loop;
      filter_en <= '1';
      WAIT UNTIL rising_edge (clk);
      filter_en <= '0';
	  
    end loop;
  end loop;

  file_close(results_file);

  -- end simulation
  sim_done <= true;
  wait for 100 ns;

  -- last wait statement needs to be here to prevent the process
  -- sequence from re starting at the beginning
  wait;

end process stimulus;

  
END;