`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/12 16:04:15
// Design Name: 
// Module Name: t_MUX_4bit_in_8_to_1
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


module t_MUX_4bit_in_8_to_1;
reg [3:0] in0, in1, in2, in3, in4, in5, in6, in7;
reg [2:0] sel;
wire [3:0] out;

MUX_4bit_in_8_to_1 MUX({in7, in6, in5, in4, in3, in2, in1, in0}, sel, out);

initial begin
    #0 in0 <= 4'h0; in1 <= 4'h1; in2 <= 4'h2; in3 <= 4'h3; 
       in4 <= 4'h4; in5 <= 4'h5; in6 <= 4'h6; in7 <= 4'h7; sel = 3'b000;
    #10 sel = 3'b001;
    #10 sel = 3'b010;
    #10 sel = 3'b011;
    #10 sel = 3'b100;
    #10 sel = 3'b101;
    #10 sel = 3'b110;
    #10 sel = 3'b111;
end
initial #80 $finish;

endmodule
