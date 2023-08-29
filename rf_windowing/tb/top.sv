// ----------------------------------------------------------------------------
// Title: Top Module for RF Testbench
// Author: Federico Fruttero
// Description: This is the top module for the RF testbench. It instantiates the
//              RF interface and wraps it with the RF wrapper. The test is
//              started using the run_test() function.
// ----------------------------------------------------------------------------

import uvm_pkg::*; // Import the UVM package
import rf_pkg::*; // Import the RF package

module top;

    localparam DWIDTH = 64; // Define the data width for the RF interface

    rf_if #(DWIDTH) mi(); // Instantiate the RF interface
    rf_wrap #(DWIDTH) rf_wrap(mi); // Wrap the RF interface with the RF wrapper

    initial begin
        global_rf_if = mi; // Assign the RF interface to the global virtual interface
        run_test(); // Start the test
    end
   
endmodule: top // End of the top module
