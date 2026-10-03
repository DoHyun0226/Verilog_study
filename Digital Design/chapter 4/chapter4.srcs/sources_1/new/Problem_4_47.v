`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/08 19:43:00
// Design Name: Boolean function with four variables implemented with a 4-to-1 multiplexer
// Module Name: Problem_4_47
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



module Problem_4_47(F, In_ABCD);
    output F;
    input [3:0] In_ABCD;
    wire L1, L2, L3, I0, I1, I2, I3, Mux_out;
    Mux_4_to_1 M1(Mux_out, {I3, I2, I1, I0}, In_ABCD[1:0]);
    assign
        L1 = !In_ABCD[2],
        L2 = !In_ABCD[3],
        L3 = L1 && In_ABCD[3],
        I0 = I2 || L3,
        I1 = L1 && L2,
        I2 = In_ABCD[2] && In_ABCD[3],
        I3 = 1,
        F = Mux_out;
endmodule

module Mux_4_to_1(m_out, m_in, Sel);
    output reg m_out;
    input [3:0] m_in;
    input [1:0] Sel;
    always @(m_in or Sel) begin
        case(Sel)
            2'b00: m_out <= m_in[0];
            2'b01: m_out <= m_in[1];
            2'b10: m_out <= m_in[2];
            2'b11: m_out <= m_in[3];
        endcase
    end
endmodule