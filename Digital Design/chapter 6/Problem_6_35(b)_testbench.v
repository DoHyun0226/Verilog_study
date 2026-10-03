`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/08 21:55:09
// Design Name: testbenchParallel_Load_4_Bit_Register_with_Asynchronous_Reset
// Module Name: t_PL_4_bit_Reg_Async_Reset
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


module t_PL_4_bit_Reg_Async_Reset; //PL_4_bit_Reg_Async_Reset (output [3:0] A, input [3:0] I, input clk, rst, load)
    wire [3:0] A;
    reg  [3:0] I;
    reg clk, rst, load;
    PL_4_bit_Reg_Async_Reset UUT (A, I, clk, rst, load);

    always #5 clk = ~clk; // 10 ns period clock

    initial begin
        $display("time\tclk\trst\tload\tI\t\tA");
        $monitor("%0t\t%b\t%b\t%b\t%b\t%b", $time, clk, rst, load, I, A);

        #0 I = 4'b0100; clk = 0; rst = 0; load = 1'b1; 
        #3; // Check reset
        #2 rst = 1; // Deassert reset, load value
        #10; // Check loaded value
        #10 load = 0; I = 4'b1010; // Change input, but do not load
        #10; // Check that value holds
        #10 load = 1; // Load new value
        #10; // Check new loaded value
        #10 rst = 0; // Assert reset again
        #10; // Check reset
    end
    initial #100 $finish; // End simulation after 100 ns

endmodule
        