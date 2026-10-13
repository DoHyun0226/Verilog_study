`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/10 23:54:25
// Design Name: 
// Module Name: t_seg_counter
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


module t_seg_counter;
    reg clk, rst, btn;
    wire [7:0] seg;

    seg_counter seg_counter_instance(clk, rst, btn, seg);

    // 버튼을 10ns 누르고 10ns 뗌
    task press;
        begin
            btn <= 1;
            #10 btn <= 0;
            #10;
        end
    endtask

    initial begin
        #0 clk <= 0; rst <= 0; btn <= 0;    // 리셋 중 seg = 00000000 (blank)
        #1 rst <= 1;                        // 다음 상승 에지에서 seg = 0
        #4;
        press; press; press; press; press;  // 0 -> 1 -> 2 -> 3 -> 4 -> 5
        press; press; press; press;         // 5 -> 6 -> 7 -> 8 -> 9
        press;                              // 9 -> 0 (wrap-around)
        btn <= 1; #40 btn <= 0;             // 0 -> 1, btn을 40ns 동안 유지해도 한 번만 증가
        #10 rst <= 0;                       // 비동기 리셋 -> seg blank
        #10 rst <= 1;
        press;                              // 0 -> 1
        #30 $finish;
    end

    initial #1 forever #5 clk <= !clk;
endmodule
