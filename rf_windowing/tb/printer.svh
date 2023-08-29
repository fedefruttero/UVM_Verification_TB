// ----------------------------------------------------------------------------
// Title: Printer
// Author: Federico Fruttero
// Affiliation: Politecnico di Torino
// Description: This file defines a UVM agent class for printing out transaction data 
// from an analysis FIFO. The printer agent receives transactions from the FIFO and 
// reports their contents.
// ----------------------------------------------------------------------------

class printer #(type T = rf_data) extends uvm_agent; // Parameterized class

   `uvm_component_param_utils(printer #(T)) // Using parameterized component param utils
   
   uvm_tlm_analysis_fifo #(T) a_fifo; // Declaring a TLM analysis FIFO of type T

   function new(string name = "printer", uvm_component parent = null);
       super.new(name, parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       a_fifo = new("a_fifo", this); // Create the analysis FIFO in the build phase
   endfunction : build_phase

   task run_phase(uvm_phase phase);
       forever begin
           T data; // Declare a variable of type T to hold incoming data
           a_fifo.get(data); // Get data from the analysis FIFO, blocking until data is available
           uvm_report_info("run", data.convert2string(), UVM_LOW); // Print the data to the screen
       end
   endtask : run_phase

endclass : printer
