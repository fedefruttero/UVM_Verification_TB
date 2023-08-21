`include "uvm_macros.svh"
class scoreboard extends uvm_agent;
    `uvm_component_utils(scoreboard) //we tell the factory about it

//everything works the same here, it checks if the results are correct just like before
    virtual interface p4_if p4if;

    // constructor
    function new(string name = "scoreboard", uvm_component parent = null );
    super.new(name, parent);
    endfunction : new

    // build
    function void build();
    super.build();
    // Insert Build Code Here
    p4if = global_p4_if;
    endfunction : build



    task run();
        forever begin
            @(posedge p4if.clk);
            @(posedge p4if.clk);
            if (p4if.CIN == 0) begin
                assert(p4if.Ssync == p4if.Aif + p4if.Bif) else 
                  `uvm_error("run", 
                  $psprintf("expected %h  actual: %h", p4if.Aif + p4if.Bif, p4if.Ssync));
            end
            else if (p4if.CIN == 1) begin
                assert(p4if.Ssync == p4if.Aif - p4if.Bif) else 
                 `uvm_error("run", $psprintf("expected %h  actual: %h", p4if.Aif - p4if.Bif, p4if.Ssync));
                //UVM_ERROR, TOGETHER WITH UVM_INFO ARE 2 OF THE 4 REPORTING MACROS IN THE UVM.

            end     
        end
    endtask //run

endclass : scoreboard