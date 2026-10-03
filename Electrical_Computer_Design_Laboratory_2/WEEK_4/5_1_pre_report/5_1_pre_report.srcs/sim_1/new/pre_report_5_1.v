`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/24 14:39:34
// Design Name: 
// Module Name: pre_report_5_1
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


module pre_report_5_1;
reg [31:0] A, B, C, D;
initial begin
#0 A = 4; B = 9; C = 14; D = 19;
#10 B = A + C; C = A + B; A = B + C;
end


initial begin
#0 $display("start"); $monitor("t = %0t A = %0d B = %0d C = %0d D = %0d", $time, A, B, C, D);
#20 $finish;
end 
endmodule
