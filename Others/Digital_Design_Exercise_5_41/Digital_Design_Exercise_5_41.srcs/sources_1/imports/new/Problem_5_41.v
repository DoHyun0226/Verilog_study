`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/08 21:55:09
// Design Name: 
// Module Name: 
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



module D_FF (Q, D, clk, rst);
    output reg Q;
    input D, clk, rst;
    always @ (posedge clk, posedge rst) 
        if (rst)
            Q <= 1'b0; 
            // rst is clear, so the output Q is set to 0. 
            // At first, rst must be set to 0 and transitioned to 1 to initialize the flip-flop.
        else
            Q <= D; // On the rising edge of the clock signal, the output Q takes the value of the input D.
endmodule

module pb_5_41 (output reg y, input x, clk, rst);
    wire A, B, C;
    wire Da, Db, Dc;

    assign 
        Da = x && !A && !B,
        Db = (!x && !C && !(A && B)) || (x && B && C),
        Dc = !(x || A) && (!B || C) || (x && A && !B && !C);

    D_FF ffA (A, Da, clk, rst);
    D_FF ffB (B, Db, clk, rst);
    D_FF ffC (C, Dc, clk, rst);

    always @ (A, B, C, x)
        case ({A, x})
            2'b01: y = 1'b1; // When A is 0 and x is 1, y is set to 1.
            default: y = 1'b0;
        endcase
endmodule

