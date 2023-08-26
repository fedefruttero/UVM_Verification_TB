/*
In summary, the predictor class is responsible for processing incoming register file requests, simulating memory operations, and generating 
appropriate response transactions. It maintains a simulated memory model, processes both read and write requests, and sends response 
transactions to the comparator for comparison.
*/

import generic_pkg::*;

class predictor extends uvm_agent;

    `uvm_component_utils(predictor)

    logic [NBITS-1:0]   register_file_model [NREGISTERS-1 : 0]; //we create a model of our register file. 
    logic [NBITS:0]     memory_model        [2**16-1 : 0];                       // Simulated memory model

    uvm_tlm_analysis_fifo #(rf_req) req_fifo; //we declare and instantiate a TLM analysis FIFO, parameterized, it will work with rf_data objects
    uvm_put_port #(rf_data) rsp_p; // Put port to send responses
    virtual interface rf_if i;
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
   When a request is a write, it updates the simulated memory.
   For read requests, it generates a response and sends it to the comparator.
   */

   task run_phase(uvm_phase phase);
        rf_data cln;
        rf_req req_txn;
        int monitor_thread;
        int j = 0;
        // Start the monitorSPILL_task in a separate thread
        fork
        begin
            monitorSPILL_task(); //THREAD 2
        end
        forever begin : run_loop
            req_fifo.get(req_txn); //we block until we can get something
            if(i.SPILLif == 0) begin //if its spilling, we read the old value until in finishes
                case (req_txn.op)
                    write: begin : write_op
                        if(req_txn.addr >= M) register_file_model[req_txn.addr + i.CWP] = req_txn.data; //update register file for write request 
                        if(req_txn.addr  < M) register_file_model[req_txn.addr] = req_txn.data; //im writing one of the globals
                    end : write_op
                    read: begin : read_op
                        if(req_txn.addr >= M) rsp.load_data(req_txn.addr, register_file_model[req_txn.addr + i.CWP], req_txn.port);  // Load response with data from memory
                        if(req_txn.addr  < M) rsp.load_data(req_txn.addr, register_file_model[req_txn.addr], req_txn.port); //globals
                        $cast(cln, rsp.clone()); // Clone response
                        rsp_p.put(cln); // Send the cloned response to the comparator
                    end : read_op
                    reset: begin : reset_op
                        initializeRF_mem_model();
                    end : reset_op

                endcase
            end
            else begin
                `uvm_info("Monitor", "Register SPILLED in memory", UVM_MEDIUM);
                i.CWP = 0;     
            // WE SAVE THE OLD WINDOW IN THE MEMORY AND FREE THE REGISTER FILE MODEL
                for(int z = 0 ; z<2*N ; z++) begin
                    memory_model[z] = register_file_model[z + M + i.CWP];
                end
                i.SWP = j;
                j = j + 2*N;
            end
        end : run_loop;
        // Join the monitorSPILL_task thread
        join;
    endtask: run_phase

    function void initializeRF_mem_model();
        // Initialize the register_file_model array to all zeros
        for (int i = 0; i < NREGISTERS; i++) begin
            register_file_model[i] = 0;
        end
        for (int i = 0; i < (2**16)-1; i++) begin
            memory_model[i] = 0;
        end
    endfunction;

    task monitorSPILL_task();
        int j = 0;
        forever begin
            @(posedge i.SPILLif); // Wait for changes
                `uvm_info("Monitor", "SPILL signal changed", UVM_MEDIUM);
                i.CWP = 0;     
            // WE SAVE THE OLD WINDOW IN THE MEMORY AND FREE THE REGISTER FILE MODEL
                for(int z = 0 ; z<2*N ; z++) begin
                    memory_model[z] = register_file_model[z + M + i.CWP];
                end
                i.SWP = j;
                j = j + 2*N;
            end
    endtask : monitorSPILL_task

endclass: predictor

    
















