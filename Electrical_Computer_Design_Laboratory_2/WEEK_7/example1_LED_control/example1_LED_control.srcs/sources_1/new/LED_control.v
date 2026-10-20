`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2026/10/17 16:00:00
// Design Name:
// Module Name: LED_control
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


// LED_control : brightness control of a single LED using PWM (top module)
//
//   block diagram
//
//              +-----------+  cnt   +------------+
//   clk, rst ->| counter8  |------->|            |
//              +-----------+        | comparator |--> led_signal (PWM)
//   bin -------+------------------->|            |
//              |                    +------------+
//              |  +-----------------+
//              +->| seg7_controller |--> seg_data, seg_sel (bin in decimal)
//                 +-----------------+
//
//   bin (reference signal) : set with 8 DIP switches, 0 ~ 255
//   cnt (counter signal)   : 0 -> 1 -> ... -> 255 -> 0 ..., one step per clock
//
//   led_signal = 1 while cnt <= bin, so in every 256 clocks the LED is on for
//   (bin + 1) clocks
//     -> duty = (bin + 1) / 256
//        bin = 0   ->   1/256 (about 0.4 %, the LED never turns fully off)
//        bin = 63  ->  64/256 = 25 %
//        bin = 127 -> 128/256 = 50 %
//        bin = 191 -> 192/256 = 75 %
//        bin = 255 -> 256/256 = 100 %
//
//   rst is active-high (rst = 1 -> reset), mapped to a button switch
module LED_control(clk, rst, bin, seg_data, seg_sel, led_signal);

input clk, rst;
input [7:0] bin; // reference signal from the 8 DIP switches

wire [7:0] cnt; // counter signal from counter8

output [7:0] seg_data; // 7 segment data {a, b, c, d, e, f, g, dp}, active-high
output [7:0] seg_sel; // 7 segment selection line, active-low
output reg led_signal; // PWM signal to the LED (1 = on)

counter8 c1(clk, rst, cnt); // 8 bit up counter: makes the PWM period (256 clocks)
seg7_controller s1(clk, rst, bin, seg_data, seg_sel); // shows bin (0 ~ 255) on the 7-segment array

// comparator: PWM signal is ON while counter signal <= reference signal (bin)
//   led_signal is a register, so it changes 1 clock after cnt
//   (the duty does not change, the whole waveform is just shifted by 1 clock)
//   "else if(cnt > bin)" works the same as a plain "else" here
always @(posedge clk or posedge rst) begin
    if(rst) led_signal <= 0;
    else begin
        if(cnt <= bin) led_signal <= 1;
        else if(cnt > bin) led_signal <= 0;
    end
end

endmodule
