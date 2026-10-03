`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/03 12:51:49
// Design Name: 
// Module Name: full_adder
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


module full_adder(x, y, c_in, s, c_out);
input x, y, c_in; //x: DIP SWITCH 1, y: DIP SWITCH 2, c_in: DIP SWITCH 3
output s, c_out;//s: LED1, c_out: LED2

wire s1, c1, c2;

half_adder 
    hf1(x, y, s1, c1),
    hf2(s1, c_in, s, c2);

or(c_out, c1, c2);


endmodule
