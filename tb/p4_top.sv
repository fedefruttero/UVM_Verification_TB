import uvm_pkg::*;
import p4_pkg::*;

module top;
    p4_if interfac();
    P4_ADDER DUT(interfac.p4_port);

    initial begin
        global_p4_if = interfac;
      // Number of loops we want into the configuration
        set_config_int("*","nloops",50);
    
        run_test(); //run test is defined in the uvm package that we are importing
    end

endmodule //top