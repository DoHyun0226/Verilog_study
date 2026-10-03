`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/22 10:16:44
// Design Name: 
// Module Name: t_DFF
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


module t_DFF;
reg D, clk, rst;
wire Q;

DFF DFF1(D, Q, clk, rst);

initial fork 
#0 clk <= 0; D <= 0; rst <= 0;
#3 rst <= 1;
#13 D <= 1;
#26 D <= 0;
#39 D <= 1;
#52 D <= 0;
#65 D <= 1;
#78 D <= 0;
join

initial forever #5 clk = ~clk;
initial #90 $finish;
endmodule
