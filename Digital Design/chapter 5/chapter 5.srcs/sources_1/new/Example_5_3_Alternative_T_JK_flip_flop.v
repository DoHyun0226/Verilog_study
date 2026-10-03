`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/04 21:55:09
// Design Name: T flip-flop, JK flip-flop
// Module Name: TFF, JKFF
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


module TFF (output Q, input T, Clk, rst);
    wire DT;
    assign DT = T ^ Q; // XOR operation: When T is 0, DT is equal to Q (hold state). When T is 1, DT is the complement of Q (toggle state).
    // instantiate D flip-flop
    DFF TF1 (Q, DT, Clk, rst); // T flip-flop can be implemented using a D flip-flop by connecting the T input to the D input through an XOR gate with the current output Q.
endmodule
// T flip-flop is a type of flip-flop that toggles its output on each clock cycle when the T input is high (1). When T is low (0), the output remains unchanged. 
// The T flip-flop can be implemented using a D flip-flop by connecting the T input to the D input through an XOR gate with the current output Q.

module JKFF (output Q, input J, K, Clk, rst);
    wire JK;
    assign JK = (J & ~Q) | (~K & Q); 
    // When J is 1 and K is 0, JK is 1 (set state). When J is 0 and K is 1, JK is 0 (reset state). When J and K are both 0, JK is equal to Q (hold state). When J and K are both 1, JK is the complement of Q (toggle state).

    // instantiate D flip-flop
    DFF M0 (Q, JK, Clk, rst); // JK flip-flop can be implemented using a D flip-flop by connecting the J and K inputs to the D input through a combinational logic that determines the next state based on the current state and the J and K inputs.
endmodule