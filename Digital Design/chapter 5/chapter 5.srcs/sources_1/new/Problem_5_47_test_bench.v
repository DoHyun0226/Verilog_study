`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/12 18:19:32
// Design Name: 
// Module Name: t_multiple_of_two_sequence_maker
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


module t_multiple_of_two_sequence_maker;
// multiple_of_two_sequence_maker(output reg [3:0] sequence, input Run, clk, rst)
    wire [3:0] sequence;
    reg Run, clk, rst;
    multiple_of_two_sequence_maker S1 (sequence, Run, clk, rst);
    always #5 clk <= ~clk;
    initial begin
        #0 clk <= 0; rst <= 1'b1; Run <= 0;
        #1 rst <= 0;
        #3 Run <= 1'b1;
        #141 Run <= 0;
        repeat (7) #20 Run <= ~Run;
    end
    initial #500 $finish;
endmodule
