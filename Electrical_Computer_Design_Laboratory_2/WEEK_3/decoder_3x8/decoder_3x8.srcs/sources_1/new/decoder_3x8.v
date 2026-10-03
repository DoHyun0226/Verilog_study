`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/12 13:31:07
// Design Name: 
// Module Name: decoder_3x8
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


module decoder_3x8(x, D);
input [2:0] x; //x[0]: DIP1, x[1]: DIP2, x[2]: DIP3
output reg [7:0] D;
// D[0]: LED1
// D[1]: LED2
// D[2]: LED3
// D[3]: LED4
// D[4]: LED5
// D[5]: LED6
// D[6]: LED7
// D[7]: LED8

always @(*)
begin
    case(x)
        3'b000 : D = 8'b00000001;
        3'b001 : D = 8'b00000010;
        3'b010 : D = 8'b00000100;
        3'b011 : D = 8'b00001000;
        3'b100 : D = 8'b00010000;
        3'b101 : D = 8'b00100000;
        3'b110 : D = 8'b01000000;
        3'b111 : D = 8'b10000000;
    endcase
end
endmodule
