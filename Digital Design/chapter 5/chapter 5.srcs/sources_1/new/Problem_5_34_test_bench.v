`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/08 21:55:09
// Design Name: testbench for JK flip-flop
// Module Name: t_JK_FF_with_D_FF_and_2_to_1_MUX
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

module t_JK_FF_with_D_FF_and_2_to_1_MUX;
    reg J, K, clk;
    wire Q;

    JK_FF_with_D_FF_and_2_to_1_MUX jkff(J, K, clk, Q);

    initial begin
        // Initialize inputs
        J <= 0; K <= 0; clk <= 0;
        #10 J <= 0; K <= 1; // Reset state -> Q = 0
        #10 J <= 1; K <= 0; // Set state -> Q = 1
        #10 J <= 1; K <= 1; // Toggle state -> Q toggles -> Q = 0
        #10 J <= 0; K <= 0; // Hold state -> Q holds its value -> Q = 0
        #10 J <= 1; K <= 0; // Set state -> Q = 1
        #10 J <= 0; K <= 1; // Reset state -> Q = 0
        #10 J <= 1; K <= 1; // Toggle state -> Q toggles -> Q = 1
    end

    // Clock generation
    always #5 clk = ~clk; // Toggle clock every 5 time units

    initial #110 $finish; // End simulation after 100 time units
    
endmodule