`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/12 13:43:54
// Design Name: 
// Module Name: decoder_3x8_with_decoder_2x4
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


module decoder_3x8_with_decoder_2x4(x, D);
input [2:0] x;
output [7:0] D;

decoder_2x4_withEN De1(x[1:0], x[2], D[3:0]);
decoder_2x4_withEN De2(x[1:0], !x[2], D[7:4]);

endmodule
