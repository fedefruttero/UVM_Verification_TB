library IEEE;
use IEEE.std_logic_1164.all;
use WORK.constants.all;

entity TBREGISTERFILE is
end TBREGISTERFILE;

architecture TEST of TBREGISTERFILE is

  constant NBITS      : integer := 64;
  constant NREGISTERS : integer := 32;
  constant N          : integer := 3;   --Number of registers in each block
  constant F          : integer := 4;   --Number of windows
  constant M          : integer := 5;

  signal CLK         : std_logic                          := '0';
  signal RESET       : std_logic;
  signal ENABLE      : std_logic;
  signal RD1         : std_logic;
  signal RD2         : std_logic;
  signal WR          : std_logic;
  signal CALL        : std_logic                          := '0';
  signal SUB_RTN     : std_logic                          := '0';
  signal FILL        : std_logic;
  signal SPILL       : std_logic;
  signal ADD_WR      : std_logic_vector((log2(N*3+M))-1 downto 0);
  signal ADD_RD1     : std_logic_vector((log2(N*3+M))-1 downto 0);
  signal ADD_RD2     : std_logic_vector((log2(N*3+M))-1 downto 0);
  signal DATAIN      : std_logic_vector(NBITS-1 downto 0);
  signal OUT1        : std_logic_vector(NBITS-1 downto 0);
  signal OUT2        : std_logic_vector(NBITS-1 downto 0);
  signal MEM_BUS     : std_logic_vector(NBITS-1 downto 0);
  signal MEM_BUSread : std_logic_vector(NBITS-1 downto 0) := (others => '0');

  component REGISTER_FILE_WINDOWING

    generic (NBITS      : integer := 64;
             NREGISTERS : integer := 32;
             N          : integer := 3;   --Number of registers in each block
             F          : integer := 4;   --Number of windows
             M          : integer := 5);  --Global register number

    port (CLK         : in  std_logic;
          RESET       : in  std_logic;
          ENABLE      : in  std_logic;
          RD1         : in  std_logic;
          RD2         : in  std_logic;
          WR          : in  std_logic;
          CALL        : in  std_logic;
          SIGRETURN   : in  std_logic;
          ADD_WR      : in  std_logic_vector((log2(N*3+M+1))-1 downto 0);
          ADD_RD1     : in  std_logic_vector((log2(N*3+M+1))-1 downto 0);
          ADD_RD2     : in  std_logic_vector((log2(N*3+M+1))-1 downto 0);
          DATAIN      : in  std_logic_vector(NBITS-1 downto 0);
          OUT1        : out std_logic_vector(NBITS-1 downto 0);
          OUT2        : out std_logic_vector(NBITS-1 downto 0);
          MEM_BUS     : out std_logic_vector(NBITS-1 downto 0);
          MEM_BUSread : in  std_logic_vector(NBITS-1 downto 0);
          FILL        : out std_logic;
          SPILL       : out std_logic);

  end component;

