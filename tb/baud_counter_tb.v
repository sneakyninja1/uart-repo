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

    initial begin
        // A. Initialize EVERY input to a known value.
        enable = 1'b1; 
        reset  = 1'b1; 

        // B. Allow reset to take effect.
        repeat (2) @(negedge clk);

        //Test Case 1: Asserting reset 
        @(posedge clk); 
        #1; 
        if (next_bit !== 1'b0) begin 
            $display("FAIL: Next bit does not have correct value. Test 1 unsuccessful."); 
            $finish; 
        end 
        $display("PASS: Test Case 1 successful."); 
        
        // Test Case 2: Reset is released 
        @(negedge clk); 
        reset = 1'b0; 
        enable = 1'b1; 

        repeat (5207) begin 
            @(posedge clk); 
            #1; 
            if (next_bit !== 1'b0) begin
                $display("FAIL: Next bit does not have the correct value. Test 2 unsucessful."); 
                $finish; 
            end
        end 
        //Edge 5208: Should pulse 
        @(posedge clk); 
        #1; 
        if (next_bit !== 1'b1) begin
            $display("FAIL: Next bit does not have the correct value after 5208 cycles. Test 2 unsuccessful"); 
            $finish; 
        end 

        //Edge 5209: Pulse ended 
        @(posedge clk); 
        #1; 
        if (next_bit !== 1'b0) begin 
            $display("FAIL: Next bit does not have the correct value. Test 2 unsuccessful."); 
            $finish; 
        end 

        $display("PASS: Test Case 2 Successful."); 
        
        //Test Case 3: Clear while counting 
        @(negedge clk); 
        #1; 
        enable = 1'b0; 

        @(posedge clk); 
        #1; 
        if (next_bit !== 1'b0) begin 
            $display("FAIL: Next bit does not have the correct value. Test 3 unsuccessful."); 
            $finish; 
        end 

        @(negedge clk); 
        enable = 1'b1; 

        repeat(5207) begin 
            @(posedge clk); 
            #1; 
            if (next_bit !== 1'b1) begin 
                $display("FAIL: Next bit does not have the correct value. Test 3 unsuccessful."); 
                $finish; 
            end 
        end

        @(posedge clk); 
        #1; 

        if (next_bit !== 1'b1) begin
            $display("FAIL: Expected pulse at cycle 5208 after re-enabling.");
            $finish;
        end

        $display("PASS: Test 3 successful."); 
        
        //Test Case 4: Reset while counting 
        reset = 1'b0; 
        repeat (100) @(posedge clk); 

        @(negedge clk); 
        reset = 1'b1; 

        @(posedge clk); 
        #1; 
        if (next_bit !== 1'b0) begin 
            $display("FAIL: Next bit does not have the correct value. Test 4 unsuccessful."); 
            $finish; 
        end 
        
        @(negedge clk); 
        reset = 1'b0; 
        repeat(5207) begin 
            @(posedge clk); 
            #1; 
            if (next_bit !== 1'b0) begin 
                $display("FAIL: Next bit does not have the correct value. Test 4 unsuccessful."); 
                $finish; 
            end 
        end

        @(posedge clk); 
        #1; 
        if (next_bit !== 1'b1) begin
            $display("FAIL: Expected pulse at cycle 5208 after releasing reset.");
            $finish;
        end

        $display("PASS: Test 4 successful."); 

        //Test Case 5: Repeated pulses 
        repeat (3) begin 
            repeat (5207) begin 
                @(posedge clk); 
                #1; 
                if (next_bit !== 1'b0) begin 
                $display("FAIL: Next bit does not have the correct value. Test 4 unsuccessful."); 
                $finish; 
            end 
            end 

            @(posedge clk); 
            #1; 
            if (next_bit !== 1'b1) begin
                $display("FAIL: Expected pulse at cycle 5208 after releasing reset.");
                $finish;
            end
        end

        $display("PASS: Test 5 successful."); 
        // E. End the simulation.
        $finish;
    end

endmodule