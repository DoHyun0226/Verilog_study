`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/06 20:14:55
// Design Name: eight-bit ALU
// Module Name: Problem_4_44
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



module Problem_4_44(y, A, B, Sel);
    input [7:0] A, B;
    input [2:0] Sel;
    output [7:0] y;

    always @(A or B or Sel) begin
        case(Sel)
            3'b000: y <= 8'b00000000; // 0
            3'b001: y <= A & B; // A AND B
            3'b010: y <= A | B; // A OR B
            3'b011: y <= A ^ B; // A XOR B
            3'b100: y <= ~A; // NOT A
            3'b101: y <= A - B; // A - B
            3'b110: y <= A + B; // A + B
            3'b111: y <= 8'b11111111; // 255
        endcase
    end
endmodule
