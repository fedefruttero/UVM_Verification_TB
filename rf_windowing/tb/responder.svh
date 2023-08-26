/*
In summary, the responder generates read response transactions for the memory reads and sends them to the monitor. 
From there, the response transactions flow through the predictor and finally to the comparator, where they are 
compared with the predicted responses. This entire flow helps in verifying whether the DUT's behavior matches
the expected behavior.
*/
class responder extends interface_base;

    `uvm_component_utils(responder)    
    uvm_put_port   #(rf_data)   data_out_port;

    function new(string name, uvm_component parent=null);
        super.new(name, parent);
     endfunction : new
     
     function void build_phase(uvm_phase phase);
        super.build_phase(phase);                 //we get the interface, just like in the driver.
        data_out_port = new("data_out_port",this);
     endfunction : build_phase

    task run_phase(uvm_phase phase);
        rf_data    read_transaction = new(), cln;                  //in its run phase it creates a new data transaction of type mem_data and also a clone of it (cln)
        forever begin : clock_loop
            @(posedge rfif.clk);                                    //at the positive edge of each clock checks if there is a read, if there is: 
            #1;
            if (rfif.RD1if || rfif.RD2if) begin : read_data
                if (rfif.RD1if) begin
                    read_transaction.addr       = rfif.ADD_RD1if;            //loads the address and data into the data_txn (data transaction)
                    read_transaction.data       = rfif.OUT1if;
                    read_transaction.port = 0;
                end
                if (rfif.RD2if) begin
                    read_transaction.addr       = rfif.ADD_RD2if;            //loads the address and data into the data_txn (data transaction)
                    read_transaction.data       = rfif.OUT2if;
                    read_transaction.port = 1;
                end
                $cast(cln, read_transaction.clone());
                
                assert(data_out_port.try_put(cln)) else             //then tries to put this data transaction into the fifo rsp2printer writing the port data_out
                uvm_report_fatal("run","responder not connected"); //this should never fail, because we are waiting and the fifo should be empty
            end : read_data
        end : clock_loop
    endtask : run_phase

endclass : responder