`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/08 21:55:09
// Design Name: Practice to writing a testbench
// Module Name: practice_tb1/practice_tb2
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

module practice_tb1;
    reg enable, A, B, C, D, E, F;

    initial begin
       #0 enable <= 0, A <= 1'b1, B <= 0, C <= 0, D <= 0, E <= 1'b1, F <= 1'b1;
       #10 A <= ~A, B <= ~B, C <= ~C;
       #10 A <= ~A, B <= ~B, D <= ~D, E <= ~E;
       #10 B <= ~B, E <= ~E, F <= ~F;
       #10 enable <= ~enable, B <= ~B, D <= ~D, F <= ~F;
       #10 B <= ~B;
       #10 B <= ~B, D <= ~D;
       #10 B <= ~B;
    end

    initial #80 $finish;
endmodule

module practice_tb2;
    reg enable, A, B, C, D, E, F;

    initial fork
        #0  enable <= 0,  A <= 1'b1, B <= 0,    C <= 0,    D <= 0,    E <= 1'b1, F <= 1'b1;
        #10 A <= ~A, B <= ~B, C <= ~C;
        #20 A <= ~A, B <= ~B, D <= ~D, E <= ~E;
        #30 B <= ~B, E <= ~E, F <= ~F;
        #40 enable <= ~enable, B <= ~B, D <= ~D, F <= ~F;
        #50 B <= ~B;
        #60 B <= ~B, D <= ~D;
        #70 B <= ~B;
    join

    initial #80 $finish;
endmodule


