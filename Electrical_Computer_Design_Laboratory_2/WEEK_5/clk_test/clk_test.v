`timescale 1ns / 1ps
// 보드 진단용: 클럭(B6)이 들어오는지 확인
module clk_test(clk, rst, btn, led);

input clk, rst, btn;
output [3:0] led;
reg [25:0] cnt;

always @(posedge clk) cnt <= cnt + 1;

assign led[0] = 1'b1;     // LED1: 항상 켜짐 (FPGA 구성/LED 확인)
assign led[1] = rst;      // LED2: DIP1 상태 그대로 (클럭 무관)
assign led[2] = btn;      // LED3: SM_1 버튼 상태 그대로 (클럭 무관)
assign led[3] = cnt[25];  // LED4: B6 클럭이 들어오면 깜빡임

endmodule
