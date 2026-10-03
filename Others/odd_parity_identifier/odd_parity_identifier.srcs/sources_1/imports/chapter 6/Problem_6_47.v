`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/08 21:55:09
// Design Name: odd parity identifier
// Module Name: odd_parity_identifier
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


module odd_parity_identifier (output reg P_odd, input serial_D_in, clk, rst);
    always @ (posedge clk, negedge rst)
        if (!rst)
            P_odd <= 0; // Reset parity to even (0) on reset
        else
            P_odd <= P_odd ^ serial_D_in; // XOR the incoming bit with the current parity
endmodule
    
    