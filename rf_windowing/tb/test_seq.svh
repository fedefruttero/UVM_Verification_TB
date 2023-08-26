//import generic_pkg::*;
class test_seq extends uvm_sequence #(rf_req , rf_data); //mem req is the outputdata and rf_data what comes back in
   
    `uvm_object_utils(test_seq)   
 
    rf_req req ;  //requirement
    rf_data rsp; //response
    int i = 0;

    function new(string name = "tester");
       super.new(name);
    endfunction : new

    task body();
      req = new();
      `uvm_info("run", "First, we set the RESET signal", UVM_MEDIUM); 
      call_return_reset(reset);

      //`uvm_info("test_seq",{"Got back: ",rsp.convert2string()},UVM_MEDIUM);
      `uvm_info("run", "We are about to initialize the registers in all the windows", UVM_MEDIUM);  
      read_write_window(write); //main
      call_return_reset(call);
      read_write_window(write); //SUB1
      
      call_return_reset(call);
      read_write_window(write); //SUB2
      
      call_return_reset(call);
      read_write_window(write); //SUB3
      
      read_write_window(read);
      call_return_reset(ret);
      read_write_window(read);
      call_return_reset(ret);
      read_write_window(read);
      call_return_reset(ret);
      read_write_window(read);
      
   
      `uvm_info("run", "Now we are going to call our first subroutine and read all the registers in the window", UVM_MEDIUM);
      call_return_reset(call);
      read_write_window(read);
      

      `uvm_info("run","Returning from the subroutine, SIGRETURN is set", UVM_MEDIUM);
      call_return_reset(ret);
      `uvm_info("run", "Now we are going to read all the registers in the current window", UVM_MEDIUM); 
      read_write_window(read);
     

      `uvm_info("run","Now the moment of truth, we are going to spill", UVM_HIGH);
      $display("");
      `uvm_info("run","Subroutine 1", UVM_MEDIUM);
      call_return_reset(call);
      `uvm_info("run","Subroutine 2", UVM_MEDIUM);
      call_return_reset(call);
      `uvm_info("run","Subroutine 3", UVM_MEDIUM);
      call_return_reset(call);
      `uvm_info("run","Subroutine 4", UVM_MEDIUM); //SPILL
      call_return_reset(call);
      //we write some registers in the subroutine:
      read_write_window(write);
      //now we read
      read_write_window(read);
      call_return_reset(ret);//return to sub3
      read_write_window(read); 
      call_return_reset(ret);//return to sub2
      read_write_window(read);
      call_return_reset(ret);//return to sub1
      read_write_window(read);
      $display("THE FOLLOWING SHOULD FAIL!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ");
      call_return_reset(ret);//return to main, this should fail  
      read_write_window(read);
   
   endtask : body














      task call_return_reset(rf_op operation);
         $display("");
         req = new();
         req.op = operation;
         start_item(req);
         finish_item(req);
         get_response(rsp);
         $display("");
      endtask;
    
      task read_write_window(rf_op operation);
         i=0;  
         repeat(14) begin //we read all the positions
            req = new();
            assert(req.randomize()); 
            //since i only want to randomize data:
            req.op   = operation;
            req.addr = i;
            req.port = 0;
            start_item(req);
            `uvm_info("test_seq", {"Sending transaction ",req.convert2string()}, UVM_HIGH); //UVM_HIGH info will not be printed
            finish_item(req);
            //Please get the response        
            get_response(rsp);      
            if(req.op == read) `uvm_info("test_seq",{"Got back: ",rsp.convert2string()},UVM_HIGH);
            i++;
         end 
         i=0;
         #1; //so we first read and we dont print the following uvm_info
         $display("");
      endtask
 endclass : test_seq


