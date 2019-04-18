library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;


entity Top is

	port(
		
			clock  					:in  std_logic;
			
				----- KEY -----
			KEY 					: in std_logic_vector(3 downto 0);
	 
			
			data_in					:in  signed(15 downto 0); --audio sample,in the 16 bit fized point format (15 bits assumed deciaml)
			
			filter_en 				:in  std_Logic; -- this enables the interal registers and coincides with a new audio sample			
			
			data_out				:out signed(15 downto 0) --this is the filtered audio signal out, in 16 bit fixed
			
		);	
		
			end Top;
			
architecture lowandHigh_pass_filter of Top is
---------------------------------------------
--Creation of 2D array
----------------------------------------------
--							        rows   , columns		This long of a data set
type Low_High_Pass is array (0 to 16, 0 to 1) of std_logic_vector(15 downto 0);

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
---------------------------------------------
--Creation of 1D array to store from multiplier
----------------------------------------------
--							 rows						This long of a data set
type sampledData is array (0 to 16) of std_logic_vector(15 downto 0);

signal Data_F : sampledData ;

---------------------------------------------
--Creation of 1D array to store from shifting
----------------------------------------------
--							 rows						This long of a data set
type shiftedData is array (0 to 16) of std_logic_vector(15 downto 0);

signal shifts : shiftedData ;
															
--------------------------                        
-- Component Declarations
--------------------------

Component Multiplier IS

	PORT
	
	(
		dataa				: IN STD_LOGIC_VECTOR  (15 DOWNTO 0);
			
		datab				: IN STD_LOGIC_VECTOR  (15 DOWNTO 0);
		
		result		        : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		
	);

END COMPONENT Multiplier;

--------------------------                        
-- Signal Declarations
--------------------------
    
signal Input_data 			 : signed(15 downto 0)   := (others => '0');

signal output_data 			 : signed(31 downto 0)   := (others => '0'); 
 
signal reset_n 				 : std_logic;
signal key0_d1 				 : std_logic;
signal key0_d2 				 : std_logic;
signal key0_d3 				 : std_logic;

-----------------------------------------------------			  
-----------------------------------------------------																			 :std_logic_vector  (31 downto 0);

BEGIN
 
-----------------------------------------------------			  		  
  ----- Syncronize the reset
-----------------------------------------------------  
  synchReset_proc : process (clock) begin
  
    if (rising_edge(clock)) then
      
	  key0_d1 <= KEY(0);
      
	  key0_d2 <= key0_d1;
      
	  key0_d3 <= key0_d2;
    
	end if;
  
  end process synchReset_proc;
-----------------------------------------------------	  
			reset_n <= key0_d3;
-----------------------------------------------------
--alright so right there we generates 16 port maps for every variable constant
-----------------------------------------------------
   LowPass:
   
   for i in 0 to 16 generate
      
	  REGX : Filter 
	  
	  port map(
	  
			dataa   			              => shifts(i),
			
			datab       					  => Filter_array(0,i),
			
			signed(result)(30 downto 15)      => Data_F(i)

			);
			
   end generate LowPass;	
-----------------------------------------------------
--alrighty right here we want to take what we input into the array and add it all up together
-----------------------------------------------------  
For_loop: Process

BEGIN

	for j in 0 to 15 loop

		output_data <= output_data + Data_F(j);
		
	end loop;
 
 END PROCESS For_loop;
 ----------------------------------------------------
--alright so right we going to shift the data
-----------------------------------------------------
 dataShifts: PROCESS(clock,reset_n)
 
BEGIN

 IF (clk'event AND clk = '1') THEN
	 
	 IF (reset_n = '0') THEN
		 
		 shifts <= ( others => ( others=> '0') );
		 
		 elsif(filter_en = '1') THEN
			
				shifts(0) <= data_in;
				
			for G in 1 to shifts'length-1 loop
			
				shifts(G)	<=  shifts(G-1);

			end loop;
			
		end if;
		
	end if;
	
END PROCESS dataShifts; 
    
end lowandHigh_pass_filter;