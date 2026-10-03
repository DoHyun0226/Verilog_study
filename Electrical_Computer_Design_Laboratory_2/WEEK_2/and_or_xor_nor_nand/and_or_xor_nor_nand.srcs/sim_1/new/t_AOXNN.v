`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/03 13:21:37
// Design Name: 
// Module Name: t_AOXNN
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


module t_AOXNN;
reg [1:0] x;
wire and_o, or_o, xor_o, nor_o, nand_o;

AOXNN AOXNN_test(x, and_o, or_o, xor_o, nor_o, nand_o);

initial begin
#0 x = 2'b00;
#10 x = 2'b01;
#10 x = 2'b10;
#10 x = 2'b11;
end
initial $monitor("time: %0t\tx: %b\tand_o: %b\tor_o: %b\txor_o: %b\tnor_o: %b\tnand_o: %b", $time, x, and_o, or_o, xor_o, nor_o, nand_o);
initial #40 $finish;

endmodule
