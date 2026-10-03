`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/03 13:14:18
// Design Name: 
// Module Name: AOXNN
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


module AOXNN(x, and_o, or_o, xor_o, nor_o, nand_o);

input [1:0] x; //x[0]: DIP SWITCH1, x[1]: DIP SWITCH 2
output and_o, or_o, xor_o, nor_o, nand_o; 

assign 
    and_o = &x, //LED1: and
    or_o = |x,//LED2: or
    xor_o = ^x,//LED3: xor
    nor_o = ~|x, //LED4: nor
    nand_o = ~&x;//LED5: nand
endmodule
