`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: btn_debounce
// Description: removes the contact bounce of a push button
//
//   Why it is needed here:
//     In the earlier labs the clock was ~1 kHz, so one clock (1 ms) was
//     already longer than most bounces. This project runs at 50 MHz, where
//     one press bounces for thousands of clocks. Without this module one
//     press of "+1 hour" could add several hours.
//
//   How it works:
//     1. btn is passed through two flip-flops (btn_s1 -> btn_s2) so that the
//        asynchronous button is synchronized to clk.
//     2. While btn_s2 differs from the accepted level btn_db, cnt counts up.
//        If they become equal again (a bounce), cnt goes back to 0.
//     3. Only when btn_s2 stays different for STABLE_CYC clocks in a row
//        (= DEBOUNCE_MS ms), btn_db takes the new level.
//
//     btn     _____|‾|_|‾‾|_|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|_|‾|________
//     btn_db  ___________________________|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|__
//                          |<- 10 ms ->|
//
//   btn_db is a clean level. Use oneshot_universal after it to get one
//   clock pulse per press.
//////////////////////////////////////////////////////////////////////////////////


// clk    : system clock
// rst    : active-low reset
// btn    : raw button input (1 = pressed)
// btn_db : debounced button level
module btn_debounce(clk, rst, btn, btn_db);

parameter CLK_HZ      = 50_000_000;     // clock frequency
parameter DEBOUNCE_MS = 10;             // the input must be stable this long

// number of clocks the input must stay stable (at least 1 for tiny CLK_HZ in sim)
localparam STABLE_CYC = (CLK_HZ / 1000 * DEBOUNCE_MS > 0) ? (CLK_HZ / 1000 * DEBOUNCE_MS) : 1;

input  clk, rst, btn;
output reg btn_db;

reg btn_s1, btn_s2;     // 2-stage synchronizer
reg [31:0] cnt;         // how long btn_s2 has been different from btn_db

always @(posedge clk or negedge rst)
begin
    if(!rst) begin
        btn_s1 <= 1'b0;
        btn_s2 <= 1'b0;
        btn_db <= 1'b0;
        cnt    <= 0;
    end
    else begin
        btn_s1 <= btn;
        btn_s2 <= btn_s1;

        if(btn_s2 == btn_db)
            cnt <= 0;                       // same as accepted level (or a bounce): restart
        else if(cnt >= STABLE_CYC - 1) begin
            btn_db <= btn_s2;               // stable long enough: accept the new level
            cnt    <= 0;
        end
        else
            cnt <= cnt + 1;                 // still different: keep counting
    end
end

endmodule
