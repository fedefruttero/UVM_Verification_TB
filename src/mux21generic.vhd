library IEEE;
use IEEE.std_logic_1164.all;  --  libreria IEEE con definizione tipi standard logic
use WORK.constants.all;                 -- libreria WORK user-defined


entity MUX21_GENERIC is

  generic (bits : integer := 16);

  port (
    A : in  std_logic_vector (bits -1 downto 0);
    B : in  std_logic_vector (bits -1 downto 0);
    S : in  std_logic;
    Y : out std_logic_vector (bits -1 downto 0)
    );

end MUX21_GENERIC;



architecture BEHAVIORAL of MUX21_GENERIC is

begin
  Y <= A when S = '1' else B;

end BEHAVIORAL;



