class driver extends uvm_agent;

    `uvm_component_utils(driver)    //tells the factory that we have this class driver to create
    virtual interface p4_if i;

    // constructor
    function new(string name = "driver", uvm_component parent = null ); //we always need a parent and name
    super.new(name, parent);
    endfunction : new


    // build
    virtual function void build_phase(uvm_phase phase); //we only copy the handle to the global interface from the package to a local copy if 
    super.build_phase(phase);
    i = p4_pkg::global_p4_if;
    endfunction : build_phase

    //after build phase, run phase.
    //the phase object is used to raise and drop objections, are for telling the tb when to quit.
    //we raise objection like in the following line to tell the tb not to stop.
    //its the only that can take time, the others are in zero time.
    task run_phase(uvm_phase phase); 
        int nloops = 10000;


        phase.raise_objection(this); //tells the UVM that we are not finished
        repeat (nloops) begin
            @(posedge i.clk);
            i.CIN = $random;
            // Generate random values for Aif
        if ($urandom_range(0, 9) < 5) // Higher probability for values closer to 0
            i.Aif = $urandom_range(32'h00000000, 32'h000000ff);
        else
            i.Aif = $urandom_range(32'h7FFFFFFF, 32'hffffffff);

        // Generate random values for Bif
        if ($urandom_range(0, 9) < 5) // Higher probability for values closer to 0
            i.Bif = $urandom_range(32'h00000000, 32'h000000ff);
        else
            i.Bif = $urandom_range(32'h7FFFFFFF, 32'hffffffff);
        end
        phase.drop_objection(this);
    endtask : run_phase


    

endclass : driver
