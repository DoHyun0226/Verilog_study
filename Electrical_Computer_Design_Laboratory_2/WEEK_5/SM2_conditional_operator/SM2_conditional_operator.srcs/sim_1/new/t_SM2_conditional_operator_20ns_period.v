`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2026/10/10 14:40:11
// Module Name: t_SM2_conditional_operator_20ns_period
// Description: 50MHz(주기 20ns) clock에서 S200 상태일 때 y가 1로 유지되는 시간 측정
//              입력은 clock의 negedge에서 변경 (posedge 기준 setup 여유 10ns)
//////////////////////////////////////////////////////////////////////////////////


module t_SM2_conditional_operator_20ns_period;
    reg clk, rst, A, B, C;
    wire [2:0] state;
    wire y;

    SM2_conditional_operator_modified SM2_instance(clk, rst, A, B, C, state, y);

    initial clk = 0;
    always #10 clk = ~clk; // 50MHz -> posedge: 10, 30, 50, ...

    initial begin
        rst = 0; {A, B, C} = 0;
        #5   rst = 1;
        #15  B = 1;         // t=20  : 100원 (state S100 @50ns)
        #20  B = 0;         // t=40
        #20  B = 1;         // t=60  : 100원 (state S200 @90ns)
        #20  B = 0;         // t=80
        #20  C = 1;         // t=100 : 구매 버튼 (state S0 @130ns)
        #80  C = 0;         // t=180 : y가 C 때문에 끝나지 않도록 충분히 유지
        #40  $finish;
    end


endmodule
