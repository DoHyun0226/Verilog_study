`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/03 11:42:21
// Design Name: 
// Module Name: SM2_one_shot
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


module SM2_one_shot(rst, clk, SM_in, SM2_reg, SM2_trig);
input rst, clk;
input [2:0] SM_in;
output reg [2:0] SM2_reg, SM2_trig;
always @(negedge rst or posedge clk) begin
    if(!rst) begin
        SM2_reg <= 3'b000;
        SM2_trig <= 3'b000;
    end
    else begin
        SM2_reg <= SM_in;
        SM2_trig <= SM_in & ~SM2_reg; 
        // 0->1로 transition 되었을 때만 SM2_trig가 1로 transition
    end
end

endmodule
