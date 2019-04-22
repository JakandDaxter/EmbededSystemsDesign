-----------------------------------------------------------------------
--- Jodi-Ann Morgan
--- Lab 8 audio_filter
-----------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity audio_filter is
port (
		clk			: in std_logic;     --CLOCK_50
		reset_n		: in std_logic;     --active low reset
		filter_en 	: in std_logic;		--This is enables the internal registers and coincides with a new audio sample
		data_in		: in signed(15 downto 0); --Audio sample, in 16 bit fixed point format (15 bits of assumed decimal)
		data_out	: out signed(15 downto 0) --This is the filtered audio signal out, in 16 bit fixed point format
);
end entity audio_filter;


ARCHITECTURE design OF audio_filter IS


--These grab 15 downto 0 of the full and are also added together at the end
signal  multOut_lp0    : signed (15 DOWNTO 0);
signal  multOut_lp1    : signed (15 DOWNTO 0);
signal  multOut_lp2    : signed (15 DOWNTO 0);
signal  multOut_lp3    : signed (15 DOWNTO 0);
signal  multOut_lp4    : signed (15 DOWNTO 0);
signal  multOut_lp5    : signed (15 DOWNTO 0);
signal  multOut_lp6    : signed (15 DOWNTO 0);
signal  multOut_lp7    : signed (15 DOWNTO 0);
signal  multOut_lp8    : signed (15 DOWNTO 0);
signal  multOut_lp9    : signed (15 DOWNTO 0);
signal  multOut_lp10   : signed (15 DOWNTO 0);
signal  multOut_lp11   : signed (15 DOWNTO 0);
signal  multOut_lp12   : signed (15 DOWNTO 0);
signal  multOut_lp13   : signed (15 DOWNTO 0);
signal  multOut_lp14   : signed (15 DOWNTO 0);
signal  multOut_lp15   : signed (15 DOWNTO 0);
signal  multOut_lp16   : signed (15 DOWNTO 0);

--These go into the port map
signal  multOutfull_lp0   : signed (31 DOWNTO 0);
signal  multOutfull_lp1   : signed (31 DOWNTO 0);
signal  multOutfull_lp2   : signed (31 DOWNTO 0);
signal  multOutfull_lp3   : signed (31 DOWNTO 0);
signal  multOutfull_lp4   : signed (31 DOWNTO 0);
signal  multOutfull_lp5   : signed (31 DOWNTO 0);
signal  multOutfull_lp6   : signed (31 DOWNTO 0);
signal  multOutfull_lp7   : signed (31 DOWNTO 0);
signal  multOutfull_lp8   : signed (31 DOWNTO 0);
signal  multOutfull_lp9   : signed (31 DOWNTO 0);
signal  multOutfull_lp10  : signed (31 DOWNTO 0);
signal  multOutfull_lp11  : signed (31 DOWNTO 0);
signal  multOutfull_lp12  : signed (31 DOWNTO 0);
signal  multOutfull_lp13  : signed (31 DOWNTO 0);
signal  multOutfull_lp14  : signed (31 DOWNTO 0);
signal  multOutfull_lp15  : signed (31 DOWNTO 0);
signal  multOutfull_lp16  : signed (31 DOWNTO 0);

--ype S_data is array (0 to 16) of signed(15 downto 0);

 -- constant low_pass: S_data :=
 -- (
	-- X"0052",-- 0.0025    --0  
	-- X"00BB", -- 0.0057   --1  
    -- X"01E2", -- 0.0147   --2  
    -- X"0408", -- 0.0315   --3  
    -- X"071B", -- 0.0555   --4  
    -- X"0AAD", -- 0.0834   --5  
    -- X"0E11", -- 0.1099   --6  
    -- X"1080", -- 0.1289   --7  
    -- X"1162", -- 0.1358   --8  
    -- X"1080", -- 0.1289   --9 	
    -- X"0E11", -- 0.1099   --10 
    -- X"0AAD", -- 0.0834   --11 
    -- X"071B", -- 0.0555   --12 
    -- X"0408", -- 0.0315   --13 
    -- X"01E2", -- 0.0147   --14 
    -- X"00BB", -- 0.0057   --15 
    -- X"0052"  -- 0.0025   --16 
 -- );
 
 
