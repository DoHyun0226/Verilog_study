`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/03 11:41:03
// Design Name: 
// Module Name: SM2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Vending Machine Example
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SM2(clk, rst, A, B, C, state, y);

input clk, rst;
input A, B, C;
// A: 50원, B:100원, C: 자판기 음료 구매버튼 누르는 동작 
wire A_reg, B_reg, C_reg;
wire A_trig, B_trig, C_trig;
output reg [2:0] state;
output reg y;

parameter S0 = 3'b000;
parameter S50 = 3'b001;
parameter S100 = 3'b010;
parameter S150 = 3'b011;
parameter S200 = 3'b100;

SM2_one_shot one_shot_trigger(rst, clk, {A, B, C}, {A_reg, B_reg, C_reg}, {A_trig, B_trig, C_trig});
//(rst, clk, SM_in, SM2_reg, SM2_trig)

always @(negedge rst or posedge clk) begin
    if(!rst) state <= S0;
    else begin
        case(state)
            S0 : begin
                if(A_trig == 1) state <= S50;
                else if(B_trig == 1) state <= S100;
                else state <= S0; // C_trig = 1일 경우 상태 유지
            end
            S50 : begin
                if(A_trig == 1) state <= S100;
                else if(B_trig == 1) state <= S150;
                else state <= S50;
            end
            S100 : begin
                if(A_trig == 1) state <= S150;
                else if(B_trig == 1) state <= S200;
                else state <= S100;
            end
            S150 : begin
                if(A_trig == 1) state <= S200;
                else if(B_trig == 1) state <= S200;
                else state <= S150;
            end
            S200 : begin
                if(A_trig == 1) state <= S200;
                else if(B_trig == 1) state <= S200;
                else if(C_trig == 1) state <= S0;
                else state <= S200;
            end
        endcase
    end
end 
// A_trig, B_trig, C_trig 중 2개 이상의 trig가 1일 경우 A, B, C의 우선순위로 뒤의 것이 반영되지 못하는 문제가 발생
// 또한 초과되는 돈도 파악하지 못함


always @(negedge rst or posedge clk) begin
    if(!rst) y <= 0;
    else begin
        case(state)
            S200 : y <= C_trig ? 1 : 0;
            default : y <= 0;
        endcase
    end
end

endmodule