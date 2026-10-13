`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Electrical_Computer_Design_Laboratory_2
// Engineer: DoHyun0226
//
// Create Date: 2026/10/10 23:24:06
// Design Name: bin2bcd_4bit
// Module Name: bin2bcd_4bit
// Project Name: bin2bcd_4bit
// Target Devices: xc7s75fgga484-1 (Spartan-7)
// Tool Versions: Vivado 2025.2.1
// Description: 4-bit binary to 2-digit BCD converter (combinational).
//              bcd[7:4] = tens digit, bcd[3:0] = ones digit
//
// Dependencies: none
//
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Combinational always block implementation
// Additional Comments:
//   always @(*) + blocking assignment (=) -> combinational logic
//   every case assigns bcd (plus default) -> no latch inferred
//
//////////////////////////////////////////////////////////////////////////////////


module bin2bcd_4bit(bin, bcd);

input [3:0] bin;
output reg [7:0] bcd;

always @(*) begin
    case (bin)
        4'b0000 : bcd = {4'b0000, 4'b0000};
        4'b0001 : bcd = {4'b0000, 4'b0001};
        4'b0010 : bcd = {4'b0000, 4'b0010};
        4'b0011 : bcd = {4'b0000, 4'b0011};
        4'b0100 : bcd = {4'b0000, 4'b0100};
        4'b0101 : bcd = {4'b0000, 4'b0101};
        4'b0110 : bcd = {4'b0000, 4'b0110};
        4'b0111 : bcd = {4'b0000, 4'b0111};
        4'b1000 : bcd = {4'b0000, 4'b1000};
        4'b1001 : bcd = {4'b0000, 4'b1001};
        4'b1010 : bcd = {4'b0001, 4'b0000};
        4'b1011 : bcd = {4'b0001, 4'b0001};
        4'b1100 : bcd = {4'b0001, 4'b0010};
        4'b1101 : bcd = {4'b0001, 4'b0011};
        4'b1110 : bcd = {4'b0001, 4'b0100};
        4'b1111 : bcd = {4'b0001, 4'b0101};
        default : bcd = {4'b0000, 4'b0000};
    endcase
end

endmodule
