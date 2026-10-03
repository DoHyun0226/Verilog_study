`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/12 13:38:20
// Design Name: 
// Module Name: decoder_2x4_withEN
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


module decoder_2x4_withEN(x, EN, D);
input [1:0] x;
input EN;
output reg [3:0] D;

always @(*)
begin
if(EN == 0)
    case(x)
        2'b00 : D = 4'b1110;
        2'b01 : D = 4'b1101;
        2'b10 : D = 4'b1011;
        2'b11 : D = 4'b0111;
        default : D = 4'bxxxx;
    endcase
else
    D = 4'b1111;
end
endmodule
