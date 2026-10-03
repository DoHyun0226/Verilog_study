`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/04 21:55:09
// Design Name: D-type Flip-Flop
// Module Name: D_FF
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


module D_FF (output reg Q, input D, clk);
    // D flip-flop without reset
    always @ (posedge clk)
        Q <= D;
endmodule

module DFF (output reg Q, input D, clk, rst);
    // D flip-flop with active-low, asynchronous reset
    always @ (posedge clk, negedge rst)
        if(!rst) Q <= 0; // When rst is 0, output Q is reset to 0 regardless of the clock signal.
        else Q <= D; // When rst is 1, output Q follows input D at the rising edge of the clock signal.   
endmodule

// Reset signal (rst) is used to initialize the state of the flip-flop.
// The reason for using an reset signal is to ensure the initial state of the D Latch used in the D flip-flop
