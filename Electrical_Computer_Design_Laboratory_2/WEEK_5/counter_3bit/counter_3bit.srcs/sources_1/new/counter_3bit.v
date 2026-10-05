`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/04 11:58:19
// Design Name: 
// Module Name: counter_3bit
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


module counter_3bit(clk, rst, x, state);

input clk, rst, x;
output reg [2:0] state;

always @(negedge rst or posedge clk) begin
    if(!rst) state <= 3'b000;
    else begin
        case(state)
            3'b000 : state <= x ? 3'b001 : 3'b111;
            3'b001 : state <= x ? 3'b010 : 3'b000;
            3'b010 : state <= x ? 3'b011 : 3'b001;
            3'b011 : state <= x ? 3'b100 : 3'b010;
            3'b100 : state <= x ? 3'b101 : 3'b011;
            3'b101 : state <= x ? 3'b110 : 3'b100;
            3'b110 : state <= x ? 3'b111 : 3'b101;
            3'b111 : state <= x ? 3'b000 : 3'b110;
        endcase
    end
end

endmodule
