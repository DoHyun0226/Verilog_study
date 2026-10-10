`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/10 19:02:49
// Design Name: 
// Module Name: one_shot_modified
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


module one_shot_modified(clk, rst, btn, btn_trig);

input clk, rst, btn; // one-shot trigger for btn
output reg btn_trig;  // one-shot output, btn value of the previous clock

always @(negedge rst or posedge clk) begin // asynchronous active-low reset
    if(!rst) begin // reset
        btn_trig <= 0;
    end
    else begin
        btn_trig <= btn;  // store current btn
    end
end
endmodule
