`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/03 11:23:21
// Design Name: 
// Module Name: SM_1_conditional_operator
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


module SM_1_conditional_operator(clk, rst, x, y, state);
input clk, rst, x;
output reg [1:0] state;
output reg y;

always @(negedge rst or posedge clk) begin
    if(!rst) state <= 2'b00;
    else begin
        if      (state == 2'b00) {state,y} <= x ? 3'bxxx : 3'b000;
        else if (state == 2'b01) {state,y} <= x ? 3'b110 : 3'b001;
        else if (state == 2'b10) {state,y} <= x ? 3'b100 : 3'b001;
        else if (state == 2'b11) {state,y} <= x ? 3'b100 : 3'b001;
    end
end

endmodule
