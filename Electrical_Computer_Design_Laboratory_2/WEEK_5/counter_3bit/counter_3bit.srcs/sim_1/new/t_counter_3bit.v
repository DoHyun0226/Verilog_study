`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/04 11:58:35
// Design Name: 
// Module Name: t_counter_3bit
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


module t_counter_3bit;
    reg clk, rst, x, btn;
    wire [2:0] state;

    counter_3bit counter_instance(clk, rst, x, btn, state);

    // 버튼을 10ns 누르고 10ns 뗌
    task press;
        begin
            btn <= 1;
            #10 btn <= 0;
            #10;
        end
    endtask

    initial begin
        #0 clk <= 0; rst <= 0; x <= 1; btn <= 0;
        #1 rst <= 1;
        #4;
        press; press; press;    // up : 0 -> 1 -> 2 -> 3
        btn <= 1; #40 btn <= 0; // up : 3 -> 4, btn을 40ns 동안 유지해도 한 번만 증가
        #10 x <= 0;
        press; press; press;    // down : 4 -> 3 -> 2 -> 1
        press; press;           // down : 1 -> 0 -> 7 (wrap-around)
        #10 x <= 1;
        press;                  // up : 7 -> 0 (wrap-around)
        #10 rst <= 0;           // 비동기 리셋 -> 0
        #10 rst <= 1;
        press;                  // up : 0 -> 1
        #20 $finish;
    end

    initial #1 forever #5 clk <= !clk;
endmodule
