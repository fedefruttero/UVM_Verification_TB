----------------------------------------------------------------------------------------------------------
-- Title      : Register File Windowed
-- Project    : lab 3
----------------------------------------------------------------------------------------------------------
-- File      : registerfileWindowing.vhd
-- Author    : ms23.13
-----------------------------------------------------------------------------------------------------------
-- Description: This file contains the behavioral description of a register
-- file of 32 registers of 64 bits each. The RF has the possibility to read and
-- write at the same time. The feature of windowing is implemented
--
--
-----------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use WORK.constants.all;


entity REGISTER_FILE_WINDOWING is
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
        FILL        : out std_logic := '0';
        SPILL       : out std_logic := '0'
        );

end REGISTER_FILE_WINDOWING;


architecture BEHAVIORAL of REGISTER_FILE_WINDOWING is

  -- Matrix of physical registers
  subtype REG_ADDR is natural range 0 to NREGISTERS-1;
  type REG_ARRAY is array(REG_ADDR) of std_logic_vector(NBITS-1 downto 0);
  signal REGISTERS  : REG_ARRAY;
  -- Counters used during the spilling and the filling
  signal i          : integer   := 0;
  signal j          : integer   := 0;
  -- Current window pointers and Save window pointers (last one initialized to a garbage value) 
  signal SWP        : integer   := 10000;
  signal CWP        : integer   := 0;
  -- Registers used for storing information related to the Spilling and filling
  signal CANSAVE    : boolean   := true;
  signal CANRESTORE : boolean   := true;
  -- Flags used for state control
  signal SPILLING   : std_logic := '0';
  signal FILLING    : std_logic := '0';

-- Each clock cycle the system can be in one of those states:
--  ___________________________________________________________________________________________
-- | STATE              | FUNCTION                                         | CONTROL SIGNALS   |                          
-- |____________________|__________________________________________________|___________________|
-- | RESET              | The registers are put to zero                    | RESET             |
-- | CALL               | There is a call by a subroutine                  | CALL              |
-- | RETURN             | There is a return from a subroutine              | SIGRETURN         |
-- | SPILL              | The register file is full, needs to use the MMU  | SPILLING          |
-- | FILL               | data to retrieve from MMU                        | FILLING           |
-- | REGISTER FILE USAGE| Access the physical register file                | ENABLE            |
-- |___________________________________________________________________________________________|

begin
  process(CLK)
    variable varCWP        : integer;
    variable varCANSAVE    : boolean;
    variable varCANRESTORE : boolean;
  begin
    -- RESET STATE (Synchronous)
    if rising_edge(CLK) then
      varCWP        := CWP;
      varCANSAVE    := CANSAVE;
      varCANRESTORE := CANRESTORE;

      if RESET = '1' then

        REGISTERS <= (others => (others => '0'));
        OUT1      <= (others => '0');
        OUT2      <= (others => '0');
      
