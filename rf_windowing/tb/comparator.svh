class comparator extends uvm_agent;

    `uvm_component_utils(comparator)

   // Declare analysis FIFOs for actual and predicted responses
    uvm_tlm_analysis_fifo #(rf_data) actual_f; // FIFO for actual responses from the DUT
    uvm_get_port #(rf_data) predicted_p;       // Get port for predicted responses from predictor

    // Declare variables to hold actual and predicted response transactions
   rf_data actual_rsp, predicted_rsp;


   // Constructor for the comparator class
   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction: new
   // Build phase of the comparator
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      // Create and initialize actual FIFO
      actual_f = new("actual_f", this);
      
      // Connect the predicted get port to the predictor's response put port
      predicted_p = new("predicted_p", this); 
   endfunction: build_phase
   


   // Run phase of the comparator
   task run_phase(uvm_phase phase); 
      forever begin : run_loop
         // Get actual response from actual FIFO
         actual_f.get(actual_rsp);
         // Get predicted response from predictor
         predicted_p.get(predicted_rsp);
         // Compare actual and predicted responses
         if(actual_rsp.comp(predicted_rsp)) 
            uvm_report_info("run", 
                           $psprintf("Passed: %s", actual_rsp.convert2string()),UVM_MEDIUM);
         else
            uvm_report_error("run",
                            $psprintf("ERROR - Expected: %s, Actual: %s",
                                      predicted_rsp.convert2string(),
                                      actual_rsp.convert2string()));
      end : run_loop;
   endtask: run_phase
endclass: comparator