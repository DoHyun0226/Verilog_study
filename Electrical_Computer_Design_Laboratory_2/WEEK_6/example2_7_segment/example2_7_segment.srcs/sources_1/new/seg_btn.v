`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/07 11:39:41
// Design Name: 
// Module Name: seg_btn
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


// seg_btn: press btn[n] (n = 0~9) -> 7-segment shows digit n
module seg_btn(clk, rst, btn, seg);

input clk, rst;
input [9:0] btn;       // 10 buttons, btn[n] selects digit n
wire [9:0] btn_trig;   // one-shot pulses of btn
reg [3:0] state;       // digit to display (0~9)
output reg [7:0] seg;  // {a, b, c, d, e, f, g, dp}, active-high

// 10-bit one-shot trigger
one_shot_universal #(.WIDTH(10)) O1(clk, rst, btn[9:0], btn_trig[9:0]);

always @(negedge rst or posedge clk) begin // 7-segment decoder
    if(!rst) seg <= 8'b00000000; // blank
    else begin
        case (state)
            4'b0000 : seg <= 8'b11111100;
            4'b0001 : seg <= 8'b01100000;
            4'b0010 : seg <= 8'b11011010;
            4'b0011 : seg <= 8'b11110010;
            4'b0100 : seg <= 8'b01100110;
            4'b0101 : seg <= 8'b10110110;
            4'b0110 : seg <= 8'b10111110;
            4'b0111 : seg <= 8'b11100000;
            4'b1000 : seg <= 8'b11111110;
            4'b1001 : seg <= 8'b11110110;
            default : seg <= 8'b00000000; // blank
        endcase
    end
end

always @(posedge clk or negedge rst) begin // button -> state
    if(!rst) state <= 4'b0000;
    // priority: if several buttons are pushed simultaneously, the smallest index wins
    // no trigger -> state is held
    else if (btn_trig[0]) state <= 4'b0000;
    else if (btn_trig[1]) state <= 4'b0001;
    else if (btn_trig[2]) state <= 4'b0010;
    else if (btn_trig[3]) state <= 4'b0011;
    else if (btn_trig[4]) state <= 4'b0100;
    else if (btn_trig[5]) state <= 4'b0101;
    else if (btn_trig[6]) state <= 4'b0110;
    else if (btn_trig[7]) state <= 4'b0111;
    else if (btn_trig[8]) state <= 4'b1000;
    else if (btn_trig[9]) state <= 4'b1001;
end

endmodule
