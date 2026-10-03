`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/06 20:14:55
// Design Name: 
// Module Name: Problem_4_39
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



module Problem_4_39(A, B, Y);
    input [3:0] A, B;
    output reg [5:0] Y;
    always @(A, B) 
        if (A == B) Y = 6'b10_0011;
        else if (A>B) Y = 6'b01_1010;
        else Y = 6'b01_0101;
endmodule
