`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/04 11:31:37
// Design Name: 
// Module Name: t_counter_2bit
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


module t_counter_2bit;
    reg clk, rst, x;
    wire [1:0] state;

    counter_2bit counter_instance(clk, rst, x, state);

    initial begin
        #0 clk <= 0; rst <= 0; x <= 0;
        #1 rst <= 1;
        #4 x <= 1;          // 00 → 01
        #10 x <= 0;
        #10 x <= 1;         // 01 → 10
        #10 x <= 0;
        #10 x <= 1;         // 10 → 11
        #10 x <= 0;
        #10 x <= 1;         // 11 → 00 (wrap-around)
        #10 x <= 0;
        #10 x <= 1;         // 00 → 01, x를 30ns 동안 유지해도 한 번만 증가
        #30 x <= 0;
        #10 rst <= 0;       // 리셋 → 00
        #10 rst <= 1;
        #10 x <= 1;         // 00 → 01
        #10 x <= 0;
        #30 $finish;
    end

    initial #1 forever #5 clk <= !clk;
endmodule