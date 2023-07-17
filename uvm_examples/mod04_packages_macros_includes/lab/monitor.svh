class monitor;
   virtual interface counter_if inte;
   // Please declare a virtual interface of type counter_if called i.

   // Please create a constructor called new that accepts a 
   // virtual interface counter_if as an argument
   function new(virtual interface counter_if vif);
   inte = vif;
   endfunction

   task run;
      forever begin
         @(negedge inte.clk);
               $display("counter's out: %5d",inte.q);
      end
   endtask
   // Please create a task called run that loops forever and 
   // prints the counter's out on the negative  edge of i.clk.

endclass // monitor


