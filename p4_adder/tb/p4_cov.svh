//----------------------------------------------------------------------
// Title: Coverage Class for Pentium 4 Adder Testbench
// Author: Federico Fruttero
// Affiliation: Politecnico di Torino
// Description: This class represents the coverage collection in the
//              Pentium 4 adder testbench environment. It defines a
//              covergroup to track functional coverage of input operands
//              (A and B) and the carry input (CIN).
//----------------------------------------------------------------------

class p4_cov extends uvm_component;
    `uvm_component_utils(p4_cov)

    localparam DWIDTH = 32;

    local virtual p4_if #(DWIDTH) i; // Declare the interface instance
    
    // Define a covergroup for tracking functional coverage
    covergroup p4_cg;
        // Coverpoints for the two input operands and CIN signal
        a_cp: coverpoint i.Aif {
            bins zero_000000000       = {32'h00000000};
            bins cornerup_FFFFFFFF_7FFFFFFF   = {[(1<<DWIDTH)-1 : (1<<DWIDTH-1)-1]};
            bins cornerlow_0000003F_00000000  = {[0 : (1<<DWIDTH-26)-1]};
            bins others     = default;
        }
        b_cp: coverpoint i.Bif {
            bins zero_00000000       = {32'h00000000};
            bins cornerup_FFFFFFFF_7FFFFFFF   = {[(1<<DWIDTH)-1 : (1<<DWIDTH-1)-1]};
            bins cornerlow_0000003F_00000000  = {[0 : (1<<DWIDTH-26)-1]};
            bins others     = default;
        }
        cin_cp: coverpoint i.CIN {
            bins values[]   = {0, 1};  
        }
        
        crossed_A_B_Cin: cross a_cp,b_cp,cin_cp;
    endgroup

    function new (string name, uvm_component parent);
        super.new(name, parent);
        p4_cg = new(); // Create the covergroup instance
    endfunction : new

    // Build Phase: Connect the virtual interface instance to the global interface
    function void build();
        super.build();
        i = global_p4_if; // Access the global interface instance
    endfunction : build

    // Run Phase: Sample the covergroup
    task run_phase(uvm_phase phase);
        forever begin : sampling_block
            @(negedge i.clk); // Wait for the falling edge of the clock
            p4_cg.sample(); // Sample the covergroup
        end : sampling_block
    endtask : run_phase

endclass : p4_cov
