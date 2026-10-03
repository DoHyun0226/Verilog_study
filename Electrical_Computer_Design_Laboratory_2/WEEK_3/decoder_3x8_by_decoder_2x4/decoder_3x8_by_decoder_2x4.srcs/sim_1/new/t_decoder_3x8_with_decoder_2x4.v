`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/12 13:49:50
// Design Name: 
// Module Name: t_decoder_3x8_with_decoder_2x4
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


module t_decoder_3x8_with_decoder_2x4;
reg [2:0] x;
wire [7:0] D;

decoder_3x8_with_decoder_2x4 De_3x8(x, D);

initial begin
#0 x = 3'b000;
#10 x = 3'b001;
#10 x = 3'b010;
#10 x = 3'b011;
#10 x = 3'b100;
#10 x = 3'b101;
#10 x = 3'b110;
#10 x = 3'b111;
end
initial #100 $finish;

endmodule
