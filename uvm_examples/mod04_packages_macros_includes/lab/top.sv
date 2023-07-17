import counter_pkg::*;
// Please add a new object of type monitor to print data to the screen
module top;

   counter_if ctr_if();
   counter DUT(ctr_if.cntr_mp);
   tester my_tester;
   ctr_checker my_checker;
   monitor my_monitor;
   // Please declare a variable of type monitor called my_monitor

   
   initial begin
      my_tester=new(ctr_if);
      my_checker=new(ctr_if);
      my_monitor=new(ctr_if);
      // Please create a new instance of my_monitor

      fork
         my_tester.run();
         my_checker.run();
         my_monitor.run();
         // Please call my_monitor.run()

      join_none
   end   
      
endmodule // top

   