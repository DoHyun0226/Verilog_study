`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/12 13:57:24
// Design Name: 
// Module Name: decoder_6x64
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


module decoder_6x64(in, out);
input [5:0] in;
output [63:0] out;

genvar i; // genvar: generate에서 루프 인덱싱으로 사용할 변수 선언
generate
    for (i = 0; i < 64; i = i + 1) begin
    assign out[i] = (in == i);
    end
endgenerate
endmodule

//아래 모듈도 decoder_6x64와 implementation 결과는 동일함
//module decoder_6x64_always(in, out); 
//input [5:0] in;
//output reg [63:0] out;

//always @(*) begin
//    out = 64'b0;
//    out[in] = 1'b1;
//end
//endmodule

