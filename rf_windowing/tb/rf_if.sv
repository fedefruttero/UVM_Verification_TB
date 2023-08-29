// ----------------------------------------------------------------------------
// Title: RF Interface
// Author: Federico Fruttero
// Affiliation: Politecnico di Torino
// Description: This file defines a UVM interface for connecting to the Register File (RF). 
// The interface includes input and output signals for communication with the RF module.
// ----------------------------------------------------------------------------

import generic_pkg::*; 

interface rf_if #(parameter DWIDTH = 64);
    // INPUTS
    logic                   clk;           // Clock signal
    logic                   RSTif;         // Reset signal
    logic                   ENABLEif;      // Enable the RF
    logic                   RD1if;         // Read port 1 enable
    logic                   RD2if;         // Read port 2 enable
    logic                   WRif;          // Write port enable
    logic                   CALLif;        // Goes to one when a subroutine is called
    logic                   SIGRETURNif;   // Goes to one when we return from a subroutine
    logic [ADDR_SIZE-1:0]   ADD_WRif;      // Write address
    logic [ADDR_SIZE-1:0]   ADD_RD1if;     // Read address for port 1
    logic [ADDR_SIZE-1:0]   ADD_RD2if;     // Read address for port 2
    logic [NBITS-1:0]       DATAINif;      // Input data for write operation
    logic [NBITS-1:0]       MEM_BUSreadif; // Read data from memory

    int                     CWP = 0;       // Current Window Pointer
    int                     SWP = 10000;   // Start of Window Pointer

    // OUTPUTS:
    logic [NBITS-1:0]       OUT1if;        // Output data from port 1
    logic [NBITS-1:0]       OUT2if;        // Output data from port 2
    logic                   FILLif;        // Fill register from memory signal
    logic                   SPILLif;       // Spill register to memory signal
    logic [NBITS-1:0]       MEM_BUSif;     // Write data to memory

    // Interface port RF (Device Under Test)
    modport rf_port (
        input       clk,
        input       RSTif,
        input       ENABLEif,    
        input       RD1if,       
        input       RD2if,       
        input       WRif,        
        input       CALLif,      
        input       SIGRETURNif, 
        input       ADD_WRif,    
        input       ADD_RD1if,
        input       ADD_RD2if,
        input       DATAINif,
        input       MEM_BUSreadif,
        output      OUT1if,      
        output      OUT2if,      
        output      FILLif,
        output      SPILLif,
        output      MEM_BUSif  
    );

    // Initialize clock and reset signals
    initial begin: init
        clk   = 1'b1;
        RSTif = 1'b0;
    end

    // Generate a clock signal
    always #10ns begin: clk_gen
        clk = ~clk;
    end

endinterface // rf_if
