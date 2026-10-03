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


module t_unknown;
    wire complement_B, A, B;
    reg clk, rst;
    unknown uut(.complement_B(complement_B), .A(A), .B(B), .clk(clk), .rst(rst));

    always #5 clk = ~clk; // Toggle the clock signal every 5 time units
    initial begin
        #0 clk = 0; rst = 1'b0; // Initialize the clock and reset signals
        #6 rst = 1'b1; // Deassert the reset signal after 10 time units
    end
    initial #2000 $finish;
endmodule
