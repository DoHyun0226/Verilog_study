`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/11 19:06:30
// Design Name: test bench file for test.v
// Module Name: t_test
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

module t_test;

    reg B;
    wire A;
    
    
    
    test test1(A, B);
    
    initial 
    begin
    #0 B <= 1'b0;
    #10 B <= ~B;
    #10 B <= ~B;
    #10 B <= ~B;
    #10 B <= ~B;
    #10 B <= ~B;
    #10 B <= ~B;
    #10 B <= ~B;
    #10 B <= ~B;
    #10 B <= ~B;
    #10 B <= ~B;
    #10 B <= ~B;
    #10 B <= ~B;
    #10 B <= ~B;
    #10 B <= ~B;
    end
    initial #150 $finish; 


endmodule
