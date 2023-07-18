library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity G is
  port (p_ik  : in  std_logic;
        g_ik  : in  std_logic;
        g_k1j : in  std_logic;
        G_ij  : out std_logic);
end G;

architecture BEHAVIORAL of G is
begin
  G_ij <= g_ik or(p_ik and g_k1j);

end architecture BEHAVIORAL;
