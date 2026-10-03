`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/08 21:55:09
// Design Name: Four-bit Shift Register
// Module Name: FB_Shift_Reg
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
            #1 Q <= 0;
        else
            #1 Q <= D; // On the rising edge of the clock signal, the output Q takes the value of the input D.
endmodule

module FB_Shift_Reg (output SO, input SI, input clk, rst);
    wire [3:0] A;
    D_FF FF0 (A[0], SI, clk, rst);
    D_FF FF1 (A[1], A[0], clk, rst);
    D_FF FF2 (A[2], A[1], clk, rst);
    D_FF FF3 (A[3], A[2], clk, rst);
    assign SO = A[3];
endmodule