`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2026/10/17 16:00:00
// Design Name:
// Module Name: LED3_control
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


// LED3_control : color control of the 3-color (RGB) LEDs using PWM (top module)
//
//   Each of R, G, B gets its own PWM. The duty of each PWM sets the brightness
//   of that color, and the eye mixes the three lights into one color.
//     e.g. orange = {255, 102, 0} -> R about 100 %, G about 40 %, B 0 %
//
//   btn[7:0] --> state = {R, G, B} reference signals (8 bits each)
//                  |
//   counter8 --> cnt --> 3 comparators --> led_signal_R / _G / _B
//
//   comparator is (cnt < reference), so in every 256 clocks the LED is on for
//   (reference) clocks
//     -> duty = reference / 256
//        0   -> 0 %
//        102 -> 102/256 (about 40 %)
//        128 -> 128/256 = 50 %
//        255 -> 255/256 (about 99.6 %, off for 1 clock in every 256)
//
//   The board has 4 RGB LEDs, so each output is 4 bits (one bit per LED).
//   All 4 LEDs are driven the same here (4'b1111 or 4'b0000).
//
//   rst is active-high (rst = 1 -> reset, all LEDs off)
module LED3_control(clk, rst, btn, led_signal_R, led_signal_G, led_signal_B);

input clk, rst;
input [7:0] btn; // 8 button switches, one for each color (1 = pressed)

wire [7:0] cnt; // counter signal from counter8
reg [23:0] state; // reference signal {R, G, B}, 8 bits each

output reg [3:0] led_signal_R; // PWM signal to the red LEDs   (CLED_R1 ~ R4)
output reg [3:0] led_signal_G; // PWM signal to the green LEDs (CLED_G1 ~ G4)
output reg [3:0] led_signal_B; // PWM signal to the blue LEDs  (CLED_B1 ~ B4)

// RGB value of each color {R, G, B}, 0 = 0 %, 255 = 100 % brightness
parameter red    = {8'd255, 8'd0  , 8'd0  };
parameter orange = {8'd255, 8'd102, 8'd0  };
parameter yellow = {8'd255, 8'd255, 8'd0  };
parameter green  = {8'd0  , 8'd255, 8'd0  };
parameter blue   = {8'd0  , 8'd0  , 8'd255};
parameter indigo = {8'd0  , 8'd0  , 8'd128};
parameter purple = {8'd128, 8'd0  , 8'd128};
parameter white  = {8'd255, 8'd255, 8'd255};

counter8 c1(clk, rst, cnt); // 8 bit up counter: makes the PWM period (256 clocks)

// button -> color (reference signal), priority if-else
//   reset -> state = 0 -> duty 0 % for R, G, B (all LEDs off)
//   the lower button number has the higher priority:
//     btn[0] (red) > btn[1] (orange) > ... > btn[7] (white)
//     e.g. btn[1] and btn[4] pressed together -> orange
//   no button pressed -> no branch is taken, state keeps the last color
//   One-shot is not needed: holding a button just sets the same color every
//   clock, so the result is the same as pressing it once.
always @(posedge clk or posedge rst) begin
    if(rst) state <= 24'd0;
    else begin
        if(btn[0])      state <= red;
        else if(btn[1]) state <= orange;
        else if(btn[2]) state <= yellow;
        else if(btn[3]) state <= green;
        else if(btn[4]) state <= blue;
        else if(btn[5]) state <= indigo;
        else if(btn[6]) state <= purple;
        else if(btn[7]) state <= white;
    end
end

// 3 comparators: PWM for each of R, G, B
//   state[23:16] = R reference, state[15:8] = G reference, state[7:0] = B reference
//   e.g. state = {8'd255, 8'd0, 8'd0} -> R about 100 %, G 0 %, B 0 % -> red
//   The outputs are registers, so they change 1 clock after cnt.
always @(posedge clk or posedge rst) begin
    if(rst) begin
        led_signal_R <= 4'b0000;
        led_signal_G <= 4'b0000;
        led_signal_B <= 4'b0000;
    end
    else begin
        if(cnt < state[23:16]) led_signal_R <= 4'b1111;
        else led_signal_R <= 4'b0000;

        if(cnt < state[15:8]) led_signal_G <= 4'b1111;
        else led_signal_G <= 4'b0000;

        if(cnt < state[7:0]) led_signal_B <= 4'b1111;
        else led_signal_B <= 4'b0000;
    end
end

endmodule
