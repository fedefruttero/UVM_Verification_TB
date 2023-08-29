//----------------------------------------------------------------------
// Title: Printer for Pentium 4 Adder Testbench
// Author: Federico Fruttero
// Affiliation: Politecnico di Torino
// Description: This class represents the printer in the Pentium 4
//              adder testbench environment. It prints the input values,
//              carry mode, and results to the simulation log.
//----------------------------------------------------------------------

class printer extends uvm_agent;

  `uvm_component_utils(printer)
  virtual interface p4_if p4if; // Declare the interface instance

  // Constructor
  function new(string name = "printer", uvm_component parent = null );
      super.new(name, parent);
  endfunction : new

  // Build Phase: Connect the virtual interface instance to the global interface
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      p4if = p4_pkg::global_p4_if; // Access the global interface instance
  endfunction : build_phase

  // Run Phase: Print input values, carry mode, and results to the log
  task run_phase(uvm_phase phase);
      forever begin
          @(posedge p4if.clk);
          @(posedge p4if.clk);
          `uvm_info("run",
              $psprintf("A: %h | B: %h | ADD/SUB: (Cin = %b) | RESULT: %h (In decimal: %d)",
                        p4if.Aif, p4if.Bif, p4if.CIN, p4if.Ssync, p4if.Ssync),
                        UVM_MEDIUM);
      end
  endtask : run_phase

endclass : printer
