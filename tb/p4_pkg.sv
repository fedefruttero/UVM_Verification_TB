`include "uvm_macros.svh"

package p4_pkg;
    import uvm_pkg::*;
    //create a global virtual variable to hold the P4_if interface
    virtual interface p4_if global_p4_if; //i saw this is the simplest way to get the handle to the if
    `include "p4_test.svh"

endpackage //p4_pkg