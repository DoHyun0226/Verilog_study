`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/12 13:24:49
// Design Name: 
// Module Name: comparator_4bit
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


module comparator_4bit(a, b, x, y, z);
input [3:0] a, b; 
//a: DIP1~4   
//b: DIP5~8
output wire x, y, z; 
//x(a>b): LED1
//y(a==b): LED2
//z(a<b): LED3

assign x = (a > b) ? 1'b1 : 1'b0, 
       y = (a == b) ? 1'b1 : 1'b0, 
       z = (a < b) ? 1'b1 : 1'b0;
endmodule
