//----------------------------------------------------------------------
// Title: Verbose Test for Pentium 4 Adder
// Author: Federico Fruttero
// Affiliation: Politecnico di Torino
// Description: This class represents a verbose test in the Pentium 4
//              adder testbench. It sets the verbosity level, creates
//              a test environment instance, and performs the test.
//----------------------------------------------------------------------

class verbose_test extends uvm_test;

    `uvm_component_utils(verbose_test) // Register the class with the UVM factory

    tester_env t_env; // Declare a variable for the test environment instance

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Build Phase: Set verbosity level, create environment instance
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        p4_pkg::verbose = 1; // Set verbosity to 1 (verbose mode)
        t_env = tester_env::type_id::create("t_env", this); // Create an instance of the test environment using the factory
    endfunction : build_phase

endclass : verbose_test
