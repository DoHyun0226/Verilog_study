`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/10 19:04:54
// Design Name: 
// Module Name: seg_counter_modified
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


module seg_counter_modified(clk, rst, btn, seg);

input clk, rst;
input btn;             // count-up button
wire btn_trig, btn_reg;         // one-shot pulse of btn
reg [3:0] state;       // current count (0~9)
output reg [7:0] seg;  // {a, b, c, d, e, f, g, dp}, active-high

one_shot_modified O1(clk, rst, btn, btn_trig, btn_reg); // 1 clock pulse per button press

always @(negedge rst or posedge clk) begin // 7_segment
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

always @(negedge rst or posedge clk) begin // 0~9 counter
    if(!rst) state <= 4'b0000;
    else if(state == 4'b1001 && btn == 1 && btn_trig == 0) state <= 4'b0000; // if state = 9, state returns to 0
    else if(btn == 1 && btn_trig == 0) state <= state + 4'b0001; // state = state + 1
end

endmodule
