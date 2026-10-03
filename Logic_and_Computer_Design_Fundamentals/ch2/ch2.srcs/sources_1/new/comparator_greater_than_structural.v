`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/08/17 12:22:45
// Design Name: 
// Module Name: comparator_greater_than_structural
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


// Two-bit greater-than circuit: Verilog structural model
// See Figure 2-27 for logic diagram
module comparator_greater_than_structural(A, B, A_greater_than_B);
 input [1:0] A, B;
 output A_greater_than_B;
 wire B0_n, B1_n, and0_out, and1_out, and2_out;
  not
   inv0(B0_n, B[0]), inv1(B1_n, B[1]);
  and
   and0(and0_out, A[1], B1_n),
   and1(and1_out, A[1], A[0], B0_n),
   and2(and2_out, A[0], B1_n, B0_n);
  or
   or0(A_greater_than_B, and0_out, and1_out, and2_out);
endmodule