begin

  RG : REGISTER_FILE_WINDOWING

    generic map (NBITS, NREGISTERS, N, F, M)
    port map (CLK, RESET, ENABLE, RD1, RD2, WR, CALL, SUB_RTN, ADD_WR, ADD_RD1, ADD_RD2, DATAIN, OUT1, OUT2, MEM_BUS, MEM_BUSread, FILL, SPILL);

  STIMULUS1 : process
  begin
    ------------------------------- TIME 0 --------------------------------------------
    ------------------------------ WINDOW 0 -------------------------------------------
    RESET  <= '1', '0' after 5 ns;
    ENABLE <= '1';
    RD1    <= '1';
    RD2    <= '1';
    WR     <= '1';

    DATAIN  <= X"0F0FABA2564F45AA", X"5678543267ABDDDD" after 10 ns;
    ADD_WR  <= "0000", "0001"                           after 10 ns;
    ADD_RD1 <= "0000";
    ADD_RD2 <= "0000";
    wait for 20 ns;
    ADD_WR  <= "0100", "0111"                           after 10 ns;
    ADD_RD1 <= "0000";
    ADD_RD2 <= "0001";

    wait for 10 ns;
    ------------------------------- 30 ns ---------------------------------------------
    DATAIN  <= X"FFFFFFFFFFFFFFFF", X"1234123412341234" after 10 ns;
    ADD_WR  <= "0101", "0110"                           after 10 ns;
    ADD_RD1 <= "0101";
    wait for 10 ns;

    ------------------------------- 40 ns ---------------------------------------------
    DATAIN <= X"5678567856785678", X"6543654365436543" after 10 ns;
    ADD_WR <= "0111", "1000"                           after 10 ns;

    wait for 20 ns;
    --------------------------------- 60 ns ---------------------------------------------
    ---------------------First Subroutine call: WINDOW1 -------------------------------
    CALL    <= '1', '0'                                 after 1 ns;
    wait for 2 ns;
    DATAIN  <= X"AAAAAAAAAAAAAAAA", X"1234567891234567" after 10 ns;
    ADD_WR  <= "0101", "0110"                           after 10 ns;
    ADD_RD1 <= "0101", "0110"                           after 10 ns;

    wait for 20 ns;
---------------------------------- 62 ns ----------------------------------------------
-----------------------Second subroutine call: WINDOW2 --------------------------------
    CALL    <= '1', '0'                                 after 1 ns;
    DATAIN  <= X"8888888888888888", X"4444444444444444" after 10 ns;
    ADD_WR  <= "1011", "1100"                           after 10 ns;
    ADD_RD1 <= "1011", "1100"                           after 10 ns;

    wait for 20 ns;
--------------------------------- 55 ns -------------------- FUNCTIONAL UP TO HERE
    -------------------Third subrouting:
    -------------------WINDOW3---------------------------------------
    CALL    <= '1', '0'                                 after 1 ns;
    DATAIN  <= X"1111111111111111", X"2222222222222222" after 10 ns;
    ADD_WR  <= "0110", "0111"                           after 10 ns;
    ADD_RD1 <= "0110", "0111"                           after 10 ns;

    wait for 20 ns;
--------------------------------- 65 ns ----------------------------------------------
    --Fourth subroutine call, we will spill
    CALL   <= '1', '0'                                 after 1 ns;
    wait for 10 ns;
    DATAIN <= X"3333333333333333", X"4444444444444444" after 10 ns;
    ADD_WR <= "0111", "1000"                           after 10 ns;  --WRITE THE
    wait for 20 ns;
    ADD_WR <= "0110", "1001"                           after 10 ns;
    wait for  30 ns;
    ADD_WR <= "1010";
    wait for 2 ns;
    ADD_WR <= "0101";

    wait for 20 ns;
-------------------------------- 70 ns -----------------------------------------------
    SUB_RTN <= '1', '0' after 1 ns;
    wait for 15 ns;
    SUB_RTN <= '1', '0' after 1 ns;
    wait for 15 ns;
    SUB_RTN <= '1', '0' after 1 ns;
    wait for 15 ns;
    ADD_WR <= "0000";
    SUB_RTN <= '1', '0' after 1 ns;
    
    wait for 0.5 ns;
    MEM_BUSread <= X"FFFFFFFFFFFFFFFF";
    wait for 1.5 ns;
    MEM_BUSread <= X"0000000000000000", X"5678567856785678" after 1 ns;
    wait for 2 ns;
    MEM_BUSread <= X"6543654365436543", X"0000000000000000" after 1 ns;

    wait for 30 ns;
    RESET <= '1','0' after 10 ns;

    wait for 800 ns;

  end process;

  PCLOCK : process(CLK)
  begin
    CLK <= not(CLK) after 0.5 ns;
  end process;

end TEST;

---
configuration CFG_TESTRF of TBREGISTERFILE is
  for TEST
    for RG : REGISTER_FILE_WINDOWING
      use configuration WORK.CFG_RF_BEH;
    end for;
  end for;
end CFG_TESTRF;

