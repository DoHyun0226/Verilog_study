`timescale 1ns / 1ps

// t_LCD_cursur : testbench for result report B (DIP switch 2 changes the line)
//   clock 1 kHz -> 1 clock = 1 ms, rst is active low
//
//   inputs (each 200 ms apart, after initialization):
//     button 1 -> dip 1 (LINE2) -> button 2 -> * (left) -> dip 0 (LINE1)
//
//   expected LCD outputs:
//     button 1 : RS = 1, 0011_0001    written at 0x00, column 0 -> 1
//     dip 1    : RS = 0, 1100_0001    address 0x41 (LINE2, same column)
//     button 2 : RS = 1, 0011_0010    written at 0x41, column 1 -> 2
//     *        : RS = 0, 0001_0000    column 2 -> 1
//     dip 0    : RS = 0, 1000_0001    address 0x01 (LINE1, same column)
//
//   In the waveform, add U1/state, U1/cnt, U1/col, dip, LED_out, LCD_RS, LCD_RW, LCD_DATA.
//   Every state change and every non-idle LCD output is also printed in the
//   Tcl console. The simulation stops at 1.4 s.
module t_LCD_cursur;

reg rst, clk;
reg [9:0] number_btn;
reg [1:0] control_btn;
reg dip;
wire LCD_E, LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
wire [7:0] LED_out;

LCD_cursur U1(rst, clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out, number_btn, control_btn, dip);

// 1 kHz clock: period 1 ms, toggle every 0.5 ms
initial begin
    clk = 0;
    forever #500000 clk = ~clk;
end

initial begin
    rst = 0;                                // reset (active low) for 1.8 ms
    number_btn = 10'b0000_0000_00;
    control_btn = 2'b00;
    dip = 0;
    #1800000 rst = 1;

    #398200000 number_btn = 10'b1000_0000_00;     // 400 ms: button 1
    #100000000 number_btn = 10'b0000_0000_00;
    #100000000 dip = 1;                           // 600 ms: LINE2
    #200000000 number_btn = 10'b0100_0000_00;     // 800 ms: button 2
    #100000000 number_btn = 10'b0000_0000_00;
    #100000000 control_btn = 2'b10;               // 1000 ms: * (left)
    #100000000 control_btn = 2'b00;
    #100000000 dip = 0;                           // 1200 ms: LINE1
    #200000000 $finish;                           // stop at 1.4 s
end

// print every state change
always @(U1.state)
    $display("[%7.1f ms] state = %b", $realtime / 1e6, U1.state);

// print LCD outputs other than the idle instruction 0000_1111
always @(negedge LCD_E)
    if(rst && U1.state >= U1.DELAY_T && LCD_DATA != 8'b0000_1111)
        $display("[%7.1f ms] LCD RS = %b, RW = %b, DATA = %b, col = %0d", $realtime / 1e6, LCD_RS, LCD_RW, LCD_DATA, U1.col);

endmodule
