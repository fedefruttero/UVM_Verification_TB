//----------------------------------------------------------------------
// Title: P4 Interface
// Author: Federico Fruttero
// Affiliation: Politecnico di Torino
// Description: This interface defines the signals and modports for the
//              Pentium 4 adder testbench environment. It includes signals
//              for clock, input operands, combinational and synchronized
//              sum outputs, carry input and output, as well as a counter
//              for operation tries after reset.
//----------------------------------------------------------------------

interface p4_if #(parameter DWIDTH = 32);
    // Interface signals for the P4
    logic              clk;      // Clock signal
    logic [DWIDTH-1:0] Aif;      // Input operand A
    logic [DWIDTH-1:0] Bif;      // Input operand B
    logic [DWIDTH-1:0] Scomb;    // Combinational sum output
    logic [DWIDTH-1:0] Ssync;    // Synchronized sum output
    logic              CIN;      // Carry input
    logic              COUT;     // Carry output
    integer counter = 0;         // Counter for operation tries after reset

    // Interface port P4 (Device Under Test)
    modport p4_port (
        input Aif,               // Connects to input operand A
        input Bif,               // Connects to input operand B
        input CIN,               // Connects to carry input
        output Scomb,            // Connects to combinational sum output
        output COUT              // Connects to carry output
    );

    // To achieve synchronization with the P4 COMBINATIONAL
    always @(negedge clk) begin
        Ssync = Scomb;
    end

    // Initialize clock and reset signals
    initial begin: init
        clk = 1'b1;              // Initialize the clock to high
    end

    // Generate a clock signal
    always #10ns begin: clk_gen
        clk = ~clk;              // Toggle the clock every 10 ns
    end
endinterface // p4_if