-- CALL STATE
      ---- Update the CWP
      ------ If the CWP reach the end of the physical register file, is resetted (circular) and the CANSAVE is 0 (you'll need the MMU)
      --------- If CANSAVE is 0, the SPILL output is asserted in order to inform the MMU to be ready to receive data
      --------- The SPILLING flag is asserted in order to change the state at the next clock cycle
      elsif CALL = '1' then

        CWP <= (CWP + (2*N));

        varCWP := (CWP + (2*N));
        if (varCWP = 2*N*F) then
          CWP        <= 0;
          CANSAVE    <= false;
          varCANSAVE := false;
        end if;


        if varCANSAVE = false then
          SPILLING <= '1';
          SPILL    <= '1';
        end if;
      
      -- RETURN STATE
      ---- Update the CWP
      ------ If the CWP is at the start of the physical register file, goes to the end (circular)
      ------ Check if the SWP = CWP, because in this case CANRESTORE = 0, you need to ask data to MMU
      -------- If CANRESTORE = 0, set the flag in order to change the state at the next clock cycle
      -------- and set FILL in order to ask the MMU for data
      elsif SIGRETURN = '1' then

        if CWP = 0 then
          CWP    <= (2*N*(F-1));
          varCWP := (2*N*(F-1));
        else
          CWP    <= (CWP - (2*N));
          varCWP := (CWP - (2*N));
        end if;

--since the signal is updated in the following clock cycle, here we are comparing the old value of CWP with SWP.
        if varCWP = SWP then  
          CANRESTORE    <= false;
          varCANRESTORE := false;
        end if;

        if varCANRESTORE = false then
          FILLING <= '1';
          FILL    <= '1';
        end if;
      

      -- SPILL STATE
      ---- Every clock cycle there is a spill of a register to the memory
      ---- The registers are indexed with i, which increases each iteration, starting from zero
      ---- When i = (2*N), you spilled all the registers
      ---- After that you update the SWP, which is indexed with j, start from zero and is increased by 2*N every window's spill iteration
      ---- The SPILL signal is resetted: the MMU can rest
      elsif CANSAVE = false and SPILLING = '1' then

        if i = (2*N) then
          SPILL    <= '0';
          SWP      <= j;
          j        <= j + (2*N);
          i        <= 0;
          SPILLING <= '0';
        else
          MEM_BUS <= REGISTERS(i + M + CWP);  --escludendo i globali
          i       <= i + 1;
        end if;
      
      -- FILL STATE
      ---- In this state the system take the data from the mmu through the bus and restore all the registers spilled before
      ---- Every clock cycle there is a FILL and they are managed by the index i
      ---- If i = 2*N you have filled all the registers, so FILL = 0 : the MMU can rest
      ---- Update the SWP: if is zero, put it to an invalid value
      elsif CANRESTORE = false and FILLING = '1' then

        if i = (2*N) then
          FILL    <= '0';
          i       <= 0;
          FILLING <= '0';

          if SWP = 0 then
            SWP <= 100000;
          else
            SWP <= SWP - (2*N);
          end if;
        else
          REGISTERS(i + M + CWP) <= MEM_BUSread;
          i                      <= i + 1;
        end if;
      

      -- REGISTER FILE USAGE STATE
      ---- In this state you add to the address given by the subroutine the offset of the window assigned to that subroutine
      ---- The offset is equal to the CWP if you want to use registers of the blocks IN, LOCAL, OUT, otherwise is equal to the
      ---- address itself for the global registers. Indeed, the physical organization of the register file looks like that
      ----  ______________
      ---- |____GLOBAL____|
      -----|____GLOBAL____|         _______________
      ---- |______IN______|           WINDOW 0
      -----|______IN______|
      ---- |_____LOCAL____|
      -----|_____LOCAL____|         ________________
      ---- |____OUT/IN____|            WINDOW 1
      -----|____OUT/IN____|
      ---- |_____LOCAL____|                .
      -----|_____LOCAL____|                .
      ---- |____OUT/IN____|                .
      -----|____OUT/IN____|
      -- The global are always at the first two registers for all the windows, the other register change with the window

      elsif ENABLE = '1' and SPILLING = '0' then


        -- check if the address is for the global, otherwise increment by cwp
        if RD1 = '1' then
          if (to_integer(unsigned(ADD_RD1))) < M then
            OUT1 <= REGISTERS(to_integer(unsigned(ADD_RD1)));
          else
            OUT1 <= REGISTERS((to_integer(unsigned(ADD_RD1))) + CWP);
          end if;
        end if;

        if RD2 = '1' then
          if (to_integer(unsigned(ADD_RD2))) < M then
            OUT2 <= REGISTERS(to_integer(unsigned(ADD_RD2)));
          else
            OUT2 <= REGISTERS((to_integer(unsigned(ADD_RD2))) + CWP);
          end if;
        end if;

        if WR = '1' then
          if (to_integer(unsigned(ADD_WR))) < M then
            REGISTERS(to_integer(unsigned(ADD_WR))) <= DATAIN;
          else
            REGISTERS((to_integer(unsigned(ADD_WR))) + CWP) <= DATAIN;
          end if;
        end if;
      end if;
    end if;
  end process;
end BEHAVIORAL;


configuration CFG_RF_BEH of REGISTER_FILE_WINDOWING is
  for BEHAVIORAL
  end for;
end configuration;

