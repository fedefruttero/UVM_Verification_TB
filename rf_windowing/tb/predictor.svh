// ----------------------------------------------------------------------------
// Title: Predictor
// Author: Federico Fruttero
// Affiliation: Politecnico di Torino
// Description: This file defines a UVM agent class for predicting memory operations 
// in the Register File (RF) simulation. The predictor processes incoming requests 
// and simulates memory operations based on the request types. It maintains a simulated 
// register file and memory model and generates responses for read requests, sending them 
// to the comparator for validation.
// ----------------------------------------------------------------------------

import generic_pkg::*;

class predictor extends uvm_agent;

    `uvm_component_utils(predictor)

    logic [NBITS-1:0] register_file_model[NREGISTERS-1 : 0]; // Simulated register file model
    logic [NBITS-1:0] memory_model[2**16-1 : 0]; // Simulated memory model

    uvm_tlm_analysis_fifo #(rf_req) req_fifo; // Request FIFO for incoming requests
    uvm_put_port #(rf_data) rsp_p; // Put port for sending responses
    virtual interface rf_if i; // Interface to the DUT
    rf_data rsp = new(); // Response transaction object

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        i = rf_pkg::global_rf_if;
        initializeRF_mem_model();
        
        req_fifo = new("req_fifo", this); // Instantiate request FIFO
        rsp_p = new("rsp_po", this); // Instantiate response put port
    endfunction: build_phase

    /*
    This task continuously processes incoming requests.
    For write requests, it updates the simulated memory.
    For read requests, it generates a response and sends it to the comparator.
    */

    task run_phase(uvm_phase phase);
        rf_data cln;
        rf_req req_txn;
        int j = 0;

        forever begin : run_loop
            req_fifo.get(req_txn); // Block until a request is available

            if (i.SPILLif == 0 && i.FILLif == 0) begin // Check if not spilling or filling
                case (req_txn.op)
                    write: begin : write_op
                        if (req_txn.addr >= M) 
                            register_file_model[req_txn.addr + i.CWP] = req_txn.data; // Update register file for write request 
                        if (req_txn.addr < M) 
                            register_file_model[req_txn.addr] = req_txn.data; // Update global variables
                    end : write_op

                    read: begin : read_op
                        if (req_txn.addr >= M) 
                            rsp.load_data(req_txn.addr, register_file_model[req_txn.addr + i.CWP], req_txn.port); // Load response with data from memory
                        if (req_txn.addr < M) 
                            rsp.load_data(req_txn.addr, register_file_model[req_txn.addr], req_txn.port); // Load response with data from global variables

                        $cast(cln, rsp.clone()); // Clone response
                        rsp_p.put(cln); // Send the cloned response to the comparator
                    end : read_op

                    reset: begin : reset_op
                        initializeRF_mem_model();
                    end : reset_op
                endcase
            end

            else if (i.SPILLif == 1) begin : do_spill  
                `uvm_info("Monitor", "Register SPILLED in memory", UVM_MEDIUM);
                i.CWP = 0;     
                // Save the old window in the memory and free the register file model
                for (int z = 0 ; z < 2 * N ; z++) begin
                    memory_model[z] = register_file_model[z + M + i.CWP];
                end
                i.SWP = j;
                j = j + 2 * N;
            end : do_spill
                
            else if (i.FILLif == 1) begin : do_fill     
                for (int z = 0 ; z < 2 * N ; z++) begin
                    `uvm_info("Monitor", "One register has been FILLED from memory", UVM_HIGH);
                    register_file_model[z + M + i.CWP] = memory_model[z]; // Restore the registers from memory
                    i.MEM_BUSreadif = memory_model[z]; // Send the actual value to the DUT
                    #20ns;
                end

                // Handling for Z = 2N
                if (i.SWP == 0) i.SWP = 10000; 
                else i.SWP = i.SWP - 2 * N;

                // Print the memory model
            end : do_fill
        end : run_loop;
    endtask : run_phase

    function void initializeRF_mem_model();
        // Initialize the register_file_model array to all zeros
        for (int i = 0; i < NREGISTERS; i++) begin
            register_file_model[i] = 0;
        end
        
        // Initialize the memory_model array to all zeros
        for (int i = 0; i < (2**16)-1; i++) begin
            memory_model[i] = 0;
        end
    endfunction;

endclass : predictor
