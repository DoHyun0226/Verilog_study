`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/08 21:55:09
// Design Name: JK flip-flop with D flip-flop and two-to-one-line multiplexer
// Module Name: JK_FF_with_D_FF_and_2_to_1_MUX
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



module D_FF (Q, D, clk);
    output reg Q;
    input D, clk;
    always @ (posedge clk) 
        Q <= D; // On the rising edge of the clock signal, the output Q takes the value of the input D.
endmodule

module JK_FF_with_D_FF_and_2_to_1_MUX(J, K, clk, Q);
    input J, K, clk;
    output Q;
    wire D, w1, w2, w3;
    not (w1, Q);
    and (w2, J, w1); // w2 is the result of J AND NOT Q
    and (w3, ~K, Q); // w3 is the result of NOT K AND Q
    or (D, w2, w3); // D is the result of w2 OR w3
    D_FF dff1(Q, D, clk); // The D flip-flop takes D as input and produces Q as output on the rising edge of the clock signal.
endmodule

