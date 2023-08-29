//----------------------------------------------------------------------
// Title: Driver for Pentium 4 Adder Testbench
// Author: Federico Fruttero
// Affiliation: Politecnico di Torino
// Description: This class represents the driver in the Pentium 4 adder
//              testbench environment. It generates stimulus for the DUT
//              by providing random inputs for operands A and B as well
//              as the carry input (CIN).
//----------------------------------------------------------------------

// Import the UVM package and components
class driver extends uvm_agent;
    `uvm_component_utils(driver) // Registers the class with the UVM factory
    virtual interface p4_if i;   // Declare the interface instance

    // Constructor
    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    // Build Phase: Connect the virtual interface instance to the global interface
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        i = p4_pkg::global_p4_if; // Access the global interface instance
    endfunction : build_phase

    // Run Phase: Generate stimulus for the DUT
    task run_phase(uvm_phase phase);
        int nloops = 20000; // Number of iterations

        phase.raise_objection(this); // Indicate that the agent is not finished yet

        repeat (nloops) begin
            @(posedge i.clk); // Wait for the rising edge of the clock

            i.CIN = $random; // Assign random value to carry input

            // Generate random values for Aif
            if ($urandom_range(0, 9) < 5) // Higher probability for values closer to 0
                i.Aif = $urandom_range(32'h00000000, 32'h000000ff);
            else
                i.Aif = $urandom_range(32'h7FFFFFFF, 32'hffffffff);

            // Generate random values for Bif
            if ($urandom_range(0, 9) < 5) // Higher probability for values closer to 0
                i.Bif = $urandom_range(32'h00000000, 32'h000000ff);
            else
                i.Bif = $urandom_range(32'h7FFFFFFF, 32'hffffffff);
        end

        phase.drop_objection(this); // Indicate that the agent has finished
    endtask : run_phase
endclass : driver
