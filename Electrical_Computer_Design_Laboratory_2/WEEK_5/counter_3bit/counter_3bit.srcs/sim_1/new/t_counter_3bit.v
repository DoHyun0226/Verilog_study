`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/04 11:58:35
// Design Name: 
// Module Name: t_counter_3bit
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


module t_counter_3bit;
    reg clk, rst, x;
    wire [2:0] state;

    counter_3bit counter_instance(clk, rst, x, state);

    initial begin
        #0 clk <= 0; rst <= 0; x <= 1;
        #1 rst <= 1;            // t=1   : up count 0 -> 1 -> ... -> 7 -> 0 -> 1 (6~86ns)
        #94 x <= 0;             // t=95  : down count 1 -> 0 -> 7 -> 6 -> 5 (96~126ns)
        #35 rst <= 0;           // t=130 : asynchronous reset -> 0
        #5 rst <= 1; x <= 1;    // t=135 : up count 0 -> 1 -> 2 (136, 146ns)
        #20 $finish;            // t=155
    end

    initial #1 forever #5 clk <= !clk;
endmodule
