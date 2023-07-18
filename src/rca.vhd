library ieee;
use ieee.std_logic_1164.all;


entity RCA is
  generic (NBITS : integer := 32);
  port (A  : in  std_logic_vector(NBITS-1 downto 0);
        B  : in  std_logic_vector(NBITS-1 downto 0);
        Ci : in  std_logic;
        S  : out std_logic_vector(NBITS-1 downto 0);
        Co : out std_logic);
end RCA;


architecture BEHAVIORAL of RCA is
begin
  process(A, B, Ci)
    variable carry : std_logic := '0';
  begin
    for i in 0 to NBITS-1 loop
      S(i)  <= (A(i) xor B(i) xor carry xor Ci);
      carry := ((A(i) and B(i)) or (A(i) and carry) or (B(i) and carry));
    end loop;
    Co    <= carry;
    carry := '0';
  end process;

end BEHAVIORAL;


configuration CFG_RCA_BEHAVIORAL of RCA is
  for BEHAVIORAL
  end for;
end CFG_RCA_BEHAVIORAL;
