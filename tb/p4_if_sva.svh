// Macro to print the operation
`define PRINT_OP(a, b, op, CIN, res,res) \
    $sformatf("A: %2h | B: %2h | ADD/SUB: %s(Cin = %b) | RESULT: %2h (In decimal: %d)", $past(Aif), $past(Bif), op, $past(CIN) , $past(Ssync), -2)

// Counter for erroneous results
int unsigned    err_num = 0;

// Function to return the number of errors and reset the counter
function int unsigned get_err_num();
    automatic int unsigned n = err_num; // automatic keyword means the value is not preserved across function calls
    err_num = 0;
    return n;
endfunction: get_err_num


// Increment the counter at every falling edge of the clock
always @(negedge clk) begin
    counter++;
end


property p_result;
    @(negedge clk) disable iff (counter<3)
    case (CIN)
    0: ##1 Ssync == $past(Aif + Bif);
    1: ##1 Ssync == $past(Aif - Bif);
    default: ##1 Ssync == 'h0;
    endcase
endproperty

// Check the assertion and display appropriate messages
a_result: assert property (p_result)
    if(counter > 3)
        // Display a message when the test is passed
        if ($past(CIN) == 0)
            $display("TEST PASSED at time %t ns, %s",$time,`PRINT_OP(Aif,Bif,"ADD",CIN,Ssync,-2));
        else 
            $display("TEST PASSED at time %t ns, %s",$time,`PRINT_OP(Aif,Bif,"SUB",CIN,Ssync,Ssync));
    else begin
        if (counter > 3) begin
            err_num++;
            // Display an error message when the test is failed
            if (CIN == 0)
                $error("run",$psprintf("ADD: Expected %h  Received %h",$past(Aif + Bif), Ssync));
            else
                $error("run",$psprintf("SUB: Expected %h  Received %h",$past(Aif - Bif), Ssync));
        end
    end