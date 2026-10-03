`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/08 21:55:09
// Design Name: Four-bit register with parallel load and asynchronous reset
// Module Name: FB_Reg_Parallel
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



module D_FF (Q, D, clk, rst);
    output reg Q;
    input D, clk, rst;
    always @ (posedge clk, negedge rst) // The always block is triggered on the rising edge of the clock signal (posedge clk) or when the reset signal goes low (negedge rst).
        if (!rst) // If the reset signal is low (active low), the output Q is set to 0.
            Q <= 0;
        else
            Q <= D; // On the rising edge of the clock signal, the output Q takes the value of the input D.
endmodule

module FB_Reg_Parallel (output [3:0] A, input [3:0] I, input clk, rst);
    D_FF FF0 (A[0], I[0], clk, rst);
    D_FF FF1 (A[1], I[1], clk, rst);
    D_FF FF2 (A[2], I[2], clk, rst);
    D_FF FF3 (A[3], I[3], clk, rst);
endmodule
