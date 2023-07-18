----------------------------------------------------------------------------------------------------------
-- Title      : Carry Look Ahead Sparse Tree
-- Project    : lab 2
----------------------------------------------------------------------------------------------------------
-- File      : CLA_SPARSE_TREE.vhd
-- Author    : ms23.13
-----------------------------------------------------------------------------------------------------------
-- Description: This file contains the structural description of the sparse tree of the pentium 4
--       
--
-----------------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use WORK.constants.all;


entity CLA_SPARSE_TREE is
  generic (NBITS         : integer := 32;
           NBITS_CARRIES : integer := 4);

  port(
    A    : in  std_logic_vector(NBITS downto 1);
    B    : in  std_logic_vector(NBITS downto 1);
    C0   : in  std_logic;
    COUT : out std_logic_vector(NBITS/NBITS_CARRIES downto 0)
    );

end CLA_SPARSE_TREE;


architecture STRUCTURAL of CLA_SPARSE_TREE is


  type vector_t is array (NBITS downto 1) of std_logic_vector(NBITS downto 1);

  -- Two matrixes
  signal gSignal       : vector_t;
  signal pSignal       : vector_t;
  -- This are used for the first output of the PG network
  signal gi            : std_logic_vector(NBITS downto 1);
  signal pi            : std_logic_vector(NBITS downto 1);
  -- The algorithm is splitted in two main parts
  constant first_part  : integer := log2(NBITS_CARRIES);
  constant second_part : integer := log2(NBITS)-log2(NBITS_CARRIES);


  -- Single pg_generator block of the PG_network
  component PG_GENERATOR
    port
      (
        A : in  std_logic;
        B : in  std_logic;
        P : out std_logic;
        G : out std_logic
        );
  end component;


  --Single PG block
  component PG
    port
      (
        p_ik  : in  std_logic;
        g_ik  : in  std_logic;
        p_k1j : in  std_logic;
        g_k1j : in  std_logic;
        P_ij  : out std_logic;
        G_ij  : out std_logic
        );
  end component;


  -- Single G block
  component G
    port
      (
        p_ik  : in  std_logic;
        g_ik  : in  std_logic;
        g_k1j : in  std_logic;
        G_ij  : out std_logic
        );
  end component;


begin


  -- Instantiate the PG Network
  pg_network : for i in 1 to NBITS generate
    pg_inst : PG_GENERATOR port map (A(i), B(i), pi(i), gi(i));
  end generate;

  --First initializations
  COUT(0)       <= C0;
  gSignal(1)(1) <= (C0 and pi(1)) or gi(1);

  --We know that P and G with the same index are equal to g and p

  equality : for i in 2 to NBITS generate
    pSignal(i)(i) <= pi(i);
    gSignal(i)(i) <= gi(i);
  end generate;



  FIRST_PART1 : for row in 1 to first_part generate
    I0 : for i in 1 to NBITS generate

      -- The G block, for the first part of the algorithm is always at the end of the line
      -- The end of the line in this tree is 2^(Number of row)
      -- The input of the G are positioned on the row above (row - 1)
      G_INST : if i = 2**row generate
        G1 : G port map(pSignal(i)(i-2**(row-1)+1),
                        gSignal(i)(i-2**(row-1)+1),
                        gSignal(i-2**(row-1))(1),
                        gSignal(i)(i-2**row+1));
      end generate;

      -- The other cases are PG blocks. The first condition is to ensure that 
      -- the limits of the row in question are not exceeded, the other condition to not consider the case 
      -- above for the G block. The inputs follows the same concept of the G block
      PGi : if (i mod 2**row = 0) and ((i > 2**row) or (i < 2**row)) generate
        PG_inst1 : PG port map(pSignal(i)(i-2**(row-1)+1),
                               gSignal(i)(i-2**(row-1)+1),
                               pSignal(i-2**(row-1))(i-2**row+1),
                               gSignal(i-2**(row-1))(i-2**row+1),
                               pSignal(i)(i-2**row+1),
                               gSignal(i)(i-2**row+1));
      end generate;
    
    end generate;
  
  end generate;

  COUT(1) <= gSignal(NBITS_CARRIES)(1);

  SECOND_PART1 : for row in 0 to second_part-1 generate

    I1 : for i in NBITS_CARRIES to NBITS generate

      cond1 : if (i mod (NBITS_CARRIES*(2**row)) = 0) and (i = (NBITS_CARRIES*(2**row)) or (i/(NBITS_CARRIES*(2**row))) mod 2 > 0) generate
        
        labelx : for k in i + NBITS_CARRIES to i + NBITS_CARRIES*(2**row) generate
          cond2 : if k mod NBITS_CARRIES = 0 and i = NBITS_CARRIES*(2**row) generate
            G_INST2 : G port map(pSignal(k)(i+1),
                                 gSignal(k)(i+1),
                                 gSignal(i)(i-NBITS_CARRIES*(2**row)+1),
                                 gSignal(k)(i-NBITS_CARRIES*(2**row)+1));

            COUT(k/NBITS_CARRIES) <= gSignal(k)(i-NBITS_CARRIES*(2**row)+1);
          end generate;

          cond3 : if k mod NBITS_CARRIES = 0 and i > 2**(row+2) generate
            PG_INST2 : PG port map(pSignal(k)(i+1),
                                   gSignal(k)(i+1),
                                   pSignal(i)(i-NBITS_CARRIES*(2**row)+1),
                                   gSignal(i)(i-NBITS_CARRIES*(2**row)+1),
                                   pSignal(k)(i-NBITS_CARRIES*(2**row)+1),
                                   gSignal(k)(i-NBITS_CARRIES*(2**row)+1));
          end generate;
        end generate;
      end generate;
    end generate;
  end generate;

end structural;
