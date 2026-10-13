`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Electrical_Computer_Design_Laboratory_2
// Engineer: DoHyun0226
//
// Create Date: 2026/10/10 23:24:21
// Design Name: bin2bcd_4bit
// Module Name: t_bin2bcd
// Project Name: bin2bcd_4bit
// Target Devices: xc7s75fgga484-1 (Spartan-7)
// Tool Versions: Vivado 2025.2.1
// Description: Testbench for bin2bcd_4bit.
//              Sweeps bin from 4'b0000 to 4'b1111 every 10 ns.
//
// Dependencies: bin2bcd_4bit.v
//
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Testbench scenario added
// Additional Comments:
//   timescale 1ns / 1ps -> #1 = 1 ns
//   combinational DUT -> no clock/reset, bcd changes immediately with bin
//   Last input change at t = 150 ns -> run at least 160 ns.
//
//////////////////////////////////////////////////////////////////////////////////


// t_bin2bcd: testbench for bin2bcd_4bit
// no $finish -> "run all" never ends
module t_bin2bcd();

reg [3:0] bin;
wire [7:0] bcd;

bin2bcd_4bit B1(bin, bcd);

initial begin
    bin = 4'b0000;                // t = 0 ns   : bcd = 0000_0000
    #10; bin = 4'b0001;
    #10; bin = 4'b0010;
    #10; bin = 4'b0011;
    #10; bin = 4'b0100;
    #10; bin = 4'b0101;
    #10; bin = 4'b0110;
    #10; bin = 4'b0111;
    #10; bin = 4'b1000;
    #10; bin = 4'b1001;           // t = 90 ns  : bcd = 0000_1001
    #10; bin = 4'b1010;           // t = 100 ns : bcd = 0001_0000
    #10; bin = 4'b1011;
    #10; bin = 4'b1100;
    #10; bin = 4'b1101;
    #10; bin = 4'b1110;
    #10; bin = 4'b1111;           // t = 150 ns : bcd = 0001_0101
    #10 $finish;
end

endmodule
