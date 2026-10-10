`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/07 11:18:12
// Design Name: 
// Module Name: one_shot
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


// one_shot: 1-bit one-shot trigger
// btn_trig goes high for exactly one clock on the rising edge of btn
module one_shot(clk, rst, btn, btn_trig);

input clk, rst, btn; // one-shot trigger for btn
reg btn_reg;          // btn value of the previous clock
output reg btn_trig;  // one-shot output

always @(negedge rst or posedge clk) begin // asynchronous active-low reset
    if(!rst) begin // reset
        btn_reg <= 0;
        btn_trig <= 0;
    end
    else begin
        btn_reg <= btn;  // store current btn
        btn_trig <= btn & ~btn_reg;  // 1 only when btn: 0 -> 1 (rising edge)
    end
end
/*
btn: 0 -> 1 => btn_reg: 0 -> 1, btn_trig: 0 -> 1
btn: 1 -> 1 => btn_reg: 1 -> 1, btn_trig: 1 -> 0

----> one-shot trigger(two clocks are needed)
*/


endmodule
