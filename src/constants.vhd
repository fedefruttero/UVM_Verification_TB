package CONSTANTS is
   constant NumBit      : integer := 4;

   function log2(i : integer) return integer;

end package CONSTANTS;

package body CONSTANTS is

   function log2(i : integer) return integer is
      variable temp    : integer := i;
      variable ret_val : integer := 1;
   begin
      while temp > 2 loop
         ret_val := ret_val + 1;
         temp    := temp / 2;
      end loop;
      return ret_val;
   end function log2;

end package body CONSTANTS;
