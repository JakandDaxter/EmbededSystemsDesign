-------------------------------------------------------------------------------
--THE TOP
--(  )_ (  )
--(= '.' =)('')
--('')_('')
-------------------------------------------------------------------------------
LIBRARY ieee;
use ieee.std_logic_1164.all;   
USE ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.my_components.all;

ENTITY top_level is
Port(
       clk                                      : in std_logic; 
       --reset                                    : in std_logic;
	   mr                                       : in std_logic;--pushbutton
	   ms                                       : in std_logic;--pushbutton
	   execute                                  : in std_logic;--pushbutton
	   resetBtn									: in std_logic;--pushbutton
       switch									: in std_logic_vector(7 downto 0);--A and B
	   op										: in std_logic_vector(1 downto 0);--chooses the ALU operation 
       Hex0,Hex1,Hex2                         	: out std_logic_Vector(6 downto 0);
       LED                                   	: out std_logic_Vector(4 downto 0) --outputs the states
);
end top_level;
architecture structure of top_level is
constant Read_w        		: std_logic_vector(4 downto 0):= "00001";--signal for State Read_working
constant Write_w_no_op      : std_logic_vector(4 downto 0):= "00010";--signal for State Write_w_no_op
constant Write_w      		: std_logic_vector(4 downto 0):= "00100";--signal for Sum state
constant Write_s     		: std_logic_vector(4 downto 0):= "01000";--signal for Subtract State
constant Read_s    	 		: std_logic_vector(4 downto 0):= "10000";--signal for Subtract State


signal state_reg         : std_logic_vector(4 downto 0);--current state
signal state_next        : std_logic_vector(4 downto 0);--next state


signal A_sig             :std_logic_vector(7 downto 0);--anumbersync
signal B_sig             :std_logic_vector(7 downto 0);--bnumbersync

signal ones              :STD_LOGIC_VECTOR (3 downto 0);--from double dabber
signal tens              :STD_LOGIC_VECTOR (3 downto 0);--from double dabber
signal hundreds          :STD_LOGIC_VECTOR (3 downto 0);--from double dabber
signal result_padded     :std_logic_vector(11 downto 0); --from double dabber

signal result_sig        :std_logic_vector(7 downto 0);---result 8 bits--from ALU
signal bypass            :std_logic_vector(7 downto 0);---result 8 bits--From memory
signal output            :std_logic_vector(7 downto 0);--- 8 bits--output to be given to the Double Dabber


signal write_enable        :std_logic;
signal addr				   :std_logic_vector(1 downto 0);--to choose between the working or save register
signal exec				   :std_logic;--execute
signal mem_r			   :std_logic;--memory recall to retrieve values from the memory
signal mem_s			   :std_logic;--memory save to save the present result in memory
signal reset_n	   		   :std_logic;

signal switch_sync        :std_logic_vector(7 downto 0);--switch input
signal op_sync        :std_logic_vector(1 downto 0);--op input




--**************************************************************************************************************************************
--*********************************************--
--            Double Dabble         --
--*********************************************--
Begin
bcd1: process(result_padded)

  -- temporary variable
  variable temp : STD_LOGIC_VECTOR (11 downto 0);
  
  -- variable to store the output BCD number
  -- organized as follows
  -- thousands = bcd(15 downto 12)
  -- hundreds = bcd(11 downto 8)
  -- tens = bcd(7 downto 4)
  -- units = bcd(3 downto 0)
  variable bcd : UNSIGNED (15 downto 0) := (others => '0');

  -- by
  -- https://en.wikipedia.org/wiki/Double_dabble
  
  begin
    -- zero the bcd variable
    bcd := (others => '0');
    
    -- read input into temp variable
    temp(11 downto 0) := result_padded;
    
    -- cycle 12 times as we have 12 input bits
    -- this could be optimized, we dont need to check and add 3 for the 
    -- first 3 iterations as the number can never be >4
    for i in 0 to 11 loop
      if bcd(3 downto 0) > 4 then 
        bcd(3 downto 0) := bcd(3 downto 0) + 3;
      end if;
      
      if bcd(7 downto 4) > 4 then 
        bcd(7 downto 4) := bcd(7 downto 4) + 3;
      end if;
    
      if bcd(11 downto 8) > 4 then  
        bcd(11 downto 8) := bcd(11 downto 8) + 3;
      end if;

      -- thousands can't be >4 for a 12-bit input number
      -- so don't need to do anything to upper 4 bits of bcd
    
      -- shift bcd left by 1 bit, copy MSB of temp into LSB of bcd
      bcd := bcd(14 downto 0) & temp(11);
    
      -- shift temp left by 1 bit
      temp := temp(10 downto 0) & '0';
    
    end loop;
 
    -- set outputs
    ones <= STD_LOGIC_VECTOR(bcd(3 downto 0));--hex0
    tens <= STD_LOGIC_VECTOR(bcd(7 downto 4));--hex1
    hundreds <= STD_LOGIC_VECTOR(bcd(11 downto 8));--hex2
    --thousands <= STD_LOGIC_VECTOR(bcd(15 downto 12));
  end process bcd1; 


  
  
