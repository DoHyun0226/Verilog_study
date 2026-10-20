`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2026/10/17 16:00:00
// Design Name:
// Module Name: bin2bcd
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


// bin2bcd : 8 bit binary -> 3 digit BCD converter using excess-3 (double dabble)
//
//   algorithm (8 bit input -> 12 bit BCD)
//     1. clear the BCD digits
//     2. repeat for every bit of bin, from MSB to LSB
//          - any BCD digit >= 5 -> add 3 to that digit
//          - shift {BCD, bin} left by 1 (the next bit of bin enters BCD bit 0)
//   Why +3: a digit >= 5 becomes >= 10 after the shift (x2).
//           Adding 3 first (+6 after the shift) makes the 4 bit digit skip
//           10 ~ 15 and carry into the next digit, which is the decimal carry.
//
//   example from the handout: 87 = 8'b0101_0111
//     step  tens  ones   remaining bin
//      1    0000  0000   1010111       (shift in 0)
//      2    0000  0001   010111        (shift in 1)
//      3    0000  0010   10111         (shift in 0)
//      4    0000  0101   0111          ones = 5 >= 5 -> +3 = 1000
//      5    0001  0000   111           (shift in 0)
//      6    0010  0001   11            (shift in 1)
//      7    0100  0011   1             (shift in 1)
//      8    1000  0111                 (shift in 1) -> 8, 7 = 87
//
//   timing: one step per clock (i = 0 ~ 7), so one conversion takes 8 clocks
//     i = 0     : bcd = {11'b0, bin[7]} (load the MSB)
//     i = 1 ~ 7 : +3 where needed and shift, bcd[0] = bin[7-i]
//     next i = 0: bcd holds the finished result -> copied to bcd_out
//   bcd_out is updated once every 8 clocks, so the display follows a change
//   of bin within 8 ~ 16 clocks. If bin changes during a conversion, that one
//   result may mix old and new bits, and the next conversion is correct again.
//
//   rst is active-high
module bin2bcd(clk, rst, bin, bcd_out);

input clk, rst;
input [7:0] bin; // 8 bits binary to 12 bits bcd
reg [11:0] bcd; // working register {hundreds, tens, ones} during the conversion
output reg [11:0] bcd_out; // last finished result {hundreds, tens, ones}

reg [2:0] i; // step counter 0 ~ 7, 7 + 1 overflows to 0

always @(posedge rst or posedge clk) begin
    if(rst) begin
        bcd <= {4'd0, 4'd0, 4'd0};
        i <= 0;
    end
    else begin
        if(i == 0) begin
            // start of a conversion: clear and load bin[7]
            bcd[11:1] <= 11'b0000_0000_000;
            bcd[0] <= bin[7];
        end
        else begin
            // "add 3 if >= 5" and "shift left by 1" in one clock:
            //   each adjusted digit is written 1 bit higher than where it was
            //   bcd[11:8] -> bcd[11:9] : hundreds (its MSB is never 1 for bin <= 255, so 3 bits are enough)
            //   bcd[7:4]  -> bcd[8:5]  : tens, its MSB moves into hundreds bit 0
            //   bcd[3:0]  -> bcd[4:1]  : ones, its MSB moves into tens bit 0
            //   bin[7-i]  -> bcd[0]    : next bit of bin
            bcd[11:9] <= (bcd[11:8] >= 3'd5) ? bcd[11:8] + 2'd3 : bcd[11:8];
            bcd[8:5]  <= (bcd[7:4] >= 3'd5) ? bcd[7:4] + 2'd3 : bcd[7:4];
            bcd[4:1]  <= (bcd[3:0] >= 3'd5) ? bcd[3:0] + 2'd3 : bcd[3:0];
            bcd[0] <= bin[7-i];
        end
        i <= i + 1;
    end
end

// output register: at i == 0, bcd still holds the result of the conversion
// that just finished (nonblocking: the clear above happens at the same edge),
// so it is copied to bcd_out here. bcd_out keeps that value for the next 8 clocks.
always @(posedge rst or posedge clk) begin
    if(rst) bcd_out <= {4'd0, 4'd0, 4'd0};
    else if(i == 0) bcd_out <= bcd;
end

endmodule
