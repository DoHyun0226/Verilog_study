`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/01 12:26:49
// Design Name: 
// Module Name: full_adder_v
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


module full_adder_v(x, y, z, s, c); 
/*
x, y: number
z: initial carry
s: output
c: carry
*/
    input x, y, z;
    output s, c;
    
    wire hs, hc, tc;
    
    half_adder_v HA1(x, y, hs, hc),
                 HA2(hs, z, s, tc);
    or(c, hc, tc);
endmodule
