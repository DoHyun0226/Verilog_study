`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/08 21:55:09
// Design Name: D flip-flop with multiplexer
// Module Name: D_FF_mux
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


module D_FF_mux (Q, D0, D1, D2, D3, S0, S1, clk);
    output reg Q;
    input D0, D1, D2, D3, S0, S1, clk;
    parameter
        S00 = 2'b00,
        S01 = 2'b01,
        S10 = 2'b10,
        S11 = 2'b11;    
    always @ (posedge clk)
    begin
        case ({S1, S0})
            S00: Q <= D0;
            S01: Q <= D1;
            S10: Q <= D2;
            S11: Q <= D3;
        endcase
    end
endmodule


