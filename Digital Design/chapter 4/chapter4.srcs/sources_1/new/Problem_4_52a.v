`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/08 20:23:00
// Design Name: A full-subtractor circuit incrementer (A circuit that adds 1 to a 4-bit binary number) 
// Module Name: Problem_4_52a
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



module Problem_4_52a(S, C, A);
    output [3:0] S;
    output C;
    input [3:0] A;
    wire L1, L2, L3;

    assign
        L1 = A[0] && 1,
        L2 = A[1] && L1,
        L3 = A[2] && L2,
        S[0] = A[0] ^ 1,
        S[1] = A[1] ^ L1,
        S[2] = A[2] ^ L2,
        S[3] = A[3] ^ L3,
        C = A[3] && L3;
endmodule

