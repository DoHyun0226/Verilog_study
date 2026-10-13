`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/10/11 00:08:43
// Design Name: 
// Module Name: t_seg_array
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


// 버튼 -> btn_trig -> state_bin -> state_bcd 까지 3클럭 지연
// press 1번 = 8클럭(80ns) -> 값마다 seg_sel 8자리 스캔이 한 바퀴씩 보임
// 마지막 $finish가 1.6us 쯤이므로 기본 run time(1000ns)보다 길다 -> "run all"로 실행
module t_seg_array;
    reg clk, rst, btn;
    wire [7:0] seg_data, seg_sel;

    seg_array seg_array_instance(clk, rst, btn, seg_data, seg_sel);

    // 버튼을 10ns 누르고 70ns 뗌
    task press;
        begin
            btn <= 1;
            #10 btn <= 0;
            #70;
        end
    endtask

    initial begin
        #0 clk <= 0; rst <= 0; btn <= 0;    // 리셋 중 seg_sel = 11111110, 00000000 표시
        #1 rst <= 1;
        #4;
        press; press; press; press; press;  // 0 -> 1 -> 2 -> 3 -> 4 -> 5
        press; press; press; press;         // 5 -> 6 -> 7 -> 8 -> 9
        press;                              // 9 -> 10, 십의 자리(seg_sel[1])에 1 표시
        press; press; press; press; press;  // 10 -> 11 -> 12 -> 13 -> 14 -> 15
        press;                              // 15 -> 0 (wrap-around)
        btn <= 1; #80 btn <= 0;             // 0 -> 1, btn을 80ns 동안 유지해도 한 번만 증가
        #80 rst <= 0;                       // 비동기 리셋 -> 0, seg_sel = 11111110
        #10 rst <= 1;
        press;                              // 0 -> 1
        #80 $finish;
    end

    initial #1 forever #5 clk <= !clk;
endmodule
