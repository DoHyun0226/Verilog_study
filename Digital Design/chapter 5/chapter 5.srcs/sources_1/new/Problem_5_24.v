`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/08 21:55:09
// Design Name: Behavioral description of positive-edge-sensitive D flip-flop with asynchronous preset and clear
// Module Name: D_DFF_async_preset_clear
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


module D_DFF_async_preset_clear (Q, D, clk, preset, clear);
    output reg Q;
    input D, clk, preset, clear;
    always @ (posedge clk, posedge preset, posedge clear) begin
        if (preset) Q <= 1; // When preset is 1, output Q is set to 1 regardless of the clock signal.
        else if (clear) Q <= 0; // When clear is 1, output Q is reset to 0 regardless of the clock signal.
        else Q <= D; // When both preset and clear are 0, output Q follows input D at the rising edge of the clock signal.
    end
endmodule

