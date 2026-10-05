`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/04 09:41:26
// Design Name: 
// Module Name: t_SM2_conditional_operator
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


module t_SM2_conditional_operator;
    reg clk, rst, A, B, C;
    wire [2:0] state;
    wire y;
   
    SM2_conditional_operator SM2_instance(clk, rst, A, B, C, state, y);
    
    initial begin
        #0 clk <= 0; rst <= 0; {A, B, C} <= 0;
        #1 rst <= 1;
        #4 A <= 1;
        #10 A <= 0; B <= 1; // The state of the vending machine responds only to B because of the one-shot trigger.
        #10 A <= 1; B <= 0;
        #10 A <= 0; B <= 1;
        #10 B <= 0; C <= 1;
        #10 C <= 0;
        #10 rst <= 0;
        #10 rst <= 1; A <= 1;
        #10 A <= 0; B <= 1;
        #10 B <= 0; C <= 1;
        #30 $finish;
    end
    
    initial #1 forever #5 clk <= !clk;
endmodule
