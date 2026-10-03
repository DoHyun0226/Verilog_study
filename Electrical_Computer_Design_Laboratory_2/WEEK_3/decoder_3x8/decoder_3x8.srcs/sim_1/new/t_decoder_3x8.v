`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/12 14:47:47
// Design Name: 
// Module Name: t_decoder_3x8
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


module t_decoder_3x8;
reg [2:0] in;
wire [7:0] out;

decoder_3x8 D_3x8(in, out);

initial begin
#0 in = 3'b0;
#10 in = 3'b001;
#10 in = 3'b010;
#10 in = 3'b011;
#10 in = 3'b100;
#10 in = 3'b101;
#10 in = 3'b110;
#10 in = 3'b111;
end

initial #80 $finish;
endmodule
