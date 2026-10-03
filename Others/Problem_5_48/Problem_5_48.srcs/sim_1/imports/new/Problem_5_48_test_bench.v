`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/12 18:02:48
// Design Name: 
// Module Name: test bench for FIG 5.48
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:  
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



// FIG_5_48(output y_out, input x_in, clk, rst);
module t_FIG_5_48;
    wire y_out, A, B;
    reg x_in, clk, rst;
    FIG_5_48 uut(.y_out(y_out), .A(A), .B(B), .x_in(x_in), .clk(clk), .rst(rst));
    always #5 clk <= ~clk;
    initial begin
        #0 clk <= 0; rst <= 1'b0; x_in <= 0;
        #2 rst <= 1'b1;
        #3 x_in <= 1'b1;
        #7 x_in <= 1'b0;
        #11 x_in <= 1'b1;
        #13 x_in <= 1'b0;
        #17 x_in <= 1'b1;
        #19 x_in <= 1'b0;
        #2 rst <= 1'b1;
        #3 x_in <= 1'b1;
        #7 x_in <= 1'b0;
        #11 x_in <= 1'b1;
        #13 x_in <= 1'b0;
        #17 x_in <= 1'b1;
        #19 x_in <= 1'b0;
    end
    initial #400 $finish;
endmodule