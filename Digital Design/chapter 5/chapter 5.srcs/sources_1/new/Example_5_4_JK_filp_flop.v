`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/04 21:55:09
// Design Name: JK flip-flop
// Module Name: JK_FF
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

// Functional description of JK flip-flop using a case statement
module JK_FF (input J, K, Clk, output reg Q, output Q_b);
    assign Q_b = ~Q; // Q_b is the complement of Q
    always @ (posedge Clk) begin
        case ({J, K}) // Concatenate J and K to form a 2-bit value for the case statement
            2'b00: Q <= Q; // Hold state: When J=0 and K=0, the output Q remains unchanged.
            2'b01: Q <= 1'b0; // Reset state: When J=0 and K=1, the output Q is reset to 0.
            2'b10: Q <= 1'b1; // Set state: When J=1 and K=0, the output Q is set to 1.
            2'b11: Q <= ~Q; // Toggle state: When J=1 and K=1, the output Q toggles to its complement.
        endcase
    end
endmodule