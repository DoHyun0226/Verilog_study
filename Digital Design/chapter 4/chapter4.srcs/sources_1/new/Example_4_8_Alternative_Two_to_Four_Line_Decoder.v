`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/06 20:14:55
// Design Name: Example_4_8_Alternative_Two_to_Four_Line_Decoder
// Module Name: decoder_2x4_df_beh
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Behavioral description of two-to-four line decoder
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module decoder_2x4_df_beh
(
    output reg [0:3] D,
    input A, B, enable
);
    always @(A, B, enable) begin
        D[0] <= !((!A) && (!B) && (!enable)); 
        // This description uses non-blocking assignment (<=) to ensure that all outputs are updated simultaneously based on the current inputs.
        D[1] <= !((!A) && B && (!enable));
        D[2] <= (A && (!B) && (!enable));
        D[3] <= !(A && B && (!enable));
    end
endmodule 

