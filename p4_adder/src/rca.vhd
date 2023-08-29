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

architecture STRUCTURAL of RCA is

  signal STMP : std_logic_vector(NBITS-1 downto 0);
  signal CTMP : std_logic_vector(NBITS downto 0);

  component FA
    port (A  : in  std_logic;
          B  : in  std_logic;
          Ci : in  std_logic;
          S  : out std_logic;
          Co : out std_logic);
  end component;

begin

  CTMP(0) <= Ci;
  S       <= STMP;
  Co      <= CTMP(NBITS);

  ADDER1 : for I in 1 to NBITS generate
    FAI : FA
      port map (A(I-1), B(I-1), CTMP(I-1), STMP(I-1), CTMP(I));
  end generate;

end STRUCTURAL;


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

configuration CFG_RCA_STRUCTURAL of RCA is
  for STRUCTURAL
    for ADDER1
      for all : FA
        use configuration WORK.CFG_FA_BEHAVIORAL;
      end for;
    end for;
  end for;
end CFG_RCA_STRUCTURAL;

configuration CFG_RCA_BEHAVIORAL of RCA is
  for BEHAVIORAL
  end for;
end CFG_RCA_BEHAVIORAL;
