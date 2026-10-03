`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/12 15:57:07
// Design Name: 
// Module Name: MUX_4bit_in_8_to_1
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


module MUX_4bit_in_8_to_1(in, sel, out);
input [31:0] in;
input [2:0] sel;
output reg [3:0] out;

always @(*)
begin
case(sel)
    3'b000: out = in[3:0];
    3'b001: out = in[7:4];
    3'b010: out = in[11:8];
    3'b011: out = in[15:12];
    3'b100: out = in[19:16];
    3'b101: out = in[23:20];
    3'b110: out = in[27:24];
    3'b111: out = in[31:28];
    default: out = 4'b0000;
endcase
end

endmodule
