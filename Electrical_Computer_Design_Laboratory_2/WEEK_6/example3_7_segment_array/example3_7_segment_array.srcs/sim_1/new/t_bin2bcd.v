`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Electrical_Computer_Design_Laboratory_2
// Engineer: DoHyun0226
//
// Create Date: 2026/10/10
// Design Name: bin2bcd
// Module Name: t_bin2bcd
// Project Name: example3_7_segment_array
// Target Devices: xc7s75fgga484-1 (Spartan-7)
// Tool Versions: Vivado 2025.2.1
// Description: Testbench for bin2bcd.
//              Generates a 100 MHz clock, applies reset, then sweeps bin
//              from 4'b0000 to 4'b1111 to check the BCD output.
//
// Dependencies: bin2bcd.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   timescale 1ns / 1ps -> #1 = 1 ns
//   Last input change at t = 180 ns -> run at least 200 ns.
//
//////////////////////////////////////////////////////////////////////////////////


// t_bin2bcd: testbench for bin2bcd
// bcd is registered -> output updates on the clock edge after bin changes
// no $finish -> "run all" never ends
module t_bin2bcd();

reg clk, rst;
reg [3:0] bin;
wire [7:0] bcd;

bin2bcd B1(clk, rst, bin, bcd);

initial begin
    clk <= 0;
    rst <= 1;
    bin <= 4'b0000;
    #10; rst <= 0;                // t = 10 ns : reset
    #10; rst <= 1;                // t = 20 ns : release reset
    #10; bin <= 4'b0001;          // t = 30 ns  : bcd = 0000_0001
    #10; bin <= 4'b0010;
    #10; bin <= 4'b0011;
    #10; bin <= 4'b0100;
    #10; bin <= 4'b0101;
    #10; bin <= 4'b0110;
    #10; bin <= 4'b0111;
    #10; bin <= 4'b1000;
    #10; bin <= 4'b1001;          // t = 110 ns : bcd = 0000_1001
    #10; bin <= 4'b1010;          // t = 120 ns : bcd = 0001_0000
    #10; bin <= 4'b1011;
    #10; bin <= 4'b1100;
    #10; bin <= 4'b1101;
    #10; bin <= 4'b1110;
    #10; bin <= 4'b1111;          // t = 170 ns : bcd = 0001_0101
    #10; bin <= 4'b0000;          // t = 180 ns : back to 0000_0000
end

always begin
    #5 clk <= ~clk;               // toggle every 5 ns -> period 10 ns = 100 MHz
end

endmodule
