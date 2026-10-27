`timescale 1ns / 1ps

// t_text_LCD_basic : testbench for preliminary report A
//   clock 1 kHz -> 1 clock = 1 ms, rst is active low
//
//   expected state flow (clocks in each state):
//     DELAY(71) -> FUNCTION_SET(31) -> DISP_ONOFF(31) -> ENTRY_MODE(31)
//     -> LINE1(21) -> LINE2(21) -> DELAY_T(6) -> CLEAR_DISP(6) -> LINE1 ...
//
//   In the waveform, add U1/state, U1/cnt, LED_out, LCD_RS, LCD_RW, LCD_DATA.
//   Every state change is also printed in the Tcl console.
//   The simulation stops at 300 ms (initialization 164 ms + 2 loops of 54 ms).
module t_text_LCD_basic;

reg rst, clk;
wire LCD_E, LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
wire [7:0] LED_out;

text_LCD_basic U1(rst, clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out);

// 1 kHz clock: period 1 ms, toggle every 0.5 ms
initial begin
    clk = 0;
    forever #500000 clk = ~clk;
end

initial begin
    rst = 0;            // reset (active low) for 1.8 ms
    #1800000 rst = 1;   // 1.8ms
    #298200000 $finish; // stop at 300 ms
end

// print every state change
always @(U1.state)
    $display("[%6.1f ms] state = %b", $realtime / 1e6, U1.state);

endmodule
