`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/08 19:33:00
// Design Name: four-input priority encoder
// Module Name: Problem_4_45
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



module Problem_4_45(x, y, V, D);
    output reg x, y, V; 
    input [3:0] D;

    always @(D) begin
        if (D[3] == 1) begin
            x <= 1;
            y <= 1;
            V <= 1;
        end else if (D[2] == 1) begin
            x <= 1;
            y <= 0;
            V <= 1;
        end else if (D[1] == 1) begin
            x <= 0;
            y <= 1;
            V <= 1;
        end else if (D[0] == 1) begin
            x <= 0;
            y <= 0;
            V <= 1;
        end else begin
            x <= 0;
            y <= 0;
            V <= 0; // No input is active
        end
    end

endmodule
