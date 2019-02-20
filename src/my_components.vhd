-------------------------------------------------------------------------------
--THE COMPONENts
--(  )_ (  )
--(= '.' =)('')
--('')_('')
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package my_components is
  component rising_edge_synchronizer is 
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    input             : in std_logic;
    edge              : out std_logic
  );
end component;
--***************************************************************************************************************************************
component Generic_synchronizer is
 generic (
    bits    : integer := 8
  );
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    async_in          : in  std_logic_vector(bits-1 downto 0);--8 bit input
    sync_out          : out  std_logic_vector(bits-1 downto 0)--8 bit output
  );
end component;
--***************************************************************************************************************************************
component seven_seg is ---
port(
    clk                   :in std_logic;
    reset               :in std_logic;
    binary               :in Std_logic_vector (3 downto 0);--3 bits--unsigned
    seven_seg          :out std_logic_vector(6 downto 0)--3 seven seg display
    );
end component;
--****************************************************************************************************************************************
component ALU is 
 port (
    clk           : in  std_logic;
    reset         : in  std_logic;
    a             : in  std_logic_vector(7 downto 0); 
    b             : in  std_logic_vector(7 downto 0);
    op            : in  std_logic_vector(1 downto 0); -- 00: add, 01: sub, 10: mult, 11: div
    result        : out std_logic_vector(7 downto 0)
  );  
end component;
--************************************************************************************************************************* ***************
component memory is 
generic (addr_width : integer := 2;-- 4x8 memory 2^2=4, 2^A=N
           data_width : integer := 8);
  port (
    clk               : in std_logic;
    we                : in std_logic;
    addr              : in std_logic_vector(addr_width - 1 downto 0);
    din               : in std_logic_vector(data_width - 1 downto 0);
    dout              : out std_logic_vector(data_width - 1 downto 0)
  );
end component;
end my_components;