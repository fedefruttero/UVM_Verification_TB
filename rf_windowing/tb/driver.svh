// ----------------------------------------------------------------------------
// Title: Memory Interface Driver
// Author: Federico Fruttero
// Affiliation: Politecnico di Torino
// Description: This file defines a UVM driver class for sending transactions to the memory 
// interface (memory_if) of the DUT. It takes transaction items from the sequence, translates 
// them into appropriate signal-level actions, and sends these actions to the DUT through the 
// memory interface signals. Responses from the DUT are collected, and the appropriate 
// transaction is constructed and sent back to the sequence.
// ----------------------------------------------------------------------------

import generic_pkg::*; 

class driver extends uvm_driver #(rf_req, rf_data); 
    `uvm_component_utils(driver) 

    uvm_object tmp;
    virtual interface rf_if i; 
    rf_req req;  //required input to DUT
    rf_data rsp; //response

    function new(string name = "driver", uvm_component parent = null );
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase); //we get the interface by executing the build phase of our parent class (interface_Base)
        i = rf_pkg::global_rf_if;
    endfunction: build_phase

    task run_phase(uvm_phase phase); //here we basically get a request and we transform it into real signals to the DUT 

    forever begin : driver_loop
        @(negedge i.clk);
        i.ENABLEif = 1; //we enable the RF
        i.RD1if = 0;
        i.RD2if = 0;
        i.WRif  = 0;
        i.RSTif = 0;

        // Please get the next item from seq_item_port
        seq_item_port.try_next_item(req);

        if (req != null) begin : got_req
            // Please tell the UVM that you successfully got an item            
            seq_item_port.item_done();

            `uvm_info("run",
                $psprintf("Driver got %s", req.convert2string()), 
                UVM_DEBUG)

            if (i.SPILLif == 0 && i.FILLif == 0) begin
                case(req.op)
                    read: begin : do_read
                        if (req.port == 0) begin
                            i.RD1if = 1;
                            i.ADD_RD1if = req.addr;
                        end
                        else if (req.port == 1) begin
                            i.RD2if = 1;
                            i.ADD_RD2if = req.addr;
                        end
                    end : do_read
                    write: begin : do_write
                        i.WRif = 1;
                        i.ADD_WRif = req.addr;
                        i.DATAINif = req.data;
                    end : do_write
                    reset: begin : do_reset
                        i.RSTif = 1;
                        #20ns;
                        i.RSTif = 0;
                        //we reset our CWP and SWP
                        i.CWP = 0;
                        i.SWP = 10000;
                    end : do_reset
                    call: begin : do_call
                        i.CALLif = 1;
                        #20ns;
                        i.CALLif = 0;
                        i.CWP = i.CWP + 2 * N;
                        if (i.CWP == 2 * N * F) i.CWP = 0;
                    end : do_call
                    ret: begin : do_ret 
                        i.SIGRETURNif = 1;
                        if (i.CWP == 0) i.CWP = (2 * N * (F - 1));
                        else i.CWP    = (i.CWP - (2 * N));
                        #20ns;
                        i.SIGRETURNif = 0;
                    end : do_ret
                endcase;
            end
        end : got_req

        @(posedge i.clk);
        #1;
        rsp = new;

        case(req.op)
            read: begin : do_read
                if (req.port == 0) begin
                    rsp.data = i.OUT1if; 
                    rsp.addr = i.ADD_RD1if;
                end
                if (req.port == 1) begin
                    rsp.data = i.OUT2if;
                    rsp.addr = i.ADD_RD2if;
                end
                // We set the response ID to be the same as the request ID
                rsp.set_id_info(req);
                // We put the response into seq_item_port
                seq_item_port.put_response(rsp);
            end : do_read
            write: begin
                rsp.set_id_info(req);
                seq_item_port.put_response(rsp);
            end
            reset: begin : do_reset
                rsp.set_id_info(req);
                seq_item_port.put_response(rsp);
            end : do_reset
            call: begin : do_call
                rsp.set_id_info(req);
                seq_item_port.put_response(rsp);
            end : do_call  
            ret: begin : do_ret
                rsp.set_id_info(req);
                seq_item_port.put_response(rsp);
            end : do_ret
            nop: begin : do_nop
                rsp.set_id_info(req);
                seq_item_port.put_response(rsp);
            end : do_nop
        endcase;
    end : driver_loop

    endtask : run_phase
endclass : driver
