
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
            {i.A, i.B, i.CIN} = $random;
            `uvm_info("run",$psprintf("A: %2h B: %2h  CIN: %1b,  OUTPUT ADD/SUB: %2h",
                                                    i.A, i.B, i.CIN, i.Ssync),UVM_MEDIUM); //idk what the UVM_MEDIUM is
        end
        phase.drop_objection(this);
    endtask : run_phase
endclass