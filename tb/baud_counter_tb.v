`timescale 1ns/1ps 

module baud_counter_tb(); 
reg clk; 
reg reset; 
reg enable; 
reg next_bit; 

baud_counter dut (
    .clk(clk), 
    .reset(reset), 
    .enable(enable), 
    .next_bit(next_bit)
); 

initial clk = 1'b0; 
always #10 clk = ~clk; 

 initial begin
        $dumpfile("simulation.vcd");
        $dumpvars(0, baud_counter_tb);
    end


initial begin 
    reset = 1'b1; 

    repeat(2) @(negedge clk); 
    reset = 1'b0; 
    

endmodule; 




