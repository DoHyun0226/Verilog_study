`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/15 14:57:31
// Design Name: 
// Module Name: Mux_4_1
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


module Mux_4_1(in0, in1, in2, in3, sel, out);
input [1:0] in0, in1, in2, in3; //DIP1~8
input [1:0] sel; //SM_1,2
output reg [1:0] out;//LED1, 2

always @(*) begin
case(sel)
    2'b00: out = in0;
    2'b01: out = in1;
    2'b10: out = in2;
    2'b11: out = in3;
endcase
end
endmodule
