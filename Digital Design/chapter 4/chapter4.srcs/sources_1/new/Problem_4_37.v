`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/06 20:14:55
// Design Name: four-bit adder-subtractor for unsigned binary numbers
// Module Name: Problem_4_37
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: hierarchical description of a four-bit adder-subtractor for unsigned binary numbers.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module Add_half(input a, b, output C_out, sum);
    xor G1(sum, a, b);
    and G2(C_out, a, b);
endmodule

module Add_full(input a, b, c_in, output c_out, sum);
    wire w1, w2, w3;
    Add_half M1(a, b, w1, w2);
    Add_half M0(w2, c_in, w3, sum);
    or (c_out, w1, w3);
endmodule

module Problem_4_37(S, C_out, A, B, M);
    input [3:0] A, B;
    input M;
    output [3:0] S;
    output C_out;
    wire [3:0] x;
    wire [3:1] c;
    xor
        G0(x[0], B[0], M),
        G1(x[1], B[1], M),
        G2(x[2], B[2], M),
        G3(x[3], B[3], M);
    Add_full
        F0(A[0], x[0], M, c[1], S[0]),
        F1(A[1], x[1], c[1], c[2], S[1]),
        F2(A[2], x[2], c[2], c[3], S[2]),
        F3(A[3], x[3], c[3], C_out, S[3]);
endmodule
