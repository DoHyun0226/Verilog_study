`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/22 10:05:29
// Design Name: 
// Module Name: DFF
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


module DFF(D, Q, clk, rst);
input D, clk, rst;
output reg Q;

always @(posedge clk, negedge rst) begin
    if(!rst) Q <= 0;
    else Q <= D; // In real, setup, hold time must be considered
end
endmodule
