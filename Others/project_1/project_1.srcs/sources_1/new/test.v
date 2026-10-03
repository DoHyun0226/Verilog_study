`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: DoHyun
// 
// Create Date: 2026/03/16 19:49:45
// Design Name: 
// Module Name: test
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


module test(
output reg [3:0] bi_out,
input [3:0] gr_in
    );
    always @(gr_in)
    case (gr_in)
     4'b0000: bi_out <= 4'b0000; // Decimal 0
     4'b0001: bi_out <= 4'b0001; // Decimal 1
     4'b0011: bi_out <= 4'b0010; // Decimal 2
     4'b0010: bi_out <= 4'b0011; // Decimal 3
     4'b0110: bi_out <= 4'b0100; // Decimal 4
     4'b0111: bi_out <= 4'b0101; // Decimal 5
     4'b0101: bi_out <= 4'b0110; // Decimal 6
     4'b0100: bi_out <= 4'b0111; // Decimal 7
     4'b1100: bi_out <= 4'b1000; // Decimal 8
     4'b1101: bi_out <= 4'b1001; // Decimal 9
     4'b1111: bi_out <= 4'b1010; // Decimal 10
     4'b1110: bi_out <= 4'b1011; // Decimal 11
     4'b1010: bi_out <= 4'b1100; // Decimal 12
     4'b1011: bi_out <= 4'b1101; // Decimal 13
     4'b1001: bi_out <= 4'b1110; // Decimal 14
     4'b1000: bi_out <= 4'b1111; // Decimal 15
     default: bi_out <= 4'b0000; // 예외 처리 (안전한 설계를 위해 필수)
    endcase
endmodule
