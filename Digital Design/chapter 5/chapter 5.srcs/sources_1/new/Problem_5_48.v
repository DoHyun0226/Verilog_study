`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/12 18:02:48
// Design Name: 
// Module Name: module that implements FIG 5.48
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
    always @ (posedge clk, negedge rst) 
        if (!rst)
            Q = 1'b0; 
            // rst is clear, so the output Q is set to 0. 
            // At first, rst must be set to 0 and transitioned to 1 to initialize the flip-flop.
        else
            Q <= D; // On the rising edge of the clock signal, the output Q takes the value of the input D.
endmodule

module FIG_5_48(output y_out, A, B, input x_in, clk, rst);
    wire Da, Db;

    assign #1 // This delay is made for setup time
        Da = x_in ^ B || (x_in && !A), 
        Db = !(x_in || B) || (x_in && !A && B) || (A && !B);
        
    assign y_out = (!x_in &&((!A && !B) || (A && B))) || (x_in && (A ^ B));
    D_FF ffA (A, Da, clk, rst);
    D_FF ffB (B, Db, clk, rst);
endmodule
