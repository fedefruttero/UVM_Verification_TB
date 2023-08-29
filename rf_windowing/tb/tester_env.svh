// ----------------------------------------------------------------------------
// Title: Tester Environment
// Author: Federico Fruttero
// Affiliation: Politecnico di Torino
// Description: This file defines the environment for the testbench. It includes
//              the setup and connections of various components like the test
//              sequence, driver, monitor, predictor, comparator, and printers.
// ----------------------------------------------------------------------------

class tester_env extends uvm_env;
   `uvm_component_utils(tester_env);

   // Declare testbench components
   test_seq   tst;                // The test sequence 
   driver     drv;                // The driver component
   coverage   cov;                // Coverage collector

   // Sequencer
   uvm_sequencer #(rf_req, rf_data) seqr;

   // TLM FIFO connecting tester and driver
   uvm_tlm_fifo #(rf_req) tester2drv;

   // Declare printers for printing transactions
   printer   #(rf_req)  req_prt; // Printer for request transactions
   // printer   #(rf_data) rsp_prt; // Printer for response transactions

   // Declare monitor, predictor, and comparator components
   monitor      mon;            // The monitor component
   predictor    pred;           // The predictor component
   comparator   cmp;            // The comparator component
   
   // Declare FIFO for connecting predictor and comparator
   uvm_tlm_fifo #(rf_data) pred2cmp; // TLM FIFO connecting predictor and comparator

   // Constructor for the tester_env class
   function new(string name = "tester_env", uvm_component parent = null );
      super.new(name, parent);
   endfunction : new

   // Build phase of the tester_env
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      // Create and initialize tester, driver, and FIFOs
      tst = test_seq::type_id::create("tst",this);
      drv = driver::type_id::create("drv",this);
      seqr = new("seqr",this);                       // NEW SEQUENCER
      tester2drv = new("tester2drv",this,);
      
      // Create and initialize printers for request and response transactions
      req_prt = printer#(rf_req)::type_id::create("req_prt",this);
      //rsp_prt = printer#(rf_data)::type_id::create("rsp_prt",this);

      // Create and initialize monitor, predictor, comparator and coverage
      mon = monitor::type_id::create("mon", this);
      cov = coverage::type_id::create("cov", this);
      pred = predictor::type_id::create("pred", this);
      cmp = comparator::type_id::create("cmp", this);
      
      // Create and initialize FIFO for connecting predictor and comparator
      pred2cmp  = new("pred2cmp", this);
   endfunction : build_phase    

   // Connect phase of the tester_env
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      
      // Connect components using their ports and analysis exports
      //tst.tb_port.connect(tester2drv.put_export); // Connect tester to driver using TLM FIFO
      //drv.req_f.connect(tester2drv.get_export);   // Connect driver to tester using TLM FIFO
      drv.seq_item_port.connect(seqr.seq_item_export);

      // Connect ports between predictor and comparator
      cmp.predicted_p.connect(pred2cmp.get_export); // Connect predicted port of comparator to get port of predictor
      pred.rsp_p.connect(pred2cmp.put_export);       // Connect response port of predictor to put port of comparator
      
      // Connect monitor's request and response analysis exports to predictor and comparator
      mon.req_a.connect(pred.req_fifo.analysis_export); // Connect monitor's request analysis port to predictor's FIFO
      mon.req_a.connect(cov.req_fifo.analysis_export);
      mon.rsp_a.connect(cmp.actual_f.analysis_export);  // Connect monitor's response analysis port to comparator's FIFO
      
      if (rf_pkg::verbose) begin
          // Connect monitor's analysis ports to printers' analysis exports
          mon.req_a.connect(req_prt.a_fifo.analysis_export); // Connect monitor's request analysis port to request printer
          //mon.rsp_a.connect(rsp_prt.a_fifo.analysis_export); // Connect monitor's response analysis port to response printer
      end
   endfunction : connect_phase

   task run_phase(uvm_phase phase);
       phase.raise_objection(this);
       // Start the test sequence
       tst.start(seqr);
       phase.drop_objection(this);
   endtask

endclass : tester_env
