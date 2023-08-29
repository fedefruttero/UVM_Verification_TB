//----------------------------------------------------------------------
// Title: Scoreboard for Pentium 4 Adder Testbench
// Author: Federico Fruttero
// Affiliation: Politecnico di Torino
// Description: This class represents the scoreboard in the Pentium 4
//              adder testbench environment. It checks the correctness
//              of the DUT's output by comparing it with the expected
//              result based on the inputs.
//----------------------------------------------------------------------

`include "uvm_macros.svh"
class scoreboard extends uvm_agent;
    `uvm_component_utils(scoreboard) // Register the class with the UVM factory

    virtual interface p4_if p4if; // Declare the interface instance

    // Constructor
    function new(string name = "scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    // Build Phase: Connect the virtual interface instance to the global interface
    function void build();
        super.build();
        p4if = global_p4_if; // Access the global interface instance
    endfunction : build

    // Run Task: Compare DUT output with expected result
    task run();
        forever begin
            @(posedge p4if.clk);
            @(posedge p4if.clk);

            if (p4if.CIN == 0) begin
                assert(p4if.Ssync == p4if.Aif + p4if.Bif)
                    else `uvm_error("run",
                            $psprintf("expected %h  actual: %h", p4if.Aif + p4if.Bif, p4if.Ssync));
            end
            else if (p4if.CIN == 1) begin
                assert(p4if.Ssync == p4if.Aif - p4if.Bif)
                    else `uvm_error("run",
                            $psprintf("expected %h  actual: %h", p4if.Aif - p4if.Bif, p4if.Ssync));
                // UVM_ERROR, together with UVM_INFO, are two of the four reporting macros in the UVM.
            end
        end
    endtask // run
endclass : scoreboard
