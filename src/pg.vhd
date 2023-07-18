library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity PG is
  port (p_ik  : in  std_logic;
        g_ik  : in  std_logic;
        p_k1j : in  std_logic;
        g_k1j : in  std_logic;
        P_ij  : out std_logic;
        G_ij  : out std_logic);
end PG;

architecture BEHAVIORAL of PG is
begin
  P_ij <= p_ik and p_k1j;
  G_ij <= g_ik or (p_ik and g_k1j);

end architecture BEHAVIORAL;
