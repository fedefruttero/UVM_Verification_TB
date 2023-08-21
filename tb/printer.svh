class printer extends uvm_agent;

    `uvm_component_utils(printer) 
    virtual interface p4_if p4if;

    function new(string name = "printer", uvm_component parent = null );
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase); //we only copy the handle to the global interface from the package to a local copy if 
       super.build_phase(phase);
       p4if = p4_pkg::global_p4_if;
    endfunction : build_phase

    task run_phase(uvm_phase phase); //in its run phase it prints
        forever begin
          @(posedge p4if.clk);
          @(posedge p4if.clk);
          `uvm_info("run",
                          $psprintf("A: %h | B: %h | ADD/SUB: (Cin = %b) | RESULT: %h (In decimal: %d)",
                            p4if.Aif, p4if.Bif, p4if.CIN ,p4if.Ssync, p4if.Ssync),UVM_MEDIUM);
        end
     endtask : run_phase
     
  endclass : printer
  