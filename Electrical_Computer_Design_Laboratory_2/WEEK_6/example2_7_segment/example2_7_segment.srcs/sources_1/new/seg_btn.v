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
// [BUG] one_shot_universal declares btn as 1-bit, so only btn[0] is connected
//       -> btn[9:1] are ignored and only btn[0] (digit 0) works
//       (fix is in one_shot_universal.v: input [WIDTH-1:0] btn;)
one_shot_universal #(.WIDTH(10)) O1(clk, rst, btn[9:0], btn_trig[9:0]);

always @(negedge rst or posedge clk) begin // 7-segment decoder
    if(!rst) seg <= 8'b00000000; // blank
    else begin
        case (state)
            0 : seg <= 8'b11111100;
            1 : seg <= 8'b01100000;
            2 : seg <= 8'b11011010;
            3 : seg <= 8'b11110010;
            4 : seg <= 8'b01100110;
            5 : seg <= 8'b10110110;
            6 : seg <= 8'b10111110;
            7 : seg <= 8'b11100000;
            8 : seg <= 8'b11111110;
            9 : seg <= 8'b11110110;
            default : seg <= 8'b00000000; // blank
        endcase
    end
end

always @(posedge clk or negedge rst) begin // button -> state
    if(!rst) state <= 4'b0000;
    else begin
        // only one button pressed at a time is accepted
        // no trigger or several triggers at once -> no matching case, state is held
        case (btn_trig)
            10'b0000000001 : state <= 4'b0000;
            10'b0000000010 : state <= 4'b0001;
            10'b0000000100 : state <= 4'b0010;
            10'b0000001000 : state <= 4'b0011;
            10'b0000010000 : state <= 4'b0100;
            10'b0000100000 : state <= 4'b0101;
            10'b0001000000 : state <= 4'b0110;
            10'b0010000000 : state <= 4'b0111;
            10'b0100000000 : state <= 4'b1000;
            10'b1000000000 : state <= 4'b1001;
        endcase
    end
end

endmodule
