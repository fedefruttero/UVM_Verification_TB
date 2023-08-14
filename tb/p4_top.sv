import uvm_pkg::*;
import p4_pkg::*;

module top;

    localparam DWIDTH = 32;

    p4_if #(DWIDTH) interfac();
    p4_wrap #(DWIDTH) p4_wrap(interfac);

    initial begin
        global_p4_if = interfac;
      // Number of loops we want into the configuration
        set_config_int("*","nloops",50);
    
        run_test(); //run test is defined in the uvm package that we are importing
    end

endmodule //top