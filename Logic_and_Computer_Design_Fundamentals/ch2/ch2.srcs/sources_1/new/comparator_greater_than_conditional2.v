`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/08/17 12:30:53
// Design Name: 
// Module Name: comparator_greater_than_conditional2
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


// Two-bit greater-than circuit: Conditional model
// See Figure 2-27 for logic diagram
module comparator_greater_than_conditional2(A, B, A_greater_than_B);
 input [1:0] A, B;
 output A_greater_than_B;
 assign A_greater_than_B = (A > B)? 1'b1 :
                                     1'b0;
endmodule
