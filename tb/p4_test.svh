
class p4_test extends uvm_test;
    //this tells the factory there is a class called p4_test that has to build
    `uvm_component_utils(p4_test); //to create the object when someone types p4_test in the command line
    
    integer nloops = 50;
    virtual interface p4_if i;

    //we always need this kind of constructor
    function new(string name="", uvm_component parent);
        super.new(name, parent);
     endfunction : new


    function void build_phase(uvm_phase phase); //FIRST METHOD CALLED IN ORDER, OVERRITES THE ONE IN UVM_TEST
        super.build_phase(phase);
        i = p4_pkg::global_p4_if; //we copy the if from the package into our test object i
    endfunction : build_phase

    //after build phase, run phase.
    //the phase object is used to raise and drop objections, are for telling the tb when to quit.
    //we raise objection like in the following line to tell the tb not to stop.
    //its the only that can take time, the others are in zero time.
    task run_phase(uvm_phase phase); 
        phase.raise_objection(this); //tells the UVM that we are not finished
        repeat (nloops) begin
            @(negedge i.clk);
            i.Bif = $random;
            i.Aif = $random;
            i.CIN = 0;
            `uvm_info("run",$psprintf("A: %h B: %2h  CIN: %1b,  Scomb: %2h, Ssync: %2h",
                                                    i.Aif, i.Bif, i.CIN, i.Scomb, i.Ssync),UVM_MEDIUM); //UVM_MEDIUM is used to specify the verbosity level of a message or log statement
        end
        phase.drop_objection(this);
    endtask : run_phase
endclass