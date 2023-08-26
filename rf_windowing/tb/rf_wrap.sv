
module rf_wrap #(parameter DWIDTH = 64) (rf_if.rf_port p);
    
    REGISTER_FILE_WINDOWING #(DWIDTH) DUT (
        .CLK            (p.clk),     
        .RESET          (p.RSTif),
        .ENABLE         (p.ENABLEif),
        .RD1            (p.RD1if),
        .RD2            (p.RD2if),
        .WR             (p.WRif) ,
        .CALL           (p.CALLif),
        .SIGRETURN      (p.SIGRETURNif),
        .ADD_WR         (p.ADD_WRif),
        .ADD_RD1        (p.ADD_RD1if),
        .ADD_RD2        (p.ADD_RD2if),
        .DATAIN         (p.DATAINif),
        .MEM_BUSread    (p.MEM_BUSreadif),
        .OUT1           (p.OUT1if),   
        .OUT2           (p.OUT2if),
        .MEM_BUS        (p.MEM_BUSif),
        .FILL           (p.FILLif),
        .SPILL          (p.SPILLif)
    );

endmodule