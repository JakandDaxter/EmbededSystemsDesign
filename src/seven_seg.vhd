-------------------------------------------------------------------------------
--THE DISPLAY
--(  )_ (  )
--(= '.' =)('')
--('')_('')
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY seven_seg IS
PORT(
      clk                               :in std_logic;
      reset                         :in std_logic;
    binary               :in Std_logic_vector (3 downto 0);--3 bits--unsigned
    seven_seg                : out std_logic_vector(6 downto 0)--3 seven seg displays
  );  
END seven_seg;

ARCHITECTURE structure OF seven_seg IS
--signal seven_seg_s1,seven_seg_s2,seven_seg_s3   :std_logic_vector(6 downto 0);--3 seven seg displays

CONSTANT ZERO   :STD_LOGIC_VECTOR(6 downto 0) := "1000000";
CONSTANT ONE    :STD_LOGIC_VECTOR(6 downto 0) := "1111001";
CONSTANT TWO    :STD_LOGIC_VECTOR(6 downto 0) := "0100100";
CONSTANT THREE  :STD_LOGIC_VECTOR(6 downto 0) := "0110000";
CONSTANT FOUR   :STD_LOGIC_VECTOR(6 downto 0) := "0011001";
CONSTANT FIVE   :STD_LOGIC_VECTOR(6 downto 0) := "0010010";
CONSTANT SIX    :STD_LOGIC_VECTOR(6 downto 0) := "0000010";
CONSTANT SEVEN  :STD_LOGIC_VECTOR(6 downto 0) := "1111000";
CONSTANT EIGHT  :STD_LOGIC_VECTOR(6 downto 0) := "0000000";
CONSTANT NINE   :STD_LOGIC_VECTOR(6 downto 0) := "0011000";
constant A      : std_logic_vector(6 downto 0) := "0001000";
CONSTANT B      : std_logic_vector(6 downto 0) := "0000011";
CONSTANT C      : std_logic_vector(6 downto 0) := "1000110";
CONSTANT D      : std_logic_vector(6 downto 0) := "0100001";
CONSTANT E      : std_logic_vector(6 downto 0) := "0000110";
CONSTANT F      : std_logic_vector(6 downto 0) := "0001110";

CONSTANT BLANK  :STD_LOGIC_VECTOR(6 downto 0) := "1111111";
CONSTANT DASH       :STD_LOGIC_VECTOR(6 downto 0) := "0111111";

BEGIN

  PROCESS(clk,reset,binary)
  BEGIN
        if (reset = '1') then 
        seven_seg <="1111111";
        elsif (clk'event and clk = '1' ) then
                  CASE binary IS
                          WHEN "0000" => seven_seg <= ZERO;
                          WHEN "0001" => seven_seg <= ONE;
                          WHEN "0010" => seven_seg <= TWO;
                          WHEN "0011" => seven_seg <= THREE;
                          WHEN "0100" => seven_seg <= FOUR;
                          WHEN "0101" => seven_seg <= FIVE;
                          WHEN "0110" => seven_seg <= SIX;
                          WHEN "0111" => seven_seg <= SEVEN;
                          WHEN "1000" => seven_seg <= EIGHT;
                          WHEN "1001" => seven_seg <= NINE;
                     WHEN "1010" => seven_seg <= A;
                     WHEN "1011" => seven_seg <= B;
                     WHEN "1100" => seven_seg <= C;
                     WHEN "1101" => seven_seg <= D;
                     WHEN "1110" => seven_seg <= E;
                     WHEN "1111" => seven_seg <= F;
                          WHEN OTHERS => seven_seg<= BLANK;
                  END CASE;
        end if;
  end process; 
END structure;