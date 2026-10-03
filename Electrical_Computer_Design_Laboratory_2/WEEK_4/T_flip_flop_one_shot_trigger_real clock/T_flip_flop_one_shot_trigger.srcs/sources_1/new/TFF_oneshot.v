`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/24 14:06:35
// Design Name: 
// Module Name: TFF_oneshot
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


module TFF_oneshot(clk, rst, T, Q);

input T, clk, rst;
reg T_reg, T_trig;
output reg Q;

always @(posedge clk, negedge rst)
begin
    if(!rst) begin
        Q <= 1'b0;
        T_reg <= 1'b0;
        T_trig <= 1'b0;
    end
    else begin
        T_reg <= T;
        T_trig <= T & ~T_reg;
        
       // T = 0, T_reg = 0
       // T = 1이 대입되면서 T_reg, T_trig에 1이 동시에 대입됨
       // 이 다음 클럭에서 T = 1이 유지될 경우 T_reg는 1인 상태이므로 T_trig = 0이 됨
       // 아래 위치한 if문으로 인해 T = 1이 유지되어도 T_trig는 T = 0에서 T = 1로 trigger되는 상황에서만 1이 되고 나머지는 0
    if(T_trig)
        Q <= ~Q;
    end
    
    
end
endmodule
