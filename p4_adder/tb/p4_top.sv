//----------------------------------------------------------------------
// Title: Top Module for Pentium 4 Adder Testbench
// Author: Federico Fruttero
// Affiliation: Politecnico di Torino
// Description: This module instantiates the components required for the
//              Pentium 4 adder testbench. It sets up the interface and
//              test environment and runs the test.
//----------------------------------------------------------------------

import uvm_pkg::*; // Import the UVM package
import p4_pkg::*;  // Import the local package

module top;

    localparam DWIDTH = 32; // Set the data width parameter

    p4_if #(DWIDTH) interfac(); // Instantiate the interface with the specified data width
    p4_wrap #(DWIDTH) p4_wrap(interfac); // Instantiate the wrapper with the interface

    initial begin
        p4_pkg::global_p4_if = interfac; // Assign the interface instance to the global virtual variable

        // Number of loops we want into the configuration
        // set_config_int("*","nloops",1000); // Set a configuration parameter (if needed)

        run_test(); // Run the test (defined in the UVM package that we are importing)
    end

endmodule // top
