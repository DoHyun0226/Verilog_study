`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/22 10:40:49
// Design Name: 
// Module Name: TFF
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




module TFF(clk, rst, T, Q); 
// T flip-flop that is not applied with a one-shot trigger
// clk: clock, rst: negedge reset, T: Toggle, Q: output

input clk, rst, T;
output reg Q;

always @(posedge clk, negedge rst) 
begin
if (!rst)
    Q <= 0; 
else if(T)
    Q <= ~Q; // Toggle
end

endmodule
