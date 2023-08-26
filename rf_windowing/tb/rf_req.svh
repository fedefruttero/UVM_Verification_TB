class rf_req extends rf_data; //EXTENDS rf_data because is basically rf_data with an extra data member, the operation OP.
    `uvm_object_utils(rf_req)    
       
      rand rf_op        op;

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
       return retVal;//WE ONLY ADD THE OPERATION 
    endfunction : convert2string
 
 //WE TAKE THE GENERIC uvm_object rhs and we pass it to our parent (super.do_copy(rhs)) which is in rf_data, rf_data class will copy the
 //address and the data so we dont have to worry about those, we only worry about the op.
    function void do_copy(uvm_object rhs);
       rf_req RHS;
       super.do_copy(rhs);
       $cast(RHS,rhs);
       op   = RHS.op;
    endfunction : do_copy
    
    function bit comp (uvm_object rhs);
       rf_req RHS;
       $cast (RHS, rhs);
       return  super.comp(rhs) && (RHS.op == op);
    endfunction : comp
    
    function void load_data(logic[ADDR_SIZE-1:0] a, logic[NBITS-1:0] d, logic p , rf_op o);
       super.load_data(a,d,p); 
       op   = o;
    endfunction : load_data
 
 endclass : rf_req
 
 