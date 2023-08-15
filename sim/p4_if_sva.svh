

// // Macro to print the operation
// `define PRINT_OP(a, b, res) \
//     $sformatf("A: %d | B: %d | SUM: %d", $past(Aif), $past(Bif), $past(Ssync))

// // Counter for erroneous results
// int unsigned    err_num = 0;

// // Function to return the number of errors and reset the counter
// function int unsigned get_err_num();
//     automatic int unsigned n = err_num; // automatic keyword means the value is not preserved across function calls
//     err_num = 0;
//     return n;
// endfunction: get_err_num


// // Increment the counter at every falling edge of the clock
// always @(negedge clk) begin
//     counter++;
// end


// property p_result;
//     @(negedge clk) disable iff (counter<3)
//     ##1 Ssync == $past(Aif + Bif);
// endproperty

// // Check the assertion and display appropriate messages
// a_result: assert property (p_result)
//     if(counter > 3)
//         // Display a message when the test is passed
//         $display("TEST PASSED at time %t ns, %s",$time,`PRINT_OP(Aif,Bif,Ssync));
//     else begin
//         if (counter > 3) begin
//             err_num++;
//             // Display an error message when the test is failed
//             $error("%s", `PRINT_OP(Aif,Bif,Ssync));
//         end
//     end