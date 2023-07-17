import uvm_pkg::*;
import counter_pkg::*;

module top;

   counter_if ctr_if();
   counter DUT(ctr_if.cntr_mp);

   
      // Please Create an initial block to do the following things:
   initial begin

      // 1. Please set the global interface variable equal to ctr_if;
      counter_pkg::global_ctr_if = ctr_if;
      
      // 2. Please call run_test()
      run_test();
      
   end   
      
endmodule // top

   