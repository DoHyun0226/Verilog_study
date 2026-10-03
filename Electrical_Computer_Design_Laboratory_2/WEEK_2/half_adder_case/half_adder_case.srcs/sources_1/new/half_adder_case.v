`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/03 14:15:56
// Design Name: 
// Module Name: half_adder_case
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


module half_adder_case(x, y, s, c);
input x, y;
output reg s, c;

always @(*) begin
case({x, y})
    2'b00: begin s <= 0; c <= 0; end
    2'b01: begin s <= 1; c <= 0; end
    2'b10: begin s <= 1; c <= 0; end
    2'b11: begin s <= 0; c <= 1; end
    default begin s <= 0; c <= 0; end
endcase
end
endmodule
