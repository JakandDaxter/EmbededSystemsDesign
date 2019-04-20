library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;


entity Filter is

	port(
		
			clock  					    :in  std_logic;
			
				----- KEY -----
			reset_n 					:in  std_logic;
	 
	 	   	address 					:in  std_logic; --this will let me know low or high pass from the array
			
			writedata					:in  signed (15 downto 0); --audio sample,in the 16 bit fized point format (15 bits assumed deciaml)
			
			write	 				    :in  std_Logic;
					
			
			readdata					:out signed (15 downto 0) --this is the filtered audio signal out, in 16 bit fixed
			
		);	
		
			end Filter;
			
architecture beh of Filter is
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

Component Multiplier IS

	PORT

	(
		dataa					  		  :IN  STD_LOGIC_VECTOR  (15 DOWNTO 0);

		datab					  		  :IN  STD_LOGIC_VECTOR  (15 DOWNTO 0);

		result		              		  :OUT STD_LOGIC_VECTOR  (31 DOWNTO 0)

	);

END COMPONENT Multiplier;
---------------------------------------------
--Creation of 1D array to store from multiplier
----------------------------------------------
--							 rows						This long of a data set
type sampledData is array (0 to 16) of signed(31 downto 0);

signal Data_F : sampledData ;

---------------------------------------------
--Creation of 1D array to store from shifting
----------------------------------------------
--							 rows						This long of a data set
type shiftedData is array (0 to 16) of signed(15 downto 0);

signal shifts : shiftedData ;
---------------------------------------------
--Register Storage for high and low pass and audio data
----------------------------------------------
--							 rows						This long of a data set
type ram_type is array (0 to 17) of signed(15 downto 0);

signal Registers : ram_type ;														


-- Registers(0) this will be storing the data to let me know if its a low or high pass will be (0xFF) or (0x00)

-- Registers(1) this will actuall store the audio data

--------------------------                        
-- Signal Declarations
--------------------------
    
signal Input_data 			 : signed(15 downto 0)   := (others => '0');

signal index				 : std_logic; 

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
-----------------------------------------------------
--alright so right there we generates 16 port maps for every variable constant
-----------------------------------------------------
   LowPass:
   
   for i in 0 to 16 generate
      
	  REGX : Multiplier 
	  
	  port map(
	  
			dataa   			             		 		=> std_logic_vector( shifts(i) ),
			
			datab       					  		 		=> std_logic_vector( Filter_array(i,index) ),
			
			signed(result)			         				=> Data_F(i)
            
-----------------------------------------------------
-- Depending on the filter enable the index will either be a 1 or a 0 for the low or high pass filter
-----------------------------------------------------
Low_OR_HIGH: process( reset_n , clock )

begin
	
	if(reset_n = '0') THEN
	
		index <= '0';
	
			if( rising_edge(clock) ) then
		
				if(Register(0) = X"F") then
			
					index <= '1';
			
				else
			
					index <= '0';
			
				end if
		
			end if;
			
		end if ;
	
end process ; -- identifier

-----------------------------------------------------
----------------------------------------------------
  --so instead im just going to copy and paste every single one
  readdata <=  Data_F(0)(30 downto 15)
               + Data_F(1)(30 downto 15)
               + Data_F(2)(30 downto 15)
               + Data_F(3)(30 downto 15)
               + Data_F(4)(30 downto 15)
               + Data_F(5)(30 downto 15)
               + Data_F(6)(30 downto 15)
               + Data_F(7)(30 downto 15)
               + Data_F(8)(30 downto 15)
               + Data_F(9)(30 downto 15)
               + Data_F(10)(30 downto 15)
               + Data_F(11)(30 downto 15)
               + Data_F(12)(30 downto 15)
               + Data_F(13)(30 downto 15)
               + Data_F(14)(30 downto 15)
               + Data_F(15)(30 downto 15)
               + Data_F(16)(30 downto 15);
 ----------------------------------------------------
--alright so right we going to shift the data
-----------------------------------------------------
 dataShifts: PROCESS(clock,reset_n)
 
BEGIN

 IF (clock'event AND clock = '1') THEN
	 
	 IF (reset_n = '0') THEN
		 
		 shifts <= ( others => ( others=> '0') );
		 
		 elsif(Register(0) = X"F") THEN
			
				shifts(0) <= writedata;
				
			for G in 1 to shifts'length-1 loop
			
				shifts(G)	<=  shifts(G-1);

			end loop;
			
		end if;
		
	end if;
	
END PROCESS dataShifts; 
    
end beh;