`timescale 1ns/1ps

module tx_shift_register_tb();

    // 1. Declare signals
    // DUT inputs: reg (the testbench drives them)
    // DUT outputs: wire (the testbench observes them)

    reg clk;
    reg reset;
    reg load; 
    reg [7:0] data_in; 
    reg shift; 
    wire serial_out; 


    // 2. Instantiate the design under test (DUT)
    tx_shift_register dut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .data_in(data_in), 
        .shift(shift), 
        .serial_out(serial_out)
    );

    // 3. Generate the clock

    initial clk = 1'b0;
    always #10 clk = ~clk;


    // 4. Save waveforms
    initial begin
        $dumpfile("simulation.vcd");
        $dumpvars(0, tx_shift_register_tb);
    end

    initial begin
        // A. Initialize EVERY input to a known value.
        reset  = 1'b1; 
        load = 1'b0; 
        data_in = 8'hFF; 


        // B. Allow reset to take effect.
        repeat (2) @(negedge clk);

        //Test Case 1: Asserting reset 
        @(posedge clk); 
        #1; 
        if ((dut.shift_reg !== 8'hFF) || (serial_out !== 1'b1)) begin 
            $display("FAIL: Data out or serial out do not have the correct values. Test 1 unsuccessful."); 
            $finish; 
        end 
        $display("PASS: Test Case 1 successful."); 
        reset = 1'b0; 

        //Test Case 2: Load 8'hA6
        @(negedge clk); 
        data_in = 8'hA6; 
        load = 1'b1; 

        @(posedge clk); 
        #1; 
        if (serial_out !== 1'b0) begin 
            $display("FAIL: Serial out has the wrong value. Test 2 unsuccessful."); 
            $finish; 
        end 
        $display("PASS: Test Case 2 successful"); 

        // Test Case 3: Hold 
        @(negedge clk); 
        load = 1'b0; 
        shift = 1'b0; 
        data_in = 8'hA1; 

        @(posedge clk); 
        #1; 
        if (serial_out !== 1'b0) begin 
            $display("FAIL: Stored value should remain the same. Test 3 unsuccessful."); 
            $finish; 
        end 
        $display("PASS: Test Case 3 succesful"); 

        //Test Case 4: Shift through the byte  
        @(negedge clk); 
        shift = 1'b1;  

        @(posedge clk); 
        #1; 
        if (serial_out !== 1'b1) begin 
            $display("FAIL: Serial out should be 1. Test 4 unsuccessful."); 
            $finish; 
        end 
        $display("PASS: Test Case 4 successful."); 

        //Test Case 5: 8 shifts later
        @(negedge clk); 
        

        repeat (8) @(posedge clk); 
        #1; 
        if (serial_out !== 1'b1) begin
            $display("FAIL: Shift register should be all 1s. Test 5 unsuccessful."); 
            $finish; 
        end 
        $display("PASS: Test Case 5 succesful"); 

        //Test Case 6: Load, then consume and load together 
        

        //Test Case 7: Reset while full, with load, and consume high 
    
        
        // E. End the simulation.
        $finish;
    end

endmodule