// ----------------------------------------------------------------------------
// Title: Verbose Test
// Author: Federico Fruttero
// Affiliation: Politecnico di Torino
// Description: This file defines the verbose test class for the testbench.
// ----------------------------------------------------------------------------

class verbose_test extends uvm_test;
   `uvm_component_utils(verbose_test) // Macros to register the class for factory creation
      
   tester_env t_env; // The test environment
   
   function new(string name, uvm_component parent); // Component constructor 
      super.new(name, parent);
   endfunction : new
   
   function void build();
      super.build();
      rf_pkg::verbose = 1; // Set the verbose flag to 1
      t_env = tester_env::type_id::create("t_env", this); // Create the test environment
   endfunction : build

   function void end_of_elaboration();
      t_env.set_report_verbosity_level_hier(UVM_MEDIUM); // Set report verbosity level to UVM_MEDIUM
   endfunction : end_of_elaboration
endclass : verbose_test
