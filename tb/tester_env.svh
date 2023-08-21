class tester_env extends uvm_env; //the test is the one that instantiates the environment

    `uvm_component_utils(tester_env)    
 //1 variable for each of the vars
    driver drv;
    scoreboard sb;
    printer prnt;
    p4_cov coverag;

   int verbose;

    function new(string name = "tester_env", uvm_component parent = null );
        super.new(name, parent);
     endfunction : new
  
     function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = driver::type_id::create("drv",this);
        sb  = scoreboard::type_id::create("sb",this);
        if (p4_pkg::verbose) prnt = printer::type_id::create("prnt",this); //we create the printer only if its a verbose test.
        coverag = p4_cov::type_id::create("coverag",this);
     endfunction : build_phase
  endclass : tester_env