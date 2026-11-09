`timescale 1ns/1ps

module module_name_tb;

    // 1. Declare signals
    // DUT inputs: reg (the testbench drives them)
    // DUT outputs: wire (the testbench observes them)

    reg clk;
    reg reset;
    reg enable; 
    wire next_bit; 


    // 2. Instantiate the design under test (DUT)

    baud_counter dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .next_bit(next_bit)
    );


    // 3. Generate the clock
    // Example: 20 ns period = 50 MHz

    initial clk = 1'b0;
    always #10 clk = ~clk;


    // 4. Save waveforms

    initial begin
        $dumpfile("simulation.vcd");
        $dumpvars(0, module_name_tb);
    end


    // 5. Apply inputs and run test cases

    initial begin
        // A. Initialize EVERY input to a known value.
        enable = 1'b1; 

        // B. Allow reset to take effect.
        repeat (2) @(negedge clk);
        reset = 1'b0;

        //Test Case 1: Asserting reset 
        reset = 1'b1; 
        @(posedge clk); 
        #1; 
        if (next_bit != 1'b0)
            $display("FAIL: Next bit does not have correct value. Test 1 unsuccessful."); 
        else 
            $display("PASS: Test Case 1 successful."); 
        
        // Test Case 2: Reset is released 
        @(negedge clk); 
        reset = 1'b0; 
        enable = 1'b1; 

        repeat 5207 @(posedge clk); 
        #1; 
        if (next_bit != 1'b0)
            $display("FAIL: Next bit does not have the correct value. Test 2 unsucessful."); 

        @(posedge clk); 
        #1; 
        if (next_bit != 1'b1) 
            $display("FAIL: Next bit does not have the correct value after 5208 cycles. Test 2 unsuccessful"); 
        
        @(posedge clk); 
        #1; 
        if (next_bit != 1'b0)
            $display("FAIL: Next bit does not have the correct value. Test 2 unsuccessful."); 
        else
            $display("PASS: Test Case 2 Successful."); 
     
        
        //Test Case 3: 


        // D. Repeat for other cases and boundaries.

        // E. End the simulation.
        $finish;
    end

endmodule