`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/24 16:24:23
// Design Name: 
// Module Name: t_JKFF
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


module t_JKFF;
    reg Clk;
    reg [1:0] JK;
    wire Q, Q_b;
    JKFF JKFF1(JK[1], JK[0], Clk, Q, Q_b);
    
    initial begin 
        #0 Clk <= 0; JK <= 2'b00;
        #10 JK <= 2'b01;
        #10 JK <= 2'b00;
        #10 JK <= 2'b10;
        #10 JK <= 2'b00;
        #10 JK <= 2'b11;
        #10 JK <= 2'b00;
    end
    
    initial forever #3 Clk <= ~Clk;
    
    initial #80 $finish;   
endmodule
