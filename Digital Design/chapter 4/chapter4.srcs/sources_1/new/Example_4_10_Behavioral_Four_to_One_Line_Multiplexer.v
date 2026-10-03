`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/06 20:14:55
// Design Name: Example_4_10_Behavioral_Four_to_One_Line_Multiplexer
// Module Name: mux_4x1_beh
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Behavioral description of four-to-one line multiplexer
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module mux_4x1_beh
(
    output reg m_out,
    input in_0, in_1, in_2, in_3,
    input [1:0] select
);
    always @(in_0, in_1, in_2, in_3, select) begin // Verilog 2001, 2005, SV syntax
        case (select)
            2'b00: m_out <= in_0;
            2'b01: m_out <= in_1;
            2'b10: m_out <= in_2;
            2'b11: m_out <= in_3;
            default: m_out <= 1'bx; // Optional: Handle invalid select values 
            // If you don't use 'default' and the case expression doesn't match any case, m_out will retain its previous value, which may not be desirable in all situations.
        endcase
    end
endmodule 

