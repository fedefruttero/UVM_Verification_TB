----------------------------------------------------------------------------------------------------------
-- Title      : Generic Register
-- Project    : lab 1
----------------------------------------------------------------------------------------------------------
-- File      : reg_generic.vhd
-- Author    : ms23.13
-----------------------------------------------------------------------------------------------------------
-- Description: This file contains the structural architectures of both
--              asynchronous and synchronous Data FF
--
--
-----------------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all; 

entity register_generic is
	generic (nbits: integer := 16);

	port (
    data_in:	  in	  std_logic_vector(nbits-1 downto 0);
		CK:		      in	  std_logic;
		RESET:		  in	  std_logic;
    ENABLE:      in    std_logic;
		data_out:	out	std_logic_vector(nbits-1 downto 0)
    );

end register_generic;

----------------------------------------------------------------------------------------------------------------------------------
--   Asynchronous ARCHITECTURE
----------------------------------------------------------------------------------------------------------------------------------



architecture ASYNCHRONOUS of register_generic is
 
	-- Declare the flip flop D as a component
  component FD is
    port (
      CK    : in  std_logic;
      RESET : in  std_logic;
      D     : in  std_logic;
      Q     : out std_logic
    );
  end component;


begin
  -- Generate nbits instances of the flip flop D in a loop
  gen_ff: for i in 0 to nbits-1 generate
    -- Instantiate the flip flop D
    FF: entity work.FD(ASYNCH_FD)   --Asynchronous FF
      
      port map
      (
        CK    => CK,
        RESET => RESET,
        D     => data_in(i),
        ENABLE => ENABLE,
        Q     => data_out(i)
      );
  end generate gen_ff;
end ASYNCHRONOUS;
