`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/08 21:55:09
// Design Name: Parallel_Load_4_Bit_Register_with_Asynchronous_Reset
// Module Name: PL_4_bit_Reg_Async_Reset
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


module PL_4_bit_Reg_Async_Reset (output reg [3:0] A, input [3:0] I, input clk, rst, load);

    always @ (posedge clk)
        if (!rst)
            A <= 4'b0000;
        else if (load)
            A <= I;
        else
            A <= A; // Hold the current value if load is not asserted
endmodule
        