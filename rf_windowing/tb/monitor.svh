class monitor extends interface_base;
    `uvm_component_utils(monitor) 

    uvm_analysis_port #(rf_data) rsp_a; 
    uvm_analysis_port #(rf_req)  req_a;   // Second analysis port

   function new(string name = "driver", uvm_component parent = null );
       super.new(name, parent);
   endfunction : new

   // Build phase where analysis ports are created
   function void build_phase(uvm_phase phase);
       super.build_phase(phase);  // Call the parent's build_phase to get the interface
       req_a = new("req_a", this); // Create a new instance of analysis port for requests
       rsp_a = new("rsp_a", this); // Create a new instance of analysis port for responses
   endfunction: build_phase

   // Run phase where monitoring activities occur
   task run_phase(uvm_phase phase);
        rf_req req = new(), c_req; // Declare transaction objects for requests

        forever begin : monitor_loop
            @(posedge rfif.clk);
            #1;
            req.load_data(rfif.ADD_RD1if, rfif.OUT1if, 0 , nop); //check
            if (rfif.RD1if) req.load_data( rfif.ADD_RD1if, rfif.OUT1if, 0 , read);
            else if (rfif.RD2if) req.load_data( rfif.ADD_RD2if, rfif.OUT2if, 1 , read );
            if(rfif.WRif) req.load_data(rfif.ADD_WRif, rfif.DATAINif, 0, write); 
            if(rfif.RSTif) req.load_data(rfif.ADD_WRif, rfif.DATAINif,0, reset);
            if(rfif.CALLif) req.load_data(0,0,0, call);
            if(rfif.SIGRETURNif) req.load_data(0,0,0, ret);
            $cast(c_req, req.clone());  // Clone the request transaction
            req_a.write(c_req);         // Write the clone to the request analysis port
            
            // If it's a read operation, construct and send a response transaction
            if(rfif.RD1if || rfif.RD2if) begin
                rf_data rsp = new(), c_rsp;
                if      (rfif.RD1if)      rsp.load_data(rfif.ADD_RD1if, rfif.OUT1if,  0 );
                else if (rfif.RD2if)      rsp.load_data( rfif.ADD_RD2if, rfif.OUT2if, 1 );
                $cast(c_rsp, rsp.clone());   // Clone the response transaction
                rsp_a.write(c_rsp);          // Write the clone to the response analysis port
            end
        end : monitor_loop
    endtask

    
 
 endclass : monitor

 /*
The monitor class observes the signals on the memory interface (memory_if) of the DUT. It watches for changes in these signals, 
such as address updates, read/write operations, and data updates. When a change occurs, the monitor constructs corresponding 
transactions (requests and responses) based on the observed signals. If it detects a valid read or write operation, it clones 
the transaction and sends it through analysis ports to be captured by downstream components like the predictor and comparator. 
This separation of signal-level monitoring and transaction-level analysis helps maintain the modularity and scalability of the 
testbench architecture
*/