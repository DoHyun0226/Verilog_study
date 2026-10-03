`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/08/17 12:30:53
// Design Name: 
// Module Name: comparator_greater_than_dataflow
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


// Two-bit greater-than circuit: Dataflow model
// See Figure 2-27 for logic diagram
module comparator_greater_than_dataflow(A, B, A_greater_than_B);
 input [1:0] A, B;
 output A_greater_than_B;
 wire B1_n, B0_n, and0_out, and1_out, and2_out;

 assign B1_n = ~B[1];
 assign B0_n = ~B[0];

 assign and0_out = A[1] & B1_n;
 assign and1_out = A[1] & A[0] & B0_n;
 assign and2_out = A[0] & B1_n & B0_n;

 assign A_greater_than_B = and0_out | and1_out | and2_out;
endmodule
