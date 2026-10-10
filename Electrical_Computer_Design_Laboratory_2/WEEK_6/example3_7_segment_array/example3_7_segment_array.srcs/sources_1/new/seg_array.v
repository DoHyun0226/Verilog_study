`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/10 19:43:43
// Design Name: 
// Module Name: seg_array
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


module seg_array(clk, rst, btn, seg_data, seg_sel);

input clk, rst;
input btn;
wire btn_trig;
reg [3:0] state_bin; // binary state
wire [7:0] state_bcd; // bcd state corresponding to binary state
output reg [7:0] seg_data; // 7 segment date
output reg [7:0] seg_sel; // 7 segment selection line
reg [3:0] bcd; // one bcd digit (0~9) to display on the currently selected 7-segment

one_shot_universal #(.WIDTH(1)) O1(clk, rst, btn, btn_trig);
bin2bcd B1(clk, rst, state_bin[3:0], state_bcd[7:0]);

always @(posedge clk or negedge rst) begin
    if(!rst) state_bin <= 4'b0000;
    else if(state_bin == 4'b1111 && btn_trig == 1) state_bin <= 4'b0000;
    else if(btn_trig == 1) state_bin <= state_bin + 1;
end

always @(posedge clk or negedge rst) begin
    if(!rst) seg_sel <= 8'b11111110; // The 7-segment is active when the corresponding seg_sel = 0
    else begin
        seg_sel <= {seg_sel[6:0], seg_sel[7]};
    end
end

// Why the two blocks below must be combinational (always @(*)):
//   seg_sel -> bcd -> seg_data follow seg_sel within the same clock (only gate delay),
//   so the digit being enabled and the pattern on seg_data always match.
//   If they were clocked (posedge clk), seg_data would lag seg_sel by 1~2 clocks
//   and each 7-segment would show the digit meant for the previous position.
always @(*) begin  // Combinational Circuit: digit select
    // picks the bcd digit to show on the 7-segment currently enabled by seg_sel
    //   seg_sel[0] = 0 -> ones digit (state_bcd[3:0]), seg_sel[1] = 0 -> tens digit (state_bcd[7:4])
    //   other 6 digits -> 0
    case(seg_sel)
        8'b11111110 : bcd = state_bcd[3:0];
        8'b11111101 : bcd = state_bcd[7:4];
        8'b11111011 : bcd = 4'b0000;
        8'b11110111 : bcd = 4'b0000;
        8'b11101111 : bcd = 4'b0000;
        8'b11011111 : bcd = 4'b0000;
        8'b10111111 : bcd = 4'b0000;
        8'b01111111 : bcd = 4'b0000;
        default : bcd = 4'b0000;
    endcase
end

always @(*) begin // Combinational Circuit: 7-segment decoder
    // converts bcd (0~9) to the segment pattern seg_data = {a, b, c, d, e, f, g, dp}, active-high
    // bcd out of 0~9 -> default: all segments off
    case (bcd)
        4'b0000 : seg_data = 8'b11111100;
        4'b0001 : seg_data = 8'b01100000;
        4'b0010 : seg_data = 8'b11011010;
        4'b0011 : seg_data = 8'b11110010;
        4'b0100 : seg_data = 8'b01100110;
        4'b0101 : seg_data = 8'b10110110;
        4'b0110 : seg_data = 8'b10111110;
        4'b0111 : seg_data = 8'b11100000;
        4'b1000 : seg_data = 8'b11111110;
        4'b1001 : seg_data = 8'b11110110;
        default : seg_data = 8'b00000000;
    endcase
end

endmodule
