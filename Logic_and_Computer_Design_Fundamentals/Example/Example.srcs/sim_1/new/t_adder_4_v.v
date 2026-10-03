`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/01 12:39:53
// Design Name: 
// Module Name: t_adder_4_v
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


/*
module adder_4_v(B, A, C0, S, C4);

input[3:0] A, B;
input C0;
output [3:0] S;
output C4;

wire [3:1] C;

full_adder_v 
Bit0(A[0], B[0], C0, S[0], C[1]),
Bit1(A[1], B[1], C[1], S[1], C[2]),
Bit2(A[2], B[2], C[2], S[2], C[3]),
Bit3(A[3], B[3], C[3], S[3], C4);

endmodule
*/

module t_adder_4_v;
reg [3:0] in1, in2;
reg init_carry;

wire [3:0] S;
wire C4;

adder_4_v f_add(in1, in2, init_carry, S, C4);
initial $monitor("%0t\t%d\t%b", $time, S, C4);
initial fork


#10 in1 <= 4'b0001; in2 <= 4'b0010; init_carry = 1'b1;
#20 in1 <= 4'b1101; in2 <= 4'b1100; init_carry = 1'b0;
#30 in1 <= 4'b0001; in2 <= 4'b0010; init_carry = 1'b0;
#40 in1 <= 4'b1101; in2 <= 4'b1100; init_carry = 1'b1;
join

initial #100 $finish;
endmodule
