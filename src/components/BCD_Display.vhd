-------------------------------------------------------------------------------
--THe DISPLAY DRIVER
--(  )_ (  )
--(= '.' =)('')
--('')_('')
-------------------------------------------------------------------------------
Library ieee;
USE ieee.std_logic_1164.ALL;


ENTITY BCD_Display IS

PORT(
      clk: IN STD_LOGIC;
      reset : IN STD_LOGIC;
      Bin :IN STD_LOGIC_VECTOR(3 downto 0);                             
      Hex :OUT STD_LOGIC_VECTOR(6 downto 0)
      );
      
END BCD_Display;
Architecture arc OF BCD_Display IS
-- States what the output should be for each hex SSD value set
  constant Blank  : std_logic_vector(6 downto 0) := "1111111";
  constant ZERO   : std_logic_vector(6 downto 0) := "1000000";
  constant ONE    : std_logic_vector(6 downto 0) := "1111001";
  constant TWO    : std_logic_vector(6 downto 0) := "0100100";
  constant THREE  : std_logic_vector(6 downto 0) := "0110000";
  constant FOUR   : std_logic_vector(6 downto 0) := "0011001";
  constant FIVE   : std_logic_vector(6 downto 0) := "0010010";
  constant SIX    : std_logic_vector(6 downto 0) := "0000010";
  constant SEVEN  : std_logic_vector(6 downto 0) := "1111000";
  constant EIGHT  : std_logic_vector(6 downto 0) := "0000000";
  constant NINE   : std_logic_vector(6 downto 0) := "0011000";
  constant A      : std_logic_vector(6 downto 0) := "0001000";
  constant B      : std_logic_vector(6 downto 0) := "0000011";
  constant C      : std_logic_vector(6 downto 0) := "1000110";
  constant D      : std_logic_vector(6 downto 0) := "0100001";
  constant E      : std_logic_vector(6 downto 0) := "0000110";
  constant F      : std_logic_vector(6 downto 0) := "0001110";
  constant P      : std_logic_vector(6 downto 0) := "0011000";
  constant O      : std_logic_vector(6 downto 0) := "0000000";

BEGIN

Process(clk,reset,Bin)
  BEGIN
      if(reset = '1') THEN
          Hex <= Blank;
          
       elsif(clk'event and clk = '1') THEN
  -- Takes hex input 4 bits and converts to SSD value from its constant
          CASE Bin IS
          WHEN "0001" => Hex <= O; 
          WHEN "0010" => Hex <= A;
          WHEN "0100" => Hex <= P;
          WHEN "1000" => Hex <= F;
          WHEN OTHERS => Hex <= Blank;
        END CASE;
	End IF;
      End process;
	
END arc;