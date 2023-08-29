//----------------------------------------------------------------------
// Title: Test Environment for Pentium 4 Adder Testbench
// Author: Federico Fruttero
// Affiliation: Politecnico di Torino
// Description: This class represents the test environment in the Pentium 4
//              adder testbench. It instantiates and connects the various
//              components including the driver, scoreboard, printer (if
//              verbose), and coverage collector.
//----------------------------------------------------------------------

class tester_env extends uvm_env; // The test is the one that instantiates the environment

    `uvm_component_utils(tester_env) // Register the class with the UVM factory

    // Declare variables for each of the components
    driver drv;          // Driver component
    scoreboard sb;       // Scoreboard component
    printer prnt;        // Printer component (only for verbose tests)
    p4_cov coverag;      // Coverage collector component

    int verbose;         // Variable to determine verbosity level

    // Constructor
    function new(string name = "tester_env", uvm_component parent = null );
        super.new(name, parent);
    endfunction : new

    // Build Phase: Instantiate and connect components
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        drv = driver::type_id::create("drv", this);             // Create and initialize the driver
        sb  = scoreboard::type_id::create("sb", this);          // Create and initialize the scoreboard
        if (p4_pkg::verbose) prnt = printer::type_id::create("prnt", this); // Create the printer only if it's a verbose test
        coverag = p4_cov::type_id::create("coverag", this);     // Create and initialize the coverage collector
    endfunction : build_phase

endclass : tester_env
