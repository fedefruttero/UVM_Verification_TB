/*
We are gonna look at the monitor and the driver, both of them need to use an interface to talk to the memory. Rather than each of them having
their own build_phase, we are going to create a common build phase. 
This virtual word means nobody can instantiate interface_base as an object because is not complete, this class has to be extended so someone
can use it
*/
import generic_pkg::*;
class interface_base extends uvm_agent;

    `uvm_component_utils(interface_base)    
       
      virtual interface rf_if rfif; //the one we will use to control the signals 
    logic [NBITS-1:0] testrf [2**NREGISTERS-1:0];    
 
    function new(string name = "interface_base", uvm_component parent = null ); //same constructor as all the components
       super.new(name, parent);
    endfunction : new
    
    virtual      function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       rfif = global_rf_if; //we copy the global interface into our local copy
    endfunction : build_phase
 
 endclass : interface_base
 