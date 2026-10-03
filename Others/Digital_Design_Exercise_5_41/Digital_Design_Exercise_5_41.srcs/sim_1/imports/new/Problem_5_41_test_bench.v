`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/08 21:55:09
// Design Name: 
// Module Name: 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module t_pb_5_41; //pb_5_41 (output reg y, input x, clk, rst)
    wire y;
    reg x, clk, rst;
    pb_5_41 uut(.y(y), .x(x), .clk(clk), .rst(rst));

    always #5 clk = ~clk; // Toggle the clock signal every 5 time units
    initial begin
        #0 clk = 0; rst = 1'b0; x = 1'b0; // Initialize the clock and reset signals
        #1 rst = 1'b1; // Deassert the reset signal after 10 time units
    end
    always #2 x <= ~x; // Toggle the input signal x every 10 time units
    always #3 x <= ~x;
    always #7 x <= ~x;
    initial #2000 $finish; // Finish the simulation after 2000 time units
endmodule
