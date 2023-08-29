// ----------------------------------------------------------------------------
// Title: RF Request Transaction
// Author: Federico Fruttero
// Affiliation: Politecnico di Torino
// Description: This file defines a UVM transaction class for the Register File (RF) request. 
// It extends the rf_data transaction class by adding an additional operation field. The class 
// provides functions for string conversion, deep copying, comparison, and loading data into a transaction.
// ----------------------------------------------------------------------------

class rf_req extends rf_data; // Extends rf_data to include an operation field
   `uvm_object_utils(rf_req)    
      
   rand rf_op op; // Operation field

   function new(string name = "");
      super.new(name);
   endfunction : new

   function string convert2string();
       string retVal = "";
       case(op)
           reset:      retVal = {$psprintf("The signal %s was set, all registers are put to 0",op)};   
           call:       retVal = {$psprintf("The signal %s was set, we increase the CWP",op)};
           ret:        retVal = {$psprintf("The signal %s was set, we decrease the CWP",op)};
           nop:        retVal = {$psprintf("%s Operation, no changes",op)};
           read:       retVal = {super.convert2string()," ",$psprintf("op: %s",op)}; 
           write:      retVal = {super.convert2string()," ",$psprintf("op: %s",op)};
       endcase; 
       return retVal; // Append the operation information
   endfunction : convert2string

   // Deep copy implementation for creating a copy of the transaction
   function void do_copy(uvm_object rhs);
      rf_req RHS;
      super.do_copy(rhs);
      $cast(RHS,rhs);
      op = RHS.op;
   endfunction : do_copy
   
   // Compare transactions for equality
   function bit comp(uvm_object rhs);
      rf_req RHS;
      $cast (RHS, rhs);
      return super.comp(rhs) && (RHS.op == op);
   endfunction : comp
   
   // Load data into a transaction for simulation
   function void load_data(logic[ADDR_SIZE-1:0] a, logic[NBITS-1:0] d, logic p, rf_op o);
      super.load_data(a, d, p); 
      op = o;
   endfunction : load_data

endclass : rf_req
