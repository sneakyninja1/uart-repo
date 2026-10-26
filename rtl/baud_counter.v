//Baud rate generator is responsible for controlling how long each bit is 
//transmitted or received in the UART 

//next_bit -->Signal that tells the UART that 1 bit period has passed and it's 
// time to move on to the next bit. 

//FPGA clk = 50 MHz (in ref to DE2-115) 
//UART baud rate = 9600 bits/second
//Clock cycles per bit = 50 M/9600 = 5208.33

module baud_counter(enable, clk, reset, next_bit) 
    input enable; 
    input clk, reset; 
    output reg next_bit;

    reg [12:0] count;  
    always @(posedge clk)
        if (reset) begin 
            count <= 13'b0; 
            next_bit <= 1'b0; 
        end 
        
        else if (!enable) begin 
            count <= 13'd0; 
            next_bit <= 1'b0; 
        end 

        else if (count == 13'd5207) begin //1 FPGA clock cycle 
            count <= 13'b0; 
            next_bit <= 1'b1; 
        end 
        
        else begin
            count <= count + 13'd1;
            next_bit <= 1'b0;  
        end

endmodule 