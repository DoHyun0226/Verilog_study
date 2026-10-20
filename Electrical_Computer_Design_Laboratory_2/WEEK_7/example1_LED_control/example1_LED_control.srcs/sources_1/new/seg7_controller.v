`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2026/10/17 16:00:00
// Design Name:
// Module Name: seg7_controller
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


// seg7_controller : shows bin (0 ~ 255) in decimal on the 7-segment array
//
//   bin --> bin2bcd --> bcd = {hundreds, tens, ones} (4 bits each)
//                         |
//   seg_sel (rotates) --> digit select --> display_bcd --> decoder --> seg_data
//
//   dynamic drive: the 8 digits share seg_data, and only the digit whose
//   seg_sel bit is 0 is turned on. seg_sel rotates every clock, so the digits
//   are turned on one at a time, fast enough that all of them look lit.
//     seg_sel[0] = 0 -> rightmost digit (S7) : ones
//     seg_sel[1] = 0 -> S6                   : tens
//     seg_sel[2] = 0 -> S5                   : hundreds
//     seg_sel[3] ~ [7]                       : 0
//   e.g. bin = 173 -> the 7-segment array shows "00000173"
//
//   Same as the WEEK_6 example3 code except that it now shows up to the
//   hundreds digit (bin is 8 bits, 0 ~ 255).
//
//   Note: seg_sel changes every clock.
//     at 50 MHz this may be too fast for the board (digits can look wrong),
//     at 10 Hz each digit is on for 0.1 s, so the scan can be seen moving.
module seg7_controller(clk, rst, bin, seg_data, seg_sel);

input clk, rst;
input [7:0] bin; // reference signal to display (0 ~ 255)

wire [11:0] bcd; // {hundreds, tens, ones} from bin2bcd, e.g. 173 -> {4'd1, 4'd7, 4'd3}
reg [3:0] display_bcd; // one bcd digit (0~9) to display on the currently selected 7-segment

output reg [7:0] seg_data; // 7 segment data {a, b, c, d, e, f, g, dp}, active-high
output reg [7:0] seg_sel; // 7 segment selection line, active-low

// binary -> BCD converter (excess-3, 8 clocks per conversion)
bin2bcd b1(clk, rst, bin, bcd);

// digit scan: the single 0 in seg_sel moves one place to the left every clock
//   11111110 -> 11111101 -> 11111011 -> ... -> 01111111 -> 11111110 ...
always @(posedge clk or posedge rst) begin
    if(rst) seg_sel <= 8'b11111110; // The 7-segment is active when the corresponding seg_sel = 0
    else begin
        seg_sel <= {seg_sel[6:0], seg_sel[7]}; // rotate left by 1
    end
end

// Combinational Circuit: 7-segment decoder
//   converts display_bcd (0~9) to seg_data = {a, b, c, d, e, f, g, dp}, active-high
//
//        a
//       ---
//    f |   | b
//       -g-
//    e |   | c
//       ---  . dp
//        d
//
//   e.g. 1 -> b, c on -> 8'b01100000
//   out of 0~9 -> all segments off
always @(*) begin
    case (display_bcd[3:0])
        0 : seg_data = 8'b11111100;
        1 : seg_data = 8'b01100000;
        2 : seg_data = 8'b11011010;
        3 : seg_data = 8'b11110010;
        4 : seg_data = 8'b01100110;
        5 : seg_data = 8'b10110110;
        6 : seg_data = 8'b10111110;
        7 : seg_data = 8'b11100000;
        8 : seg_data = 8'b11111110;
        9 : seg_data = 8'b11110110;
        default : seg_data = 8'b00000000;
    endcase
end

// Combinational Circuit: digit select
//   picks the bcd digit for the 7-segment currently enabled by seg_sel.
//   Both this block and the decoder are combinational (always @(*)), so
//   seg_data follows seg_sel in the same clock and the digit and the
//   pattern never mismatch.
always @(*) begin
    case(seg_sel)
        8'b11111110 : display_bcd = bcd[3:0];  // ones
        8'b11111101 : display_bcd = bcd[7:4];  // tens
        8'b11111011 : display_bcd = bcd[11:8]; // hundreds
        8'b11110111 : display_bcd = 4'b0000;   // unused digits show 0
        8'b11101111 : display_bcd = 4'b0000;
        8'b11011111 : display_bcd = 4'b0000;
        8'b10111111 : display_bcd = 4'b0000;
        8'b01111111 : display_bcd = 4'b0000;
        default : display_bcd = 4'b0000;
    endcase
end

endmodule
