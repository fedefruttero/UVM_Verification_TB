
module p4_wrap #(parameter DWIDTH = 32) (p4_if.p4_port p);

    P4_ADDER #(DWIDTH) DUT (
        .A(p.Aif),
        .B(p.Bif),
        .Ci(p.CIN),
        .S(p.Scomb)   
    );

endmodule