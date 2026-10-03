`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/06 20:14:55
// Design Name: BCD to Excess-3 code converter(behavioral description)
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

    always @(B, E) begin
        E[0] <= !B[0];
        E[1] <= (B[1] && B[0]) || (!B[1] && !B[0]);
        E[2] <= !B[2] && (B[1] || B[0]) || B[2] && !B[1] && !B[0];
        E[3] <= B[3] || (B[2] && (B[1] || B[0]));
    end
endmodule
