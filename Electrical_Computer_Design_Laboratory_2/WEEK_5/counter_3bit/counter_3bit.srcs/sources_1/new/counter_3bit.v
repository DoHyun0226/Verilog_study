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


module counter_3bit(clk, rst, x, btn, state);

input clk, rst;
input x;    // 방향: 1이면 up, 0이면 down
input btn;  // 카운트 버튼
reg btn_reg, btn_trig;
output reg [2:0] state;

// one-shot: btn이 0->1로 transition 되었을 때만 btn_trig가 1클럭 동안 1
always @(negedge rst or posedge clk) begin
    if(!rst) begin
        {btn_reg, btn_trig} <= 2'b00;
    end
    else begin
        btn_reg <= btn;
        btn_trig <= btn & ~btn_reg;
    end
end

always @(negedge rst or posedge clk) begin
    if(!rst) state <= 3'b000;
    else if(btn_trig) begin // else if block is implemented only if btn_trig = 1
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
