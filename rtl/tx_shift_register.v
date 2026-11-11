module tx_shift_register(clk, reset, load, data_in, shift, serial_out); 
    input clk;           // FPGA clock; register updates on rising edges.
    input reset;         // Synchronous active-high reset.
    input load;          // Load all 8 bits from data_in; takes priority over shift.
    input [7:0] data_in; // Byte supplied by the TX holding register.
    input shift;         // Shift right by one bit when high at a rising edge.

    output serial_out;   // Current bit to transmit; reflects shift_reg[0].

    reg [7:0] shift_reg; // Internal storage; holds the byte being transmitted.

    assign serial_out = shift_reg[0]; 
    
    always @(posedge clk) begin 
    if (reset)  
        shift_reg <= 8'hFF; 
    else if (load)  
        shift_reg <= data_in; 
    else if (shift) 
        shift_reg <= {1'b1, shift_reg[7:1]}; 

    end 

endmodule 