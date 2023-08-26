package generic_pkg; 
    localparam          NBITS       = 64;
    localparam          NREGISTERS  = 32;
    localparam          N           = 3;   //Number of registers in each block
    localparam          F           = 4;   //Number of windows
    localparam          M           = 5;   //Global register number

    // Define a macro to calculate ceiling of log2
    `define CLOG2_CEIL(x) ($clog2(x))
    localparam ADDR_SIZE = `CLOG2_CEIL(N*3+M+1);

endpackage : generic_pkg //generics_pkg