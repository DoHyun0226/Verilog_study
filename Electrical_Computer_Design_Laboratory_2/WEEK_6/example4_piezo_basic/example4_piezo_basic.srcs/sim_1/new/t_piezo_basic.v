`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: Electrical_Computer_Design_Laboratory_2
// Engineer: DoHyun0226
//
// Create Date: 2026/10/10 20:40:01
// Design Name: piezo_basic
// Module Name: t_piezo_basic
// Project Name: example4_piezo_basic
// Target Devices: xc7s75fgga484-1 (Spartan-7)
// Tool Versions: Vivado 2025.2.1
// Description: Testbench for piezo_basic.
//              Generates a 1 MHz clock, applies reset, then presses btn[0] (C2)
//              and btn[1] (D2) to check the piezo square wave frequency.
//
// Dependencies: piezo_basic.v
//
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Testbench scenario and comments added
// Additional Comments:
//   timescale 1us / 1ns -> #1 = 1 us, #1e+6 = 1 s
//   Run at least 5 s (run 5 s) to see both tones.
//
//////////////////////////////////////////////////////////////////////////////////


// t_piezo_basic: testbench for piezo_basic
// timescale 1us -> #1 = 1 us, #1e+6 = 1 s
// last input change at t = 4 s -> run at least 5 s in the Tcl console (run 5 s) to see the D2 tone
// no $finish -> "run all" never ends
module t_piezo_basic();

reg clk, rst;
reg [7:0] btn;
wire piezo;

piezo_basic P1(clk, rst, btn, piezo);

initial begin
    clk <= 0;
    rst <= 1;
    btn <= 8'b00000000;
    #1e+6; rst <= 0;              // t = 1 s : reset
    #1e+6; rst <= 1;              // t = 2 s : release reset
    #1e+6; btn <= 8'b00000001;    // t = 3 s : btn[0] -> C2 (~261 Hz, period ~3.83 ms)
    #1e+6; btn <= 8'b00000010;    // t = 4 s : btn[1] -> D2 (~294 Hz, period ~3.40 ms)
end

always begin
    #0.5 clk <= ~clk;             // toggle every 0.5 us -> period 1 us = 1 MHz
end

endmodule
