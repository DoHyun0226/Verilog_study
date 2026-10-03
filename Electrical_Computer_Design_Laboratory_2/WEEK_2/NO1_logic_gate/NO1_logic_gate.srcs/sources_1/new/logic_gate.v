`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/03 09:05:44
// Design Name: 
// Module Name: logic_gate
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


module logic_gate(a, b, x, y, z);
input a, b; // a: DIP SWITCH 1
output x, y, z; // b: DIP SWITCH 2

// and gate
assign x = a & b; //LED1, L4
// or gate
assign y = a | b; //LED2, M4
// xor gate
assign z = a ^ b; //LED3, M2

// a, b는 DIP 스위치 1, 2번에 맵핑
// DIP 스위치 1번, 2번은 각각 Y1, W3
// x, y, z는 LED 1, 2, 3에 맵핑
// LED L4, M4, M2
endmodule
