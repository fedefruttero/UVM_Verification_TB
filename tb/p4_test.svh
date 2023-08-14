
class p4_test extends uvm_test;
    //this tells the factory there is a class called cat that has to build
    `uvm_component_utils(p4_test);
    
    integer nloops = 50;
    virtual interface p4_if i;

    //we always need this kind of constructor
    function new(string name="", uvm_component parent);
        super.new(name, parent);
     endfunction : new


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        i = p4_pkg::global_p4_if;
    endfunction : build_phase

    //after build phase, run phase.
    //the phase object is used to raise and drop objections, are for telling the tb when to quit.
    //we raise objection like in the following line to tell the tb not to stop
    task run_phase(uvm_phase phase); 
        phase.raise_objection(this);
        repeat (nloops) begin
            @(negedge i.clk);
            {i.Bif, i.CIN} = $random;
            i.Aif = $random;
            `uvm_info("run",$psprintf("A: %h B: %2h  CIN: %1b,  OUTPUT ADD/SUB: %2h",
                                                    i.Aif, i.Bif, i.CIN, i.Scomb),UVM_MEDIUM); //UVM_MEDIUM is used to specify the verbosity level of a message or log statement
        end
        phase.drop_objection(this);
    endtask : run_phase
endclass