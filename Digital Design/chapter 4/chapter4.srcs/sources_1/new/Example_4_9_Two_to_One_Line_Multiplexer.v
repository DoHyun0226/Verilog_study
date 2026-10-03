`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/06 20:14:55
// Design Name: Example_4_9_Two_to_One_Line_Multiplexer
// Module Name: mux_2x1_beh
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Behavioral description of two-to-one line multiplexer
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module mux_2x1_beh
(
    output m_out,
    input A, B, select,
    reg m_out
);
    always @(A, B, select) begin // Alternative: always @ (A or B or select)
        if (select == 1) // Alternative: if (select)
            m_out = A;
        else
            m_out = B;
    end
endmodule 

