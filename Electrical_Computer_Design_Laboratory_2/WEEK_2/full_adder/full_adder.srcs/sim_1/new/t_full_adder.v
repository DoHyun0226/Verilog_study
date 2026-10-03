`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/03 14:27:23
// Design Name: 
// Module Name: t_full_adder
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


module t_full_adder;
reg [2:0] x;
wire s, c_out;

full_adder fd(x[0], x[1], x[2], s, c_out);

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
initial #80 $finish;
endmodule
