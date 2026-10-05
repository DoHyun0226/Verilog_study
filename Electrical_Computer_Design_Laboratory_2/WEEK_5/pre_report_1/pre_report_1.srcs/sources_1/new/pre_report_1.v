`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/03 12:17:36
// Design Name: 
// Module Name: pre_report_1
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


module pre_report_1(clk, rst, in, out, state);
input clk, rst, in;
output out;
output reg [1:0] state;


always @(posedge clk, negedge rst)
begin
    if(!rst)
        state <= 2'b00;
    else begin
        case(state)
            2'b00: state <= in ? 2'b01 : 2'b00;
            2'b01: state <= in ? 2'b11 : 2'b00;
            2'b10: state <= in ? 2'b10 : 2'b00;
            2'b11: state <= in ? 2'b10 : 2'b00;
        endcase
    end
end

// Mealy 출력: 00이 아닌 상태에서 in = 0이면 1
assign out = (state != 2'b00) & ~in;

endmodule
