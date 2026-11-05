`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2026/11/03 09:05:33
// Design Name:
// Module Name: oneshot_universal
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Week 9 (Text LCD cursor) - rising edge detector for WIDTH buttons
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   btn_trig[i] is high for exactly one clock after btn[i] goes 0 -> 1,
//   however long the button is held.
//
//////////////////////////////////////////////////////////////////////////////////


// clk      : system clock
// rst      : active-low reset
// btn      : button inputs
// btn_trig : one clock pulse on each rising edge of btn
module oneshot_universal(clk, rst, btn, btn_trig);

parameter WIDTH = 1;
input clk, rst;
input [WIDTH-1:0] btn;
reg [WIDTH-1:0] btn_reg;    // btn delayed by one clock
output reg [WIDTH-1:0] btn_trig;

always @(negedge rst or posedge clk) begin
    if(!rst) begin
        btn_reg <= {WIDTH{1'b0}};
        btn_trig <= {WIDTH{1'b0}};
    end
    else begin
        btn_reg <= btn;
        btn_trig <= btn & ~btn_reg;     // high now, low one clock ago
    end
end

endmodule
