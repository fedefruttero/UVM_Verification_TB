class verbose_test extends uvm_test;
    `uvm_component_utils(verbose_test)    
       
      tester_env t_env;
 
    function new(string name, uvm_component parent); //component constructor 
       super.new(name, parent);
    endfunction : new
    
    function void build();
       super.build();
       t_env = tester_env::type_id::create("t_env", this);
    endfunction : build
 
    function void end_of_elaboration();
       t_env.set_report_verbosity_level_hier(UVM_MEDIUM);
    endfunction : end_of_elaboration
 
 endclass : verbose_test
 
 