`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/12 14:24:14
// Design Name: 
// Module Name: t_comparator_4bit
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


module t_comparator_4bit;
reg [3:0] A, B;
wire A_win, equal, B_win;

comparator_4bit CP4(A, B, A_win, equal, B_win);
initial begin
#0 A <= 4'b0011; B <= 4'b1000;
#10 A <= 4'b0111; B <= 4'b0001;
#10 A <= 4'b1001; B <= 4'b1001;
#10 A <= 4'b1011; B <= 4'b1111;
end
initial #40 $finish;
endmodule
