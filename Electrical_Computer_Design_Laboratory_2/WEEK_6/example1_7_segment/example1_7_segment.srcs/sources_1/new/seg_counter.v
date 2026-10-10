`timescale 1ns / 1ps

// seg_counter: each btn press increases the 7-segment digit (0 -> 1 -> ... -> 9 -> 0)
module seg_counter(clk, rst, btn, seg);

input clk, rst;
input btn;             // count-up button
wire btn_trig;         // one-shot pulse of btn
reg [3:0] state;       // current count (0~9)
output reg [7:0] seg;  // {a, b, c, d, e, f, g, dp}, active-high

one_shot O1(clk, rst, btn, btn_trig); // 1 clock pulse per button press

always @(negedge rst or posedge clk) begin // 7_segment
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

always @(negedge rst or posedge clk) begin // 0~9 counter
    if(!rst) state <= 4'b0000;
    else if(state == 4'b1001 && btn_trig == 1) state <= 4'b0000; // if state = 9, state returns to 0
    else if(btn_trig == 1) state <= state + 4'b0001; // state = state + 1
end

endmodule
