`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2026/10/11 00:44:01
// Design Name:
// Module Name: t_piezo_basic_1
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


// 피에조 피아노: 도 ~ 높은 도를 차례로 20 ms씩 누르고, 레/라의 주파수를 확인
// timescale 1us -> #1 = 1 us, #20000 = 20 ms
// 마지막 $finish가 약 160 ms이므로 기본 run time(1000 ns)보다 길다 -> "run all"로 실행
module t_piezo_basic_1;
    reg clk, rst;
    reg [7:0] btn;
    wire piezo;

    piezo_basic piezo_instance(clk, rst, btn, piezo);

    // 버튼 b를 20 ms 동안 누름 (가장 낮은 음 도도 5주기 이상 보임)
    task play;
        input [7:0] b;
        begin
            btn <= b;
            #20000;
        end
    endtask

    initial begin
        #0 clk <= 0; rst <= 0; btn <= 0;
        #1 rst <= 1;
        #9;
        // 주기 = parameter 값 x 1 us (1 MHz 클럭 1개 = 1 us)
        // 실제 주기는 반주기가 1클럭씩 길어서 parameter + 2 us (piezo_basic.v 참고)
        //                     음        parameter     주기 (실제)          주파수 (실제)
        play(8'b00000001);  // 도      (C2 = 3830)   3.830 ms (3832 us)  ~261 Hz (260.96 Hz)
        play(8'b00000010);  // 레      (D2 = 3400)   3.400 ms (3402 us)  ~294 Hz (293.94 Hz)  <- 확인
        play(8'b00000100);  // 미      (E2 = 3038)   3.038 ms (3040 us)  ~329 Hz (328.95 Hz)
        play(8'b00001000);  // 파      (F2 = 2864)   2.864 ms (2866 us)  ~349 Hz (348.92 Hz)
        play(8'b00010000);  // 솔      (G2 = 2550)   2.550 ms (2552 us)  ~392 Hz (391.85 Hz)
        play(8'b00100000);  // 라      (A2 = 2272)   2.272 ms (2274 us)  ~440 Hz (439.75 Hz)  <- 확인
        play(8'b01000000);  // 시      (B2 = 2028)   2.028 ms (2030 us)  ~493 Hz (492.61 Hz)
        play(8'b10000000);  // 높은 도 (C3 = 1912)   1.912 ms (1914 us)  ~523 Hz (522.47 Hz)
        btn <= 0;
        #1000 $finish;
    end

    initial #1 forever #0.5 clk <= !clk;    // 1 us 주기 = 1 MHz

    // 주파수 측정: piezo 상승 에지 사이 시간 = 한 주기 -> 주파수 = 1 / 주기
    // 음이 바뀐 직후의 첫 상승 에지까지는 이전 음과 섞여 있으므로, 2번째 상승 에지에서 측정
    //
    // realtime : 실수(real)형 변수. 시뮬레이션 시각을 소수점까지 저장할 때 쓴다
    //            $realtime(현재 시각, timescale 단위 = us)을 그대로 담을 수 있다
    //            합성되지 않음 -> 테스트벤치 전용
    // integer  : 32비트 부호 있는 정수형 변수 (reg signed [31:0]과 같음)
    //            횟수 세기, 반복문 변수 등에 쓴다
    realtime t_rise;    // 직전 상승 에지 시각 (us)
    integer n_rise;     // 현재 음에서 지난 상승 에지 수

    always @(btn) n_rise = 0; // 버튼이 바뀌면 카운트 초기화

    always @(posedge piezo) begin
        n_rise = n_rise + 1;
        if (n_rise == 2 && btn != 0)
            $display("t = %8.3f ms  btn = %b  period = %0.0f us  freq = %0.2f Hz",
                     $realtime / 1000, btn, $realtime - t_rise, 1e6 / ($realtime - t_rise));
        t_rise = $realtime;
    end
endmodule
