import uvm_pkg::*;
import rf_pkg::*;

module top;

   localparam DWIDTH = 64;

   rf_if    #(DWIDTH) mi();
   rf_wrap  #(DWIDTH) rf_wrap(mi);

   initial begin
      global_rf_if = mi;
      run_test(); 
   end
   
endmodule: top






