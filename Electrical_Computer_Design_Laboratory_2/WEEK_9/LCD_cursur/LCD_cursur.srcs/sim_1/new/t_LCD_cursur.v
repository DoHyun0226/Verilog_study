`timescale 1ns / 1ps

// t_LCD_cursur : testbench for preliminary report A
//   clock 1 kHz -> 1 clock = 1 ms, rst is active low
//
//   buttons (each held 100 ms, 100 ms apart, after initialization):
//     9 -> 5 -> * (left) -> # (right)
//
//   expected LCD outputs (LCD_DATA at cnt 21 of WRITE / CURSOR):
//     9 : RS = 1, 0011_1001    5 : RS = 1, 0011_0101
//     * : RS = 0, 0001_0000    # : RS = 0, 0001_0100
//
//   In the waveform, add U1/state, U1/cnt, LED_out, LCD_RS, LCD_RW, LCD_DATA.
//   Every state change and every non-idle LCD output is also printed in the
//   Tcl console. The simulation stops at 1.2 s.
module t_LCD_cursur;

reg rst, clk;
reg [9:0] number_btn;
reg [1:0] control_btn;
wire LCD_E, LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
wire [7:0] LED_out;

LCD_cursur U1(rst, clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out, number_btn, control_btn);

// 1 kHz clock: period 1 ms, toggle every 0.5 ms
initial begin
    clk = 0;
    forever #500000 clk = ~clk;
end

initial begin
    rst = 0;                                // reset (active low) for 1.8 ms
    number_btn = 10'b0000_0000_00;
    control_btn = 2'b00;
    #1800000 rst = 1;

    #398200000 number_btn = 10'b0000_0000_10;     // 400 ms: button 9
    #100000000 number_btn = 10'b0000_0000_00;
    #100000000 number_btn = 10'b0000_1000_00;     // 600 ms: button 5
    #100000000 number_btn = 10'b0000_0000_00;
    #100000000 control_btn = 2'b10;               // 800 ms: * (left)
    #100000000 control_btn = 2'b00;
    #100000000 control_btn = 2'b01;               // 1000 ms: # (right)
    #100000000 control_btn = 2'b00;
    #100000000 $finish;                           // stop at 1.2 s
end

// print every state change
always @(U1.state)
    $display("[%7.1f ms] state = %b", $realtime / 1e6, U1.state);

// print LCD outputs other than the idle instruction 0000_1111
always @(negedge LCD_E)
    if(rst && U1.state >= U1.DELAY_T && LCD_DATA != 8'b0000_1111)
        $display("[%7.1f ms] LCD RS = %b, RW = %b, DATA = %b", $realtime / 1e6, LCD_RS, LCD_RW, LCD_DATA);

endmodule
