`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/08 21:55:09
// Design Name: Ring counter
// Module Name: Ring_Counter
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


module ring_counter (output [3:0] T, input clk, rst);
    
    always @ (posedge clk, negedge rst)
        if (!rst)
            T <= 4'b0001; // Start with only the least significant bit set
        else
            T <= {T[2:0], T[3]}; // Rotate left by one position
endmodule
        