-------------------------------execute button-------------------
uut_execButton1: rising_edge_synchronizer 
  port map(
    clk               => clk,
    reset             => reset_n,
    input             => execute,
    edge              => exec
  );
-------------------------------memory read button-------------------
uut_execButton2: rising_edge_synchronizer 
  port map(
    clk               => clk,
    reset             => reset_n,
    input             => mr,
    edge              => mem_r
  );
-------------------------------memory save button-------------------
uut_execButton3: rising_edge_synchronizer 
  port map(
    clk               => clk,
    reset             =>  reset_n,
    input             => ms,
    edge              => mem_s
  );

--************************************For switch Input******************************************************************************************************
uut_switch8bit: Generic_synchronizer 
generic map (
    bits    => 8
  )
  port map (
    clk               => clk,
    reset             => reset_n,
    async_in          => switch,--------------problem
    sync_out          => switch_sync-- switch input synchronized 
  );
 --************************************For op Input******************************************************************************************************
uut_op2bit: Generic_synchronizer 
generic map(
    bits   => 2
  )
  port map (
    clk               => clk,
    reset             => reset_n,
    async_in          => op,
    sync_out          => op_sync--op input synchronized 
  );
--*******************************************************************************************************************************************
uutss_0: seven_seg  
  port map(
	clk       	=> clk,
	reset     	=> reset_n,
    binary    	=> ones,--from double dabber
    seven_seg 	=> Hex0
  );
--*********************************************************************************************************************************************
uutss_1: seven_seg  
  port map(
	clk       	=> clk,
	reset     	=> reset_n,
    binary   	=> tens,--from double dabber
    seven_seg 	=> Hex1
  );
--*********************************************************************************************************************************************
uutss_2: seven_seg  
  port map(
	clk       	=> clk,
	reset     	=> reset_n,
    binary    	=> hundreds,--from double dabber
    seven_seg 	=> Hex2
  );
--*********************************************************************************************************************************************
  ALU_uut: ALU 
  port map(
  
	clk   	   => clk,
	reset      =>reset_n,
	a          => B_sig,-----------------------------????????????
	b          => A_sig,-----------------------------????????????
	op         => op_sync,
	result     => result_sig
  );
--*********************************************************************************************************************************************
  mem_uut: memory 
  port map(
  clk   	   => clk,
  we           => write_enable,
  addr         => addr,
  din          => output,
  dout         => B_sig
  );
--**************************************--*********************************************--
--            StateMachine         --
-- --*********************************************-
--********************************************************************************************************
-- state register
process(clk,reset_n)
begin 
  if (reset_n = '1') then --active high reset switch//maybr resetBtn
    state_reg <= read_w;-- state Read Working is the reset default state
  elsif (clk'event and clk = '1') then
    state_reg <= state_next;--advances state machine
  end if;
end process;
-- next state logic
process(state_reg,write_enable,addr,exec,mem_r,mem_s)--current state and inputs	
begin
  -- default values
  state_next <= state_reg ;--default value for current state
  case state_reg is  
    when Read_w =>
		write_enable <='0';
		addr <= "00";--00 is for the working state
      if ( exec = '1') then
        state_next <= Write_w_no_op;--go to write with no operation State  
		  elsif ( mem_s ='1') then
		  state_next <= Write_s;--go to the write save state
		   elsif (mem_r = '1') then
			state_next <= Read_s;
	  end if;
     
    when Write_w_no_op => 
        state_next <= Write_w;--go to write working state
     
     
    when Write_w =>
		  write_enable <= '1';
		  addr <= "00";--00 is for working register
        state_next <= Read_w;--go to read working state
    
	when Write_s =>
		write_enable <= '1';
		addr		 <= "01";--01 is for the save register
		state_next <= Read_w;-- go to read working state--????????????????????????????????????????
	
	when Read_s =>
		write_enable <='0';
		addr 		 <="01";--01 is for the save register
	  if (exec = '1') then
		state_next <= Write_w_no_op;
      end if;
    when others =>
      state_next <= Read_w;--default state
  end case;
end process;      
      
--need a mux to determine if the input is from the ALU or the memory     
      Inputmux: process (reset_n,clk, result_sig,B_sig)
      begin
         if reset_n='1' then
		  output <="00000000";
		 
         elsif (clk'event and clk = '1') then
            if (state_reg = Write_w_no_op) then --no operation
			output <= result_sig;--result sig is from the ALU
            
			 
            elsif (state_reg = read_s) then--read save
			output <= B_sig;--bypass is from the memory
            
            end if;
         end if;
    end process;

      
	  --output can either come from the ALU or the memory
	  --make a signal for output
      
      result_padded <= "0000" & output;--output is 8 bits
      LED <= state_reg;
	 
	  reset_n <= not resetBtn;	
	  A_sig<= switch_sync;--A sig is always from the switches
	 
 
end structure;

