`timescale 1ns/1ps

module tx_holding_register_tb;

    // 1. Declare signals
    // DUT inputs: reg (the testbench drives them)
    // DUT outputs: wire (the testbench observes them)

    reg clk;
    reg reset;
    reg load; 
    reg [7:0] data_in; 
    reg consume; 
    wire [7:0] data_out; 
    wire full; 

    // 2. Instantiate the design under test (DUT)
    tx_holding_register dut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .data_in(data_in), 
        .data_out(data_out), 
        .consume(consume), 
        .full(full)
    );

    // 3. Generate the clock
    // Example: 20 ns period = 50 MHz

    initial clk = 1'b0;
    always #10 clk = ~clk;


    // 4. Save waveforms
    initial begin
        $dumpfile("simulation.vcd");
        $dumpvars(0, tx_holding_register);
    end

    initial begin
        // A. Initialize EVERY input to a known value.
        reset  = 1'b1; 
        consume = 1'b0; 
        load = 1'b0; 
        data_in = 8'h00; 


        // B. Allow reset to take effect.
        repeat (2) @(negedge clk);

        //Test Case 1: Asserting reset 
        @(posedge clk); 
        #1; 
        if ((data_out!== 8'h00)|| (full !== 1'b0)) begin 
            $display("FAIL: Data out and full do not have the correct values. Test 1 unsuccessful."); 
            $finish; 
        end 
        $display("PASS: Test Case 1 successful."); 
        reset = 1'b0; 

        //Test Case 2: Load while empty 
        @(negedge clk); 
        data_in = 8'hA3; 
        load = 1'b1; 

        @(posedge clk); 
        #1; 
        if ((data_out !== 8'hA3) || (full !== 1'b1)) begin 
            $display("FAIL: Data out does not match data in. Should also be full. Test 2 unsuccessful."); 
            $finish; 
        end 
        $display("PASS: Test Case 2 successfull"); 

        // Test Case 3: Set load to 0 and try changing data_in 
        @(negedge clk); 
        load = 1'b0; 
        data_in = 8'hA1; 

        @(posedge clk) 
        #1; 
        if ((data_out !== 8'hA3) || (full == 1'b0)) begin 
            $display("FAIL: Data out and full should remain the same. Test 3 unsuccessful."); 
            $finish; 
        end 
        $display("PASS: Test Case 3 succesfull"); 

        //Test Case 4: Try Loading another variable while full 
        @(negedge clk); 
        data_in = 8'hB9; 
        load = 1'b1; 

        @(posedge clk); 
        #1; 
        if ((data_out !== 8'hA3) || (full !== 1'b1)) begin 
            $display("FAIL: Data out should remain the same since transmitter is already full. Test 4 unsuccessful."); 
            $finish; 
        end 
        $display("PASS: Test Case 4 successfull."); 

        //Test Case 5: Consume without loading 
        @(negedge clk)
        consume = 1'b1; 
        load = 1'b0; 

        @(posedge clk); 
        #1; 
        if ((data_out !== 8'hA3) || (full !== 1'b0)) begin
            $display("FAIL: Should not be full. The stored bits should remain unchanged. Test 5 unsuccessful."); 
            $finish; 
        end 
        $display("PASS: Test Case 5 succesfull"); 

        //Test Case 6: Load, then consume and load together 
        @(negedge clk); 
        data_in = 8'h11; 
        consume = 1'b1; 
        load = 1'b1; 

        @(posedge clk); 
        #1; 
        if ((data_out !== 8'h11) || (full !== 1'b1)) begin 
            $display("FAIL: Data out does not have the correct value. Register should be full. Test 6 unsuccessful"); 
            $finish; 
        end 
        $display("PASS: Test Case 6 successful."); 

        //Test Case 7: Reset while full, with load, and consume high 
        @(negedge clk); 
        reset = 1'b1; 

        @(posedge clk); 
        #1; 
        if ((data_out !== 8'h00) || (full !== 1'b0)) begin 
            $display("FAIL: Data out and full should be cleared upon reset. Test 7 unsuccessful."); 
            $finish; 
        end 
        $display("PASS: Test Case 7 successful."); 
        
        // E. End the simulation.
        $finish;
    end

endmodule