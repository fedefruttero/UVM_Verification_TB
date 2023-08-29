// ----------------------------------------------------------------------------
// Title: Test Sequence
// Author: Federico Fruttero
// Affiliation: Politecnico di Torino
// Description: This file defines the test sequence that will be executed.
// ----------------------------------------------------------------------------

// Import the package containing your enums
// import generic_pkg::*;

class test_seq extends uvm_sequence #(rf_req, rf_data); // Sequence parameterized by rf_req and rf_data
    
   `uvm_object_utils(test_seq) // Macros to register the class for factory creation

   rf_req req;  // Request object
   rf_data rsp; // Response object
   int i = 0;   // Loop variable

   function new(string name = "tester");
      super.new(name); // Call parent constructor
   endfunction : new

   // Main task for this sequence
   task body();
       // Initialize request and response objects
       req = new();
       // Print information about setting RESET signal
       `uvm_info("run", "First, we set the RESET signal", UVM_MEDIUM); 
       // Call a subroutine for reset operation
       call_return_reset(reset);

       // Print information about initializing the registers in all windows
       `uvm_info("run", "We are about to initialize the registers in all the windows", UVM_MEDIUM);  

       read_write_window(write);            // Write all registers in Main window
       call_return_reset(call);             //FIRST SUBROUTINE CALL
       read_write_window(write);            // Write all registers in SUB1
       call_return_reset(call);             //SECOND SUBROUTINE CALL
       read_write_window(write);            // Write all registers in SUB2         
       call_return_reset(call);             //THIRD SUBROUTINE CALL 
       read_write_window(write);            // Write all registers in SUB3
       read_write_window(read);             //Read all registers in SUB3
       call_return_reset(ret);              //RETURN TO SUB2
       read_write_window(read);             //Read all registers in SUB2
       call_return_reset(ret);              //RETURN TO SUB1
       read_write_window(read);             //Read all registers in SUB1
       call_return_reset(ret);              //RETURN TO MAIN PROGRAM
       read_write_window(read);             //Read all registers in MAIN PROGRAM

       `uvm_info("run", "Now we are going to call our first subroutine and read all the registers in the window", UVM_MEDIUM);
       call_return_reset(call);
       read_write_window(read); 
       `uvm_info("run", "Returning from the subroutine, SIGRETURN is set", UVM_MEDIUM);
       call_return_reset(ret);
       `uvm_info("run", "Now we are going to read all the registers in the current window", UVM_MEDIUM); 
       read_write_window(read);
    


       `uvm_info("run", "Now the moment of truth, we are going to spill", UVM_HIGH);
       $display("");
       `uvm_info("run", "Subroutine 1", UVM_MEDIUM);
       call_return_reset(call);
       `uvm_info("run", "Subroutine 2", UVM_MEDIUM);
       call_return_reset(call);
       `uvm_info("run", "Subroutine 3", UVM_MEDIUM);
       call_return_reset(call);
       // Print information about Subroutine 4 (SPILL):
       `uvm_info("run", "Subroutine 4", UVM_MEDIUM); // SPILL
       call_return_reset(call);
       read_write_window(write);
       read_write_window(read);
       call_return_reset(ret); // Return to Sub3
       read_write_window(read); 
       call_return_reset(ret); // Return to Sub2
       read_write_window(read);
       call_return_reset(ret); // Return to Sub1
       read_write_window(read);
       // Call a subroutine for return operation (Return to main, a FILL will be performed)
       call_return_reset(ret);
       `uvm_info("run", "Returning to main program", UVM_MEDIUM)
     
       // Perform some NOP operations to give time for filling
       repeat(10) begin
           req = new();
           req.op = nop;
           start_item(req);
           finish_item(req);
           get_response(rsp);
       end
       // Read FILLED registers from memory
       read_write_window(read);

       // Print information about performing random operations without verbosity
       `uvm_info("run", "NOW I WANT TO PERFORM 10000 RANDOM OPERATIONS WITHOUT VERBOSITY::::::::::", UVM_MEDIUM);
       $display("");
       // Perform random operations without verbosity
       call_return_reset(reset);
       random_operations(10000);

       call_return_reset(reset);
       call_return_reset(call); //here   
       call_return_reset(call);
   endtask : body

   // Task to perform a given number of random operations without verbosity
   task random_operations(int number);
       // Turn off verbosity for the test's duration
       uvm_top.set_report_verbosity_level_hier(UVM_NONE);
       // Perform random operations
       repeat(number) begin
           req = new();
           // Randomize the request
           assert(req.randomize() with {
               addr <= 'hd; // Max value for the address
               // Distribution for the 'op' field
               data inside {[64'h0: 64'hFFFFFFFFFFFFFFFF]}; // Range for 64-bit number
               op dist {
                   read  := 27,
                   write := 27,
                   call  := 20,
                   ret   := 20,
                   reset := 6
               };
           });
           // Start and finish the transaction
           start_item(req);
           `uvm_info("test_seq", {"Sending transaction ", req.convert2string()}, UVM_HIGH);
           finish_item(req);
           // Get the response        
           get_response(rsp);      
           // Print the response if the operation was a read
           if (req.op == read)
               `uvm_info("test_seq", {"Got back: ", rsp.convert2string()}, UVM_HIGH);
       end
       // Restore verbosity level
       uvm_top.set_report_verbosity_level_hier(UVM_MEDIUM);
   endtask

   // Task to perform a call, return, or reset operation
   task call_return_reset(rf_op operation);
       $display("");
       // Create the request object for the specified operation
       req = new();
       req.op = operation;
       // Start and finish the transaction
       start_item(req);
       finish_item(req);
       // Get the response        
       get_response(rsp);
       $display("");
   endtask
   
   // Task to perform read and write operations in a window
   task read_write_window(rf_op operation);
       i = 0;  
       repeat(14) begin // Read all positions in the window
           req = new();
           assert(req.randomize()); 
           assert(req.randomize()); 
           // Randomize the data (for simplicity, I only want to randomize the data)
           req.op   = operation;
           req.addr = i;
           req.port = 0;
           // Start and finish the transaction
           start_item(req);
           `uvm_info("test_seq", {"Sending transaction ", req.convert2string()}, UVM_HIGH);
           finish_item(req);
           // Get the response        
           get_response(rsp);      
           // Print the response if the operation was a read
           if (req.op == read)
               `uvm_info("test_seq", {"Got back: ", rsp.convert2string()}, UVM_HIGH);
           i++;
       end 
       i = 0;
       #1; // Allow the initial read to complete before printing the following uvm_info
       $display("");
   endtask
endclass : test_seq
