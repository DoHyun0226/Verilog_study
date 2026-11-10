`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2026/11/06 12:00:00
// Design Name:
// Module Name: DAC_display
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Week 10 (DAC) - preliminary report D + the DAC digital input
//              shown on the 7-segment array and the text LCD (top module)
//
// Dependencies: DAC.v, oneshot_universal.v, seg7_controller.v, bin2bcd.v, LCD_display.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   block diagram
//
//              +-----+  dac_d, dac_a_b, ... --> AD7302
//   btn ------>|     |  led_out             --> LED8 ~ LED1 (dac_d_temp)
//   add_sel -->| DAC |
//              +-----+
//                 | dac_d (value sent to the DAC), dac_a_b
//                 +--> seg7_controller --> seg_data, seg_sel   ("00000173")
//                 +--> LCD_display     --> LCD_E, LCD_RS, LCD_RW, LCD_DATA
//                                          "DEC:173  HEX:AD "
//                                          "BIN:10101101 [A]"
//
//   DAC is the week 10 example as it is. The displays show dac_d, the value on
//   the AD7302 D7~D0 pins, so they change at the next UP_DATA state after a
//   button press (up to 283 clocks later), while led_out changes at once.
//
//   Clock: ~1 kHz (lower the main clock on the board, same as WEEK_8 / WEEK_9).
//     LCD    : LCD_E = clk, one write per clock -> needs a slow clock
//     7-seg  : one digit per clock -> each digit refreshed at 125 Hz
//     DAC    : one write every 283 clocks = 283 ms
//////////////////////////////////////////////////////////////////////////////////


// clk       : system clock
// rst       : active-low reset
// btn       : [5] SM_1 -1, [4] SM_3 +1, [3] SM_4 -2, [2] SM_6 +2, [1] SM_7 -8, [0] SM_9 +8
// add_sel   : output select, 0 = VOUTA, 1 = VOUTB
// dac_*     : AD7302 pins (see DAC.v)
// led_out   : current DAC input value (dac_d_temp)
// seg_data  : 7-segment data {a, b, c, d, e, f, g, dp}, active-high
// seg_sel   : 7-segment digit select, active-low, seg_sel[0] = rightmost digit
// LCD_*     : 16 x 2 text LCD
module DAC_display(clk, rst, btn, add_sel,
                   dac_csn, dac_ldacn, dac_wrn, dac_a_b, dac_d, led_out,
                   seg_data, seg_sel,
                   LCD_E, LCD_RS, LCD_RW, LCD_DATA);

input clk, rst;
input [5:0] btn;
input add_sel;

output dac_csn, dac_ldacn, dac_wrn, dac_a_b;
output [7:0] dac_d;
output [7:0] led_out;

output [7:0] seg_data;
output [7:0] seg_sel;

output LCD_E, LCD_RS, LCD_RW;
output [7:0] LCD_DATA;

// DAC controller (week 10 example)
DAC D1(clk, rst, btn, add_sel, dac_csn, dac_ldacn, dac_wrn, dac_a_b, dac_d, led_out);

// 7-segment: dac_d in decimal (seg7_controller uses an active-high reset)
seg7_controller S1(clk, ~rst, dac_d, seg_data, seg_sel);

// text LCD: dac_d in decimal / hex / binary, and the selected output
LCD_display L1(rst, clk, dac_d, dac_a_b, LCD_E, LCD_RS, LCD_RW, LCD_DATA);

endmodule