constant lp_s0  : signed(15 downto 0) := X"0051";-- 0.0025    --0  
constant lp_s1  : signed(15 downto 0) := X"00BA"; -- 0.0057   --1  
constant lp_s2  : signed(15 downto 0) := X"01E1"; -- 0.0147   --2  
constant lp_s3  : signed(15 downto 0) := X"0408"; -- 0.0315   --3  
constant lp_s4  : signed(15 downto 0) := X"071A"; -- 0.0555   --4  
constant lp_s5  : signed(15 downto 0) := X"0AAC"; -- 0.0834   --5  
constant lp_s6  : signed(15 downto 0) := X"0E11"; -- 0.1099   --6  
constant lp_s7  : signed(15 downto 0) := X"107F"; -- 0.1289   --7  
constant lp_s8  : signed(15 downto 0) := X"1161"; -- 0.1358   --8  
constant lp_s9  : signed(15 downto 0) := X"107F"; -- 0.1289   --9 	
constant lp_s10 : signed(15 downto 0) := X"0E11"; -- 0.1099   --10 
constant lp_s11 : signed(15 downto 0) := X"0AAC"; -- 0.0834   --11 
constant lp_s12 : signed(15 downto 0) := X"071A"; -- 0.0555   --12 
constant lp_s13 : signed(15 downto 0) := X"0408"; -- 0.0315   --13 
constant lp_s14 : signed(15 downto 0) := X"01E1"; -- 0.0147   --14 
constant lp_s15 : signed(15 downto 0) := X"00BA"; -- 0.0057   --15 
constant lp_s16 : signed(15 downto 0) := X"0051"; -- 0.0025   --16 
-- constant high_pass: S_data :=
 -- (
	-- X"003E", -- 0.0019    --0  
	-- X"FF9B", -- -0.0031   --1  
    -- X"FE9F", -- -0.0108   --2  
    -- X"0000", -- 0.0   	  --3  
    -- X"0535", -- 0.0407    --4  
    -- X"05B2", -- 0.0445    --5  
    -- X"F5AC", -- -0.0807   --6  
    -- X"DAB7", -- -0.2913   --7  
    -- X"4C91", -- 0.5982    --8  
    -- X"DAB7", -- -0.2913   --9 	
    -- X"F5AC", -- -0.0807   --10 
    -- X"05B2", -- 0.0445    --11 
    -- X"0535", -- 0.0407    --12 
    -- X"0000", -- 0.0       --13 
    -- X"FE9F", -- -0.0108   --14 
    -- X"FF9B", -- -0.0031   --15 
    -- X"003E"  -- 0.0019    --16 
 -- );

 
constant hp_s0 	:signed(15 downto 0) :=  X"003E"; -- 0.0019    --0  
constant hp_s1 	:signed(15 downto 0) :=  X"FF9B"; -- -0.0031   --1  
constant hp_s2  :signed(15 downto 0) :=  X"FE9F"; -- -0.0108   --2  
constant hp_s3  :signed(15 downto 0) :=  X"0000"; -- 0.0   	  --3  
constant hp_s4  :signed(15 downto 0) :=  X"0535"; -- 0.0407    --4  
constant hp_s5  :signed(15 downto 0) :=  X"05B2"; -- 0.0445    --5  
constant hp_s6  :signed(15 downto 0) :=  X"F5AC"; -- -0.0807   --6  
constant hp_s7  :signed(15 downto 0) :=  X"DAB7"; -- -0.2913   --7  
constant hp_s8  :signed(15 downto 0) :=  X"4C91"; -- 0.5982    --8  
constant hp_s9  :signed(15 downto 0) :=  X"DAB7"; -- -0.2913   --9 	
constant hp_s10 :signed(15 downto 0) :=  X"F5AC"; -- -0.0807   --10 
constant hp_s11 :signed(15 downto 0) :=  X"05B2"; -- 0.0445    --11 
constant hp_s12 :signed(15 downto 0) :=  X"0535"; -- 0.0407    --12 
constant hp_s13 :signed(15 downto 0) :=  X"0000"; -- 0.0       --13 
constant hp_s14 :signed(15 downto 0) :=  X"FE9F"; -- -0.0108   --14 
constant hp_s15 :signed(15 downto 0) :=  X"FF9B"; -- -0.0031   --15 
constant hp_s16 :signed(15 downto 0) :=  X"003E"; -- 0.0019    --16 
 
