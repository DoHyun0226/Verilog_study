`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/06 20:14:55
// Design Name: BCD to Excess-3 code converter
// Module Name: Problem_4_42
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



module Problem_4_42(B, E);
    input [3:0] B;
    output [3:0] E;
    wire w1, w2, w3, w4, w5, w6, w7;

    not 
        G1(E[0], B[0]),
        G2(w4, B[2]), 
        G3(w3, w2);
    or
        G4(w2, B[0], B[1]),
        G5(E[1], w1, w3), 
        G6(E[2], w5, w6),
        G7(E[3], w7, B[3]);
    and
        G8(w1, B[0], B[1]),
        G9(w5, w3, B[2]),
        G10(w6, w4, w2),
        G11(w7, B[2], w2);
endmodule
