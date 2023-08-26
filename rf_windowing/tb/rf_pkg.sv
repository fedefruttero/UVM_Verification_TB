package rf_pkg;
    import uvm_pkg::*;
    typedef enum {read, write, reset, call, ret,nop} rf_op;
    //create a global virtual variable to hold the P4_if interface
    virtual interface rf_if global_rf_if;

    `include "uvm_macros.svh"
   // uvm_transactions
    `include "rf_data.svh"
    `include "rf_req.svh"
    `include "test_seq.svh"

   // uvm_agents 
    `include "interface_base.svh"
    `include "responder.svh"
    `include "driver.svh"
    `include "predictor.svh"
    `include "comparator.svh"
    `include "monitor.svh"
    `include "printer.svh"
    

    //env
    `include "tester_env.svh"

    //tests:
    `include "verbose_test.svh"
endpackage : rf_pkg//rf_pkg