// ----------------------------------------------------------------------------
// Title: RF Package
// Author: Federico Fruttero
// Affiliation: Politecnico di Torino
// Description: This package includes all the necessary components, transactions,
//              and configurations to build and run the RF testbench.
// ----------------------------------------------------------------------------

package rf_pkg;
    import uvm_pkg::*; // Import the UVM package

    // Define the enumeration for RF operations
    typedef enum {read, write, reset, call, ret, nop} rf_op;

    // Create a global virtual interface for the RF interface
    virtual interface rf_if global_rf_if;

    bit verbose; // Global verbosity level for printing information

    // Include files for transactions and sequences
    `include "uvm_macros.svh"
    `include "rf_data.svh" // Response transaction
    `include "rf_req.svh" // Request transaction
    `include "test_seq.svh" // Test sequence

    // Include files for agents
    `include "interface_base.svh" // Base interface
    `include "responder.svh" // Responder agent
    `include "driver.svh" // Driver agent
    `include "predictor.svh" // Predictor agent
    `include "comparator.svh" // Comparator agent
    `include "monitor.svh" // Monitor agent
    `include "printer.svh" // Printer agent
    `include "coverage.svh" // Coverage agent

    // Include file for the test environment
    `include "tester_env.svh" // Test environment

    // Include files for tests
    `include "verbose_test.svh" // Verbose test

endpackage : rf_pkg // End of package rf_pkg
