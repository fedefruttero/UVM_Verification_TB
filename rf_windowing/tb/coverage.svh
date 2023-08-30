// ----------------------------------------------------------------------------
// Title: Coverage Class
// Author: Federico Fruttero
// Affiliation: Politecnico di Torino
// Description: This class defines the coverage agent for the testbench. It includes
//              covergroups to capture different aspects of the design's behavior.
// ----------------------------------------------------------------------------

import generic_pkg::*; // Import package containing definitions

class coverage extends uvm_agent;
    `uvm_component_utils(coverage) // Macros to register the class for factory creation

    uvm_tlm_analysis_fifo #(rf_req) req_fifo; // FIFO for request transactions
    rf_op                               operation_cp1; // Operation coverage point
    rf_op                               operation_cp2; // Operation coverage point
    logic[ADDR_SIZE-1:0]                address_cp; // Address coverage point
    logic                               port_cp; // Port coverage point
    logic[NBITS-1 : 0]                  data_cp;
    // Declare a covergroup to capture operation transitions
    covergroup operation_transition_cg;
        coverpoint operation_cp1 {
            bins op_transition[] = ([read:ret] => [read:ret]);
        }
    endgroup

    covergroup triple_transition_cg;
        coverpoint operation_cp1 {
            bins op_transition[] = ([read:ret] => [read:ret] => [read:ret]);
        }
    endgroup

    // Declare a covergroup for comprehensive coverage
    covergroup comprehensive_rf_coverage;
        coverpoint operation_cp2 {
            bins operations = {read,write,ret,reset,call};
        }
        coverpoint address_cp{
            bins range_0_to_13 = {[0:13]};
        }
        coverpoint port_cp;
        coverpoint data_cp{
            bins cornerup   = {[(1<<NBITS)-1 : (1<<NBITS-1)-1]};
            bins cornerlow  = {[0 : (1<<NBITS-62)-1]};
            bins others     = default;
        }
    endgroup

    function new (string name, uvm_component parent);
        super.new(name, parent);
        comprehensive_rf_coverage = new();
        operation_transition_cg = new();
        triple_transition_cg = new();
    endfunction : new
    
    task run_phase(uvm_phase phase);
        rf_req req; // Request transaction
        forever begin : forever_loop
           req_fifo.get(req); // Get a request from the FIFO
           if(req.op != nop) begin 
                operation_cp1 = req.op; // Update coverage points
                operation_cp2 = req.op; // Update coverage points
                address_cp = req.addr;
                port_cp = req.port;
                data_cp = req.data;
                operation_transition_cg.sample(); // Sample the operation transition covergroup
                comprehensive_rf_coverage.sample(); // Sample the comprehensive covergroup
                triple_transition_cg.sample();
           end
        end : forever_loop
    endtask // run
  
    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        req_fifo = new("req_fifo", this); // Instantiate the FIFO
    endfunction : build_phase

endclass : coverage
