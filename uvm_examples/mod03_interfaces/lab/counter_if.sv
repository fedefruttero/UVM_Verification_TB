interface counter_if ;

   // Please declare the following signals:
   // data_in is an 8-bit logic value
   // q, and q_beh are 8-bit logic values
   // clk, inc, ld, and rst are single bit logic values

   // Please define a modport called cntr_mp.  The modport should declare inputs
   // and outputs.
   // inputs: data_in, clk, inc, ld, rst
   // output q

   // Please create an initial block with a forever loop to generate the clock

   // Please create an initial block that holds the reset low for two clock cycles

  logic[7:0] data_in;
  logic[7:0] q;
  logic[7:0] q_beh;
  logic      clk;
  logic      rst;
  logic      inc;
  logic      ld;

  //interface port at counter side:
  modport cntr_mp (
    input data_in,
    input clk,
    input inc,
    input ld,
    input rst,
    output q
  );

  initial begin: clock_gen
      clk = 0'b1;
      forever #10 clk = ~clk;
  end
  
  initial begin: reset_dut
      rst = 0'b1;
      @(posedge clk);
      @(posedge clk);
      rst = 1'b1;
  end

   always @(posedge clk) begin: beh_cntr
      if (!rst)
        q_beh <= 0;
      else
        if (ld)
          q_beh <= data_in;
        else if (inc)
          q_beh++;
   end

   // Please create an always block that runs on the negative edge of the clock and asserts that q = q_beh
  always @(negedge clk) begin: asd
    $display ("reset: %1b data_in: %2h => q: %2h  ld: %1b  inc: %1b ",rst, data_in, q, ld, inc);
    assert(q === q_beh) else
      $display ("mismatch q: %2d  q_beh: %2d",q,q_beh);
  end
endinterface : counter_if