class printer #(type T = rf_data) extends uvm_agent; //parameterized.
    `uvm_component_param_utils(printer #(T)) //since its parameterized we use a different component param utils.
      uvm_tlm_analysis_fifo #(T) a_fifo; //we create a tlm analysis fifo of type T (whatever T is).
    
    function new(string name = "printer", uvm_component parent = null);
       super.new(name, parent);
    endfunction : new
 
    function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       a_fifo = new("a_fifo",this); //we create the fifo in the build phase.
    endfunction : build_phase
 
    task run_phase(uvm_phase phase);
       forever begin
          T data; //in the run phase we got data of type T 
          a_fifo.get(data); //we do a get in the analysis fifo, we block until there is data available
          uvm_report_info("run",data.convert2string(),UVM_LOW); //once we got data, we print it to the screen.
       end
    endtask : run_phase
 endclass : printer
 
 //we have 2 of these printers, one prints what is writen in the req port and the other whats writen in the rsp_port
 