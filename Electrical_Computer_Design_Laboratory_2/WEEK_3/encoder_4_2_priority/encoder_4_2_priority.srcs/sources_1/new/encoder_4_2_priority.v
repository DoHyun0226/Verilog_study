`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/12 15:41:51
// Design Name: 
// Module Name: encoder_4_2_priority
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


module encoder_4_2_priority(in, out, valid);
input [3:0] in; 
//in[0]: DIP1
//in[1]: DIP2
//in[2]: DIP3
//in[3]: DIP4
output [1:0] out; //out[0]: LED1, out[1]: LED2
output valid; // valid: LED3

assign out[0] = in[3] | (in[1] & !in[2]),
       out[1] = in[2] | in[3],
       valid = in[0] | in[1] | in[2] | in[3];
endmodule
