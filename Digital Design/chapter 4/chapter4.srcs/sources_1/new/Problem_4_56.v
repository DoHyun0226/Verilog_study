`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/08 20:23:00
// Design Name: A comparator circuit that compares two 4-bit numbers to check if they are equal
// Module Name: Problem_4_56
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



module Problem_4_56(c_out, A, B);
    output c_out;
    input [3:0] A, B;
    wire L1, L2, L3, L4;
    assign
        L1 = !(A[0] ^ B[0]),
        L2 = !(A[1] ^ B[1]),
        L3 = !(A[2] ^ B[2]),
        L4 = !(A[3] ^ B[3]),
        c_out = L1 && L2 && L3 && L4; // If all bits are equal, c_out will be 1; otherwise, it will be 0.
endmodule
/*
module Problem_4_56(c_out, A, B);
    output c_out;
    input [3:0] A, B;
    assign
        c_out = (A == B);
endmodule
*/