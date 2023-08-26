/*
Transactions are OBJECTS (CLASSES), we implement them by extending UVM_TRANSACTION. There are several things you do to a class to be a transaction:

1) EXTEND UVM_TRANSACTION
2) does not extend from uvm_component so its not a component. So it uses uvm_object_utils
3) 
*/
import generic_pkg::*;
class rf_data extends uvm_sequence_item;    
    `uvm_object_utils(rf_data)  

    rand logic[NBITS-1:0]     data;
    rand logic[ADDR_SIZE-1:0] addr;
    rand logic                port;


    function new(string name = ""); //doesnt have a parent because its not in the hierarchy of the UVM.
        super.new(name);
     endfunction : new
  
     function string convert2string(); //takes the data thats in your transaction and returns it as a string.
        return $psprintf("addr: %h data (port %d): %h",addr,port,data);
     endfunction : convert2string

     //the do_copy MUST be implemented exactly like this. uvm_object is a general version of uvm_transaction, we use it so we can
    //do what is called DEEP COPY. this is: we want to make sure all of the fields in our parent are getting copied but we dont want
    //to know whats happening in the parent class to make the copy happen, so we receive an argument as an uvm_object (we want it to be a mem_data obj)
    
   function void do_copy(uvm_object rhs); 
    rf_data RHS;
    super.do_copy(rhs); 
    $cast(RHS,rhs); //we do this cast so we can access ADDR and DATA
    data     = RHS.data;
    addr     = RHS.addr;
    port     = RHS.port;
    endfunction : do_copy

    function bit comp (uvm_object rhs);
        rf_data RHS;
        $cast (RHS,rhs);
        return ((RHS.addr == addr) && (RHS.data == data) && (RHS.port == port));
     endfunction : comp

     function void load_data (logic[ADDR_SIZE-1:0] a, logic[NBITS-1:0] d, logic p); //TO LOAD DATA INTO A TRANSACTION
        addr = a;     
        data = d;
        port = p;
     endfunction : load_data
     
endclass : rf_data