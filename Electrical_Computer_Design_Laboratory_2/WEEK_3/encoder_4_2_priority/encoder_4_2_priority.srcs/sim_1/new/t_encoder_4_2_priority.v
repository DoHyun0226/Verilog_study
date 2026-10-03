`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/12 15:45:26
// Design Name: 
// Module Name: t_encoder_4_2_priority
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


module t_encoder_4_2_priority;
reg [3:0] in;
wire [1:0] out;
wire valid;

encoder_4_2_priority en_4_2_priority(in, out, valid);

initial begin
#0 in = 4'b0;
#10 in = 4'b1000;
#10 in = 4'b1011;
#10 in = 4'b0101;
#10 in = 4'b0001;
end

initial #50 $finish;

endmodule
