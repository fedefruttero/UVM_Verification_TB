library IEEE;
use IEEE.std_logic_1164.all;


entity SUMGENERATOR is
  generic (NBITS           : integer := 32;
           BITS_PER_MODULE : integer := 4;
           NUM_MODULES     : integer := 8);

  port(A  : in  std_logic_vector(BITS_PER_MODULE*NUM_MODULES-1 downto 0);
       B  : in  std_logic_vector(BITS_PER_MODULE*NUM_MODULES-1 downto 0);
       Ci : in  std_logic_vector(NUM_MODULES downto 0);
       S  : out std_logic_vector(BITS_PER_MODULE*NUM_MODULES-1 downto 0)
       );
end SUMGENERATOR;

architecture STRUCTURAL of SUMGENERATOR is

  component CarrySelect
    port (
      A   : in  std_logic_vector(3 downto 0);  --each input 4 bits
      B   : in  std_logic_vector(3 downto 0);
      Cin : in  std_logic;
      S   : out std_logic_vector(3 downto 0)
      );
  end component;

begin

--Instantiate CarrySelect blocks in a loop

  carrySels : for i in 0 to NUM_MODULES-1 generate
    carrySel : CarrySelect
      port map(A(i*BITS_PER_MODULE + BITS_PER_MODULE-1 downto i*BITS_PER_MODULE),
               B(i*BITS_PER_MODULE + BITS_PER_MODULE-1 downto i*BITS_PER_MODULE),
               Ci(i),
               S(i*BITS_PER_MODULE + BITS_PER_MODULE-1 downto i*BITS_PER_MODULE));
  end generate;

end STRUCTURAL;

configuration CFG_SUM_GENERATOR_STRUCTURAL of SUMGENERATOR is
  for STRUCTURAL
--    generic map(
--      NBITS => 32,
--      BITS_PER_MODULE => 4,
--      NUM_MODULES => 8
--      );
      end for;
  end CFG_SUM_GENERATOR_STRUCTURAL;
