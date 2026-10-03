`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/08 21:55:09
// Design Name: Testbench for Four-bit Shift Register
// Module Name: t_FB_Shift_Reg
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

module t_FB_Shift_Reg;

    reg        SI;
    reg        clk;
    reg        rst;
    wire       SO;

    // Device under test
    FB_Shift_Reg UUT (.SO  (SO), .SI  (SI), .clk (clk), .rst (rst));

    // 10 ns period clock
    initial clk = 0;
    always #5 clk = ~clk;


    initial begin
        $display("time\tclk\trst\tSI\tSO");
        $monitor("%0t\t%b\t%b\t%b\t%b", $time, clk, rst, SI, SO);

        // Asynchronous reset asserted before any clock edge
        #0 rst = 0; SI  = 1'b1;
        #2 rst = 1; SI = 1'b1;
        // Shift in 0's
        #10 SI = 1'b0;
        #10;
        #10;
        #10;
        #10 SI = 1'b1;
        #10;
        
        #10 rst = 0;
    end
endmodule