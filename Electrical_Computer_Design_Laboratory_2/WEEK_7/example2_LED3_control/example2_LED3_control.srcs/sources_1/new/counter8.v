`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2026/10/17 16:00:00
// Design Name:
// Module Name: counter8
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


// counter8 : 8 bit up counter (counter signal of the PWM)
//
//   cnt : 0 -> 1 -> 2 -> ... -> 255 -> 0 -> 1 -> ...  (+1 every clock)
//   8'b1111_1111 + 1 = 9'b1_0000_0000, but cnt is only 8 bits wide,
//   so the carry is dropped (overflow) and cnt goes back to 8'b0000_0000
//   automatically. No compare with 255 is needed.
//
//   one PWM period = 256 clocks
//     clock 50 MHz -> 256 x 20 ns = 5.12 us (PWM about 195 kHz)
//     clock 1 MHz  -> 256 x 1 us  = 256 us  (PWM about 3.9 kHz)
//     clock 10 Hz  -> 256 x 0.1 s = 25.6 s  (on/off can be seen by eye)
//
//   rst is active-high (rst = 1 -> cnt = 0)
module counter8(clk, rst, cnt);

input clk, rst;
output reg [7:0] cnt; // counter signal (0 ~ 255)

always @(posedge clk or posedge rst) begin
    if(rst) begin
        cnt <= 8'b0000_0000;
    end
    else cnt <= cnt + 1; // 255 + 1 overflows to 0
end

endmodule
