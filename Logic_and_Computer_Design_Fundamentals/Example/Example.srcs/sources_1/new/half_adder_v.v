`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/01 12:24:48
// Design Name: 
// Module Name: half_adder_v
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


module half_adder_v(x, y, s, c);
    input x, y;
    output s, c;
    
    assign s = x ^ y;
    assign c = x & y;
    
endmodule


