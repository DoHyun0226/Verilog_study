`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/04 09:41:26
// Design Name: 
// Module Name: t_SM2_conditional_operator
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

module t_SM2_conditional_operator_modified;
    reg clk, rst, A, B, C;
    wire [2:0] state;
    wire y;

    // HOLD is reduced to 5 clocks for simulation (28'd250_000_000 on the board)
    SM2_conditional_operator_modified #(.HOLD(28'd5)) SM2_instance(
        .clk(clk), .rst(rst), .A(A), .B(B), .C(C), .state(state), .y(y));

    initial begin
        clk = 0; rst = 0; {A, B, C} = 3'b000;
        #15 rst = 1;
        // Reset -> A -> B -> A -> B -> C
        #20 A = 1;  #20 A = 0;      // S0   -> S50
        #20 B = 1;  #20 B = 0;      // S50  -> S150
        #20 A = 1;  #20 A = 0;      // S150 -> S200
        #20 B = 1;  #20 B = 0;      // S200 -> S200
        #20 C = 1;  #200 C = 0;     // S200 -> S0, y = 1 for HOLD clocks (C held for 10 clocks)
        // reset -> A -> B -> C
        #40 rst = 0; #20 rst = 1;
        #20 A = 1;  #20 A = 0;      // S0   -> S50
        #20 B = 1;  #20 B = 0;      // S50  -> S150
        #20 C = 1;  #20 C = 0;      // S150 -> S150, y = 0
        #200 $finish;
    end

    always #10 clk = ~clk; // 50 MHz (period 20 ns)
endmodule