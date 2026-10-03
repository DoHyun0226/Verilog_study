`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/06 20:14:55
// Design Name: 
// Module Name: Problem_4_36
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


module Problem_4_36(
input [3:0] D,
output x, y, V
    );
    wire [2:0] w;
    not G1(w[0], D[2]);
    and G2(w[1], w[0], D[1]);
    or
        G3(x, D[2], D[3]),
        G4(y, D[3], w[1]),
        G5(V, x, D[1], D[0]);
endmodule