type dataIn_shift is array (0 to 16) of signed(15 downto 0);
signal z1_out_sig              : dataIn_shift; 
--signal z1_out_sig : signed(15 downto 0);
signal z2_out_sig : signed(15 downto 0);
signal z3_out_sig : signed(15 downto 0);
signal z4_out_sig : signed(15 downto 0);
signal z5_out_sig : signed(15 downto 0);
signal z6_out_sig : signed(15 downto 0);
signal z7_out_sig : signed(15 downto 0);
signal z8_out_sig : signed(15 downto 0);
signal z9_out_sig : signed(15 downto 0);
signal z10_out_sig : signed(15 downto 0);
signal z11_out_sig : signed(15 downto 0);
signal z12_out_sig : signed(15 downto 0);
signal z13_out_sig : signed(15 downto 0);
signal z14_out_sig : signed(15 downto 0);
signal z15_out_sig : signed(15 downto 0);
signal z16_out_sig : signed(15 downto 0);

COMPONENT multiplier_component IS
	PORT
	(
		dataa		: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		datab		: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
end component multiplier_component ;

BEGIN

--Each Z-1 block represents an enabled register that only latches 
--its input data when its enable signal is active
Z1: PROCESS(clk,reset_n)
 BEGIN
 IF (clk'event AND clk = '1') THEN
	 IF (reset_n = '0') THEN
		 z1_out_sig <= (others=>(others=>'0'));
	 ELSIF (filter_en  = '1') THEN 
		  z1_out_sig(0) <= data_in; 
		  for idx in 1 to z1_out_sig'length-1 loop
      z1_out_sig(idx)    <= z1_out_sig(idx-1) ;
    end loop;
		
	 END IF;
 END IF;
 END PROCESS Z1;
 
--Each triangle represents a multiplier that multiplies the 
--input signal with the corresponding coefficient
--Each circle represents an adder

--****************************************************************************************************
--					
-- 									LOW PASS MULTIPLIER COMPONENTS
--****************************************************************************************************

low_pass_multcmpnt0 : multiplier_component PORT MAP (
		dataa	 => STD_LOGIC_VECTOR(data_in),--or I can put z10_out_sig(0), 
		datab	 => STD_LOGIC_VECTOR(lp_s0),--coeff(i)
		signed(result)	 => (multOutfull_lp0)
	);
	multOut_lp0 <= multOutfull_lp0(30 downto 15); 
--**************************************************************************************
low_pass_multcmpnt1 : multiplier_component PORT MAP (
--port map dataa to the signal at the triangle’s input
		dataa	 => STD_LOGIC_VECTOR(z1_out_sig(1)), 
		datab	 => STD_LOGIC_VECTOR(lp_s1),
		signed(result)	 => multOutfull_lp1
	);
	multOut_lp1 <= multOutfull_lp1(30 downto 15); 
--**************************************************************************************
low_pass_multcmpnt2 : multiplier_component PORT MAP (
		dataa	 => STD_LOGIC_VECTOR(z1_out_sig(2)), 
		datab	 => STD_LOGIC_VECTOR(lp_s2),
		signed(result)	 => multOutfull_lp2
	);
	multOut_lp2 <= multOutfull_lp2(30 downto 15); 
--**************************************************************************************
low_pass_multcmpnt3 : multiplier_component PORT MAP (
		dataa	 => STD_LOGIC_VECTOR(z1_out_sig(3)), 
		datab	 => STD_LOGIC_VECTOR(lp_s3),
		signed(result)	 => multOutfull_lp3
	);
	multOut_lp3 <= multOutfull_lp3(30 downto 15); 	
--**************************************************************************************
low_pass_multcmpnt4 : multiplier_component PORT MAP (
		dataa	 => STD_LOGIC_VECTOR(z1_out_sig(4)), 
		datab	 => STD_LOGIC_VECTOR(lp_s4),
		signed(result)	 => multOutfull_lp4
	);
	multOut_lp4 <= multOutfull_lp4(30 downto 15); 
--**************************************************************************************
low_pass_multcmpnt5 : multiplier_component PORT MAP (
		dataa	 => STD_LOGIC_VECTOR(z1_out_sig(5)), 
		datab	 => STD_LOGIC_VECTOR(lp_s5),
		signed(result)	 => multOutfull_lp5
	);
	multOut_lp5 <= multOutfull_lp5(30 downto 15); 
--**************************************************************************************
low_pass_multcmpnt6 : multiplier_component PORT MAP (
		dataa	 => STD_LOGIC_VECTOR(z1_out_sig(6)), 
		datab	 => STD_LOGIC_VECTOR(lp_s6),
		signed(result)	 => multOutfull_lp6
	);
	multOut_lp6 <= multOutfull_lp6(30 downto 15); 
--**************************************************************************************
low_pass_multcmpnt7 : multiplier_component PORT MAP (
		dataa	 => STD_LOGIC_VECTOR(z1_out_sig(7)), 
		datab	 => STD_LOGIC_VECTOR(lp_s7),
		signed(result)	 => multOutfull_lp7
	);
	multOut_lp7 <= multOutfull_lp7(30 downto 15); 
--**************************************************************************************
low_pass_multcmpnt8 : multiplier_component PORT MAP (
		dataa	 => STD_LOGIC_VECTOR(z1_out_sig(8)), 
		datab	 => STD_LOGIC_VECTOR(lp_s8),
		signed(result)	 => multOutfull_lp8
	);
	multOut_lp8 <= multOutfull_lp8(30 downto 15); 
--**************************************************************************************
low_pass_multcmpnt9 : multiplier_component PORT MAP (
		dataa	 => STD_LOGIC_VECTOR(z1_out_sig(9)), 
		datab	 => STD_LOGIC_VECTOR(lp_s9),
		signed(result)	 => multOutfull_lp9
	);
	multOut_lp9 <= multOutfull_lp9(30 downto 15); 
--**************************************************************************************
low_pass_multcmpnt10 : multiplier_component PORT MAP (
		dataa	 => STD_LOGIC_VECTOR(z1_out_sig(10)), 
		datab	 => STD_LOGIC_VECTOR(lp_s10),
		signed(result)	 => multOutfull_lp10
	);
	multOut_lp10 <= multOutfull_lp10(30 downto 15); 
--**************************************************************************************
low_pass_multcmpnt11 : multiplier_component PORT MAP (
		dataa	 => STD_LOGIC_VECTOR(z1_out_sig(11)), 
		datab	 => STD_LOGIC_VECTOR(lp_s11),
		signed(result)	 => multOutfull_lp11
	);
	multOut_lp11 <= multOutfull_lp11(30 downto 15); 
--**************************************************************************************
low_pass_multcmpnt12 : multiplier_component PORT MAP (
		dataa	 => STD_LOGIC_VECTOR(z1_out_sig(12)), 
		datab	 => STD_LOGIC_VECTOR(lp_s12),
		signed(result)	 => multOutfull_lp12
	);
	multOut_lp12 <= multOutfull_lp12(30 downto 15); 
--**************************************************************************************
low_pass_multcmpnt13 : multiplier_component PORT MAP (
		dataa	 => STD_LOGIC_VECTOR(z1_out_sig(13)), 
		datab	 => STD_LOGIC_VECTOR(lp_s13),
		signed(result)	 => multOutfull_lp13
	);
	multOut_lp13 <= multOutfull_lp13(30 downto 15); 
--**************************************************************************************
low_pass_multcmpnt14 : multiplier_component PORT MAP (
		dataa	 => STD_LOGIC_VECTOR(z1_out_sig(14)), 
		datab	 =>STD_LOGIC_VECTOR( lp_s14),
		signed(result)	 => multOutfull_lp14
	);
	multOut_lp14 <= multOutfull_lp14(30 downto 15); 
--**************************************************************************************
low_pass_multcmpnt15 : multiplier_component PORT MAP (
		dataa	 => STD_LOGIC_VECTOR(z1_out_sig(15)), 
		datab	 => STD_LOGIC_VECTOR(lp_s15),
		signed(result)	 => multOutfull_lp15
	);
	multOut_lp15 <= multOutfull_lp15(30 downto 15); 
--**************************************************************************************
low_pass_multcmpnt16 : multiplier_component PORT MAP (
		dataa	 => STD_LOGIC_VECTOR(z1_out_sig(16)), 
		datab	 => STD_LOGIC_VECTOR(lp_s16),
		signed(result)	 => multOutfull_lp16
	);
	multOut_lp16 <= multOutfull_lp16(30 downto 15); 
--**************************************************************************************
data_out <= multOut_lp0 + multOut_lp1 + multOut_lp2 +  multOut_lp3 +  multOut_lp4 +  multOut_lp5 +
			multOut_lp6 + multOut_lp7 + multOut_lp8 +  multOut_lp9 +  multOut_lp10 +  multOut_lp11 +
			multOut_lp12 + multOut_lp13 + multOut_lp14 +  multOut_lp15 +  multOut_lp16; 
--sum <= sum + mult_out(i)