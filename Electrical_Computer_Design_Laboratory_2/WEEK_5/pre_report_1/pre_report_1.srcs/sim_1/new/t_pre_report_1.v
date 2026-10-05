`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/03 14:38:26
// Design Name: 
// Module Name: t_pre_report_1
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

`timescale 1ns / 1ps

module t_pre_report_1;
reg clk, rst, in;
wire out;
wire [1:0] state;

pre_report_1 uut(clk, rst, in, out, state);

always #5 clk = ~clk; // 10ns 주기, 상승 에지: 5, 15, 25, ...

initial begin
    clk = 0; rst = 0; in = 0;
    #10 rst = 1;

    #0  in = 1;  // 4.1.1 State 00, input 1 → 01
    #10 in = 0;  // 4.1.2 State 01, input 0 → 00 (out = 1)
    #10 in = 1;  //       State 00, input 1 → 01
    #10 in = 1;  // 4.1.3 State 01, input 1 → 11
    #10 in = 1;  //       State 11, input 1 → 10
    #10 in = 0;  // 4.1.4 State 10, input 0 → 00 (out = 1)
    #10 in = 1;  //       State 00, input 1 → 01
    #10 in = 1;  //       State 01, input 1 → 11
    #10 in = 1;  //       State 11, input 1 → 10
    #10 in = 1;  // 4.1.5 State 10, input 1 → 10
    #10 in = 0;  //       State 10, input 0 → 00
    #10 in = 1;  //       State 00, input 1 → 01
    #10 in = 1;  //       State 01, input 1 → 11
    #10 in = 0;  // 4.1.6 State 11, input 0 → 00 (out = 1)
    #20 $finish;
end

endmodule