`timescale 1ns / 1ps

// t_LCD_cursur : testbench for result report C (# at the last column wraps to column 0)
//   clock 1 kHz -> 1 clock = 1 ms, rst is active low
//
//   inputs (after initialization):
//     # 16 times on LINE1 -> dip 1 (LINE2) -> # 16 times on LINE2
//
//   expected LCD outputs:
//     # x 15   : RS = 0, 0001_0100    column 0 -> 15 (0x0F)
//     16th #   : RS = 0, 1000_0000    address 0x00, not 0x10
//     dip 1    : RS = 0, 1100_0000    address 0x40 (LINE2, column 0)
//     # x 15   : RS = 0, 0001_0100    column 0 -> 15 (0x4F)
//     16th #   : RS = 0, 1100_0000    address 0x40, not 0x50
//
//   In the waveform, add U1/state, U1/cnt, U1/col, dip, LED_out, LCD_RS, LCD_RW, LCD_DATA.
//   Every non-idle LCD output is also printed in the Tcl console.
module t_LCD_cursur;

reg rst, clk;
reg [9:0] number_btn;
reg [1:0] control_btn;
reg dip;
wire LCD_E, LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
wire [7:0] LED_out;

integer i;

LCD_cursur U1(rst, clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out, number_btn, control_btn, dip);

// 1 kHz clock: period 1 ms, toggle every 0.5 ms
initial begin
    clk = 0;
    forever #500000 clk = ~clk;
end

// press # for 40 ms, then wait 10 ms (longer than the 31 ms CURSOR state in total)
task press_right;
begin
    control_btn = 2'b01;
    #40000000 control_btn = 2'b00;
    #10000000;
end
endtask

initial begin
    rst = 0;                                // reset (active low) for 1.8 ms
    number_btn = 10'b0000_0000_00;
    control_btn = 2'b00;
    dip = 0;
    #1800000 rst = 1;

    #398200000;                             // 400 ms: LINE1
    for(i = 0; i < 16; i = i + 1) press_right;
    #50000000 dip = 1;                      // LINE2
    #50000000;
    for(i = 0; i < 16; i = i + 1) press_right;
    #50000000 $finish;
end

// print LCD outputs other than the idle instruction 0000_1111
always @(negedge LCD_E)
    if(rst && U1.state >= U1.DELAY_T && LCD_DATA != 8'b0000_1111)
        $display("[%7.1f ms] LCD RS = %b, RW = %b, DATA = %b, col = %0d", $realtime / 1e6, LCD_RS, LCD_RW, LCD_DATA, U1.col);

endmodule
