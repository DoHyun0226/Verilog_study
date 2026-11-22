`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: time_keeper
// Description: "traffic light time" clock (hh:mm:ss) with a speed-up scale
//              and a +1 hour button
//
//   This clock only decides day / night and is shown on line 1 of the LCD.
//   The signal state times (5 s, 10 s, 1 s yellow, 15 s emergency) are NOT
//   scaled: traffic_ctrl counts them in real time by itself.
//
//   Speed-up scale (scale_sel, DIP switches SW3 SW2):
//     00 -> x1   : 1 clock second every 50_000_000 clocks (1 s real)
//     01 -> x10  : 1 clock second every  5_000_000 clocks (0.1 s real)
//     10 -> x100 : 1 clock second every    500_000 clocks (10 ms real)
//     11 -> x200 : 1 clock second every    250_000 clocks (5 ms real)
//   (numbers for CLK_HZ = 50 MHz)
//
//   How it works:
//     pre_cnt counts clocks. When it reaches the limit of the selected scale,
//     sec_tick is 1 for one clock and pre_cnt starts again from 0.
//     sec_tick advances sec; sec 59 -> 0 carries into min; min 59 -> 0
//     carries into hour; hour 23 -> 0.
//     hour_inc (one clock pulse from the button) adds 1 to hour only;
//     min and sec are kept (e.g. 07:59:40 -> 08:59:40).
//
//   Day / night (by this clock, as the lab defines it):
//     day   = 08:00:00 ~ 22:59:59   (8 <= hour < 23)
//     night = 23:00:00 ~ 07:59:59
//////////////////////////////////////////////////////////////////////////////////


// clk       : system clock
// rst       : active-low reset (time goes back to INIT_HOUR:INIT_MIN:INIT_SEC)
// scale_sel : speed-up scale, 0 = x1, 1 = x10, 2 = x100, 3 = x200
// hour_inc  : one clock pulse -> hour + 1
// hour      : 0 ~ 23
// min       : 0 ~ 59
// sec       : 0 ~ 59
// is_day    : 1 = day (08:00 ~ 23:00), 0 = night
module time_keeper(clk, rst, scale_sel, hour_inc, hour, min, sec, is_day);

parameter CLK_HZ    = 50_000_000;   // clock frequency
parameter INIT_HOUR = 0;            // time after reset
parameter INIT_MIN  = 0;
parameter INIT_SEC  = 0;

input clk, rst;
input [1:0] scale_sel;
input hour_inc;
output reg [4:0] hour;
output reg [5:0] min;
output reg [5:0] sec;
output is_day;

// ------------------------------------------------------------------
// prescaler: one sec_tick per (CLK_HZ / scale) clocks
// ------------------------------------------------------------------
reg [31:0] pre_cnt;
reg [31:0] pre_limit;           // pre_cnt value at which the tick fires
wire sec_tick = (pre_cnt >= pre_limit);
// ">=" instead of "==": if the scale is changed to a faster one while
// pre_cnt is already above the new limit, the tick still fires at once
// instead of waiting for pre_cnt to wrap around 2^32.

always @(*)
begin
    case(scale_sel)
        2'd0    : pre_limit = CLK_HZ / 1   - 1;     // x1
        2'd1    : pre_limit = CLK_HZ / 10  - 1;     // x10
        2'd2    : pre_limit = CLK_HZ / 100 - 1;     // x100
        default : pre_limit = CLK_HZ / 200 - 1;     // x200
    endcase
end

always @(posedge clk or negedge rst)
begin
    if(!rst)
        pre_cnt <= 0;
    else if(sec_tick)
        pre_cnt <= 0;
    else
        pre_cnt <= pre_cnt + 1;
end

// ------------------------------------------------------------------
// hh:mm:ss counter
// ------------------------------------------------------------------
wire sec_wrap = sec_tick && (sec == 59);    // this tick turns sec 59 -> 0
wire min_wrap = sec_wrap && (min == 59);    // ... and min 59 -> 0

// hour + (carry from minutes) + (button). Both can happen in the same
// clock, so the sum can be up to hour + 2; wrap it back into 0 ~ 23.
wire [5:0] hour_sum = hour + min_wrap + hour_inc;

always @(posedge clk or negedge rst)
begin
    if(!rst) begin
        hour <= INIT_HOUR;
        min  <= INIT_MIN;
        sec  <= INIT_SEC;
    end
    else begin
        if(sec_tick)
            sec <= sec_wrap ? 0 : sec + 1;

        if(sec_wrap)
            min <= min_wrap ? 0 : min + 1;

        if(min_wrap || hour_inc)
            hour <= (hour_sum >= 24) ? hour_sum - 24 : hour_sum;
    end
end

assign is_day = (hour >= 8) && (hour < 23);

endmodule
