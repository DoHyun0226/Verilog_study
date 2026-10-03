`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/08 21:55:09
// Design Name: testbench for odd parity identifier
// Module Name: t_odd_parity_identifier
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


module t_odd_parity_identifier; //odd_parity_identifier (output reg P_odd, input serial_D_in, clk, rst);
    wire P_odd;
    reg serial_D_in, clk, rst;
    t_odd_parity_identifier OPI(P_odd, serial_D_in, clk, rst);

    initial begin
        // Initialize signals
        #0 clk = 0; rst = 0; serial_D_in = 0;
        #3 rst = 1; serial_D_in = 1; // Input bit 1
        #10 serial_D_in = 0; // Input bit 0
        #10 serial_D_in = 1; // Input bit 1
        #10 serial_D_in = 1; // Input bit 1
        #10 serial_D_in = 0; // Input bit 0
        #10 serial_D_in = 0; // Input bit 0
        #10 serial_D_in = 1; // Input bit 1 
    end
    initial forever #5 clk = ~clk; // Clock generation
    initial #100 $finish; // End simulation after 100 ns
endmodule
    
    