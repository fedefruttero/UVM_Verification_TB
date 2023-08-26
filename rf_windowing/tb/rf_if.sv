import generic_pkg::*; 

interface rf_if #(parameter DWIDTH = 64);
//INPUTS
logic                   clk;
logic                   RSTif;
logic                   ENABLEif;     //Enable the RF
logic                   RD1if;        //Read port 1 enable
logic                   RD2if;        //Read port 2 enable
logic                   WRif;         //Write port enable
logic                   CALLif;       //goes to one when a subroutine is called
logic                   SIGRETURNif;  //goes to one when we return from a subroutine
logic[ADDR_SIZE-1:0]    ADD_WRif;     //
logic[ADDR_SIZE-1:0]    ADD_RD1if;
logic[ADDR_SIZE-1:0]    ADD_RD2if;
logic[NBITS-1:0]        DATAINif;
logic[NBITS-1:0]        MEM_BUSreadif; //to FILL from the memory

int                     CWP = 0;
int                     SWP = 10000;

//OUTPUTS:
logic[NBITS-1:0]        OUT1if;       //OUT port1
logic[NBITS-1:0]        OUT2if;       //OUT port2
logic                   FILLif;
logic                   SPILLif;
logic[NBITS-1:0]        MEM_BUSif;    //To write the memory, SPILL


// Interface port RF (Device Under Test
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
    clk         = 1'b1;
    RSTif       = 1'b0;
end

// Generate a clock signal
always #10ns begin: clk_gen
    clk = ~clk;
end

endinterface //rf_if