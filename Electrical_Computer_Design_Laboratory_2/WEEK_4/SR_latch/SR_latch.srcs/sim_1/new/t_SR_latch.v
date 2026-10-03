`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/22 09:38:25
// Design Name: 
// Module Name: t_SR_latch
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


module t_SR_latch;
reg S, R;
wire Q, Q_bar;

SR_latch latch1(S, R, Q, Q_bar);

initial begin 
    #0 {S, R} = 2'b00; // S, R would be X 
    #10 {S, R} = 2'b10;
    #10 {S, R} = 2'b00; // read
    #10 {S, R} = 2'b01; // reset
    #10 {S, R} = 2'b00; // read
end
initial #50 $finish;
endmodule
