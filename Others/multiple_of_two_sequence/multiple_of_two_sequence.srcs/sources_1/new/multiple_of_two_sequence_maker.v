`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/12 18:02:48
// Design Name: 
// Module Name: multiple_of_two_sequence_maker
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// This is a module that make a sequence 0,2,4,....14,0,2,4....
// It is must be initialized by using clear reset 'rst' 
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module multiple_of_two_sequence_maker(output reg [3:0] sequence, input Run, clk, rst);
    parameter plus = 4'b0010;
    always @ (posedge clk) 
    begin
    if (Run && (sequence == 4'b1110))
        sequence <= 4'b0000;
    else if (Run)
        sequence <= sequence + plus;
    end
    always @ (negedge rst)//rst is clear
        sequence <= 4'b0000;
endmodule
