library ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;


entity Top is

	port(		----- Clock -----
		
				clock  					         :in  std_logic;
			
				----- KEY -----
				KEY 							 		:in std_logic;
			
				----- switch -----
				SW								 		:in std_logic_vector(3 downto 0); --connect this to selection so that i know which filter to apply
				----- Adio Data Coming in -----
				DRAM_CLK,DRAM_CKE	 								: OUT STD_LOGIC;
				DRAM_ADDR			 								: OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
				DRAM_BA           								: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
				DRAM_CS_N,DRAM_CAS_N,DRAM_RAS_N,DRAM_WE_N	: OUT STD_LOGIC;
				DRAM_DQ												: INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				DRAM_UDQM,DRAM_LDQM								: OUT STD_LOGIC;
	
				AUD_ADCDAT 											: IN STD_LOGIC;
				AUD_ADCLRCK 										: INOUT STD_LOGIC;
				AUD_BCLK 											: INOUT  STD_LOGIC;
				AUD_DACDAT 											: OUT STD_LOGIC;
				AUD_DACLRCK 										: INOUT  STD_LOGIC;
				AUD_XCK                            		   : OUT STD_LOGIC;

              -- the_audio_and_video_config_0
				FPGA_I2C_SCLK	 							      : OUT STD_LOGIC;
				FPGA_I2C_SDAT	 								   : INOUT STD_LOGIC;

				
				LEDR 													: out  std_logic_vector(9 downto 0);
				
				GPIO_0                             		   : INOUT STD_LOGIC_VECTOR(35 downto 0)
			
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
			AUD_ADCDAT_to_the_audio_0   : in    std_logic                     := 'X';             -- ADCDAT
			AUD_ADCLRCK_to_the_audio_0  : in    std_logic                     := 'X';             -- ADCLRCK
			AUD_BCLK_to_the_audio_0     : in    std_logic                     := 'X';             -- BCLK
			AUD_DACDAT_from_the_audio_0 : out   std_logic;                                        -- DACDAT
			AUD_DACLRCK_to_the_audio_0  : in    std_logic                     := 'X';             -- DACLRCK
			clk_clk                     : in    std_logic                     := 'X';             -- clk
			i2c_SDAT                    : inout std_logic                     := 'X';             -- SDAT
			i2c_SCLK                    : out   std_logic;                                        -- SCLK
			pin_export                  : out   std_logic;                                        -- export
			reset_reset                 : in    std_logic                     := 'X';             -- reset
			sdram_addr                  : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_ba                    : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_cas_n                 : out   std_logic;                                        -- cas_n
			sdram_cke                   : out   std_logic;                                        -- cke
			sdram_cs_n                  : out   std_logic;                                        -- cs_n
			sdram_dq                    : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_dqm                   : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_ras_n                 : out   std_logic;                                        -- ras_n
			sdram_we_n                  : out   std_logic;                                        -- we_n
			sdram_clk_clk               : out   std_logic;                                        -- clk
			sw_export                   : in    std_logic_vector(3 downto 0)  := (others => 'X')  -- export
		);
	end component nios_system;

--------------------------                        
-- Signal Declarations
--------------------------

signal test_sig        					: std_logic;
    
signal Input_data 			 			: signed(15 downto 0)   := (others => '0');

signal output_data 			 			: signed(15 downto 0)   := (others => '0');

signal DRAM_DQM 							: std_logic_vector(1 DOWNTO 0);
signal int_AUD_BCLK  					: std_logic;
signal int_AUD_DACDAT  					: std_logic;
signal int_AUD_DACLRCK 					: std_logic; 
 
signal reset_n 				 			: std_logic;
signal key0_d1 				 			: std_logic;
signal key0_d2 				 			: std_logic;
signal key0_d3 				 			: std_logic;

signal count           					: std_logic_vector(3 downto 0);

-----------------------------------------------------			  
-----------------------------------------------------																	

BEGIN



	clkgen: process(clock, reset_n) 
	
		
		begin
			
			if (reset_n = '0') then
				
				LEDR <= "1111111111";
        
		  elsif (rising_edge(clock)) then
           
			  LEDR <= "0011001100";
			
			end if;
		
		end process;

-----------------------------------------------------			  		  
  ----- Audio Demo Code
-----------------------------------------------------   
   DRAM_UDQM <= DRAM_DQM(1);
	
	
	DRAM_LDQM <= DRAM_DQM(0);
   
	--int_AUD_BCLK <= AUD_BCLK;
 	
	GPIO_0(0) <= AUD_BCLK; 
	
	AUD_DACDAT <= int_AUD_DACDAT;
	
	GPIO_0(1) <= int_AUD_DACDAT;
   
	--int_AUD_DACLRCK <= AUD_DACLRCK;
 	
	GPIO_0(2) <= AUD_DACLRCK;   
	
	GPIO_0(3) <= test_sig;
	
	AUD_XCK <= count(1);	
-----------------------------------------------------			  		  
  ----- some clock process
----------------------------------------------------- 
	LED_Process: process(clock, reset_n) 
	
		
		begin
			
			if (reset_n = '0') then
				
				count <= "0000";
        
		  elsif (rising_edge(clock)) then
           
			  count <= count + 1;
			
			end if;
		
		end process;
 
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
			AUD_ADCDAT_to_the_audio_0   => AUD_ADCDAT,   					--     audio.ADCDAT
			AUD_ADCLRCK_to_the_audio_0  => AUD_ADCLRCK,  					--          .ADCLRCK
			AUD_BCLK_to_the_audio_0     => AUD_BCLK,     					--          .BCLK
			AUD_DACDAT_from_the_audio_0 => int_AUD_DACDAT,						 --          .DACDAT
			AUD_DACLRCK_to_the_audio_0  => AUD_DACLRCK, 						 --          .DACLRCK
			clk_clk                     => clock,                     --       clk.clk
			i2c_SDAT                    => FPGA_I2C_SDAT,                    --       i2c.SDAT
			i2c_SCLK                    => FPGA_I2C_SCLK,                    --          .SCLK
			pin_export                  => test_sig,                  --       pin.export
			reset_reset                 => not reset_n,                 --     reset.reset
			sdram_addr                  => DRAM_ADDR,                  --     sdram.addr
			sdram_ba                    => DRAM_BA,                    --          .ba
			sdram_cas_n                 => DRAM_CAS_N,                 --          .cas_n
			sdram_cke                   => DRAM_CKE,                   --          .cke
			sdram_cs_n                  => DRAM_CS_N,                  --          .cs_n
			sdram_dq                    => DRAM_DQ,                    --          .dq
			sdram_dqm                   => DRAM_DQM,                   --          .dqm
			sdram_ras_n                 => DRAM_RAS_N,                 --          .ras_n
			sdram_we_n                  => DRAM_WE_N,                  --          .we_n
			sdram_clk_clk               => DRAM_CLK,               -- sdram_clk.clk
			sw_export                   => SW                    --        sw.export
		);
    
end lowandHigh_pass_filter;