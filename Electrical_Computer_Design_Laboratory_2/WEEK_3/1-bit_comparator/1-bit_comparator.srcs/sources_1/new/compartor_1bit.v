`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/12 13:19:46
// Design Name: 
// Module Name: compartor_1bit
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


module compartor_1bit(a, b, x, y, z);
input a, b;
output x, y, z;

assign x = a & !b, // a > b
       y = !((a & !b) | (!a & b)), //a = b
       z = !a & b; // a < b;
endmodule
