`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/24 14:28:04
// Design Name: 
// Module Name: t_TFF_oneshot
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


module t_TFF_oneshot;
reg clk, rst, T;
wire Q;

TFF_oneshot TFF1(clk, rst, T, Q);

initial begin
  #0 clk <= 0; rst <= 0; T <= 0;
  #1 rst <= 1;
  #10 T <= 1;
  #20 T <= 0;
  #10 T <= 1;
  #15 T <= 0;
  #9 T <= 1;
  #12 T <= 0;
end

always begin
  #2 clk <= ~clk;
end

initial #80 $finish;
endmodule
