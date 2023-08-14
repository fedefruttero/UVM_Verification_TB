interface p4_if #(parameter DWIDTH = 32);

// Interface signals for the P4
logic              clk;
logic              rst_n;
logic [DWIDTH-1:0] Aif;
logic [DWIDTH-1:0] Bif;
logic [DWIDTH-1:0] Scomb;
logic [DWIDTH-1:0] Ssync;
logic              CIN;
logic              COUT;

// Interface port P4 (Device Under Test)
modport p4_port (
    input Aif,
    input Bif,
    input CIN,
    output Scomb,
    output COUT
);


// To achieve synchronization with the P4 COMBINATIONAL  
always @(posedge clk) begin 
    Ssync = Scomb; 
end

// Initialize clock and reset signals
initial begin: init
    clk     = 1'b1;
    rst_n   = 1'b1;
end

// Generate a clock signal
always #10ns begin: clk_gen
    clk = ~clk;
end

endinterface //p4_if