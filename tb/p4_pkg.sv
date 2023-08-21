

package p4_pkg;
    import uvm_pkg::*;
    //create a global virtual variable to hold the P4_if interface
    virtual interface p4_if global_p4_if; //i saw this is the simplest way to get the handle to the if

    bit verbose = 0;
    
    `include "uvm_macros.svh"
    `include "driver.svh"
    `include "scoreboard.svh"
    `include "printer.svh"
    `include "p4_cov.svh" 
    `include "tester_env.svh"
    `include "verbose_tester.svh"
    `include "quiet_test.svh"
   
endpackage //p4_pkg