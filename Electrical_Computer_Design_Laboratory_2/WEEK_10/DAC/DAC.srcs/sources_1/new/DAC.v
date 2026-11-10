`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2026/11/05 12:14:18
// Design Name:
// Module Name: DAC
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Week 10 (DAC) - AD7302 8-bit DAC controller (preliminary report D)
//
// Dependencies: oneshot_universal.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   One write cycle = DELAY (201 clk) -> SET_WRN (51 clk) -> UP_DATA (31 clk).
//   WR goes low in SET_WRN, dac_d is loaded in UP_DATA while WR is still low,
//   and the AD7302 latches dac_d on the WR rising edge at the next DELAY.
//
//////////////////////////////////////////////////////////////////////////////////


// AD7302 data path:
//   dac_d --(CS & WR low)--> input register --(LDAC low)--> DAC register --> VOUTA/VOUTB
//
// clk       : system clock, drives the FSM and the cycle counter
// rst       : active-low reset, returns the FSM to DELAY and clears dac_d_temp
// btn       : push buttons that change the value to write
//             [5] SM_1 -1, [4] SM_3 +1, [3] SM_4 -2, [2] SM_6 +2, [1] SM_7 -8, [0] SM_9 +8
// add_sel   : output channel select switch, 0 = VOUTA, 1 = VOUTB (passed to dac_a_b)
// dac_csn   : chip select (active low). Data is accepted only while CS and WR are both low.
//             Only one AD7302 is on the bus, so it is tied to 0 (always selected).
// dac_ldacn : load DAC (active low). Moves the input register value into the DAC register,
//             which updates the analog output. Normally used to update A and B at the same time.
//             Tied to 0 here, so the DAC register is transparent and the output changes
//             as soon as a write finishes.
// dac_wrn   : write (active low). The only signal that controls write timing:
//             low = take dac_d, rising edge = latch dac_d into the input register.
// dac_a_b   : selects which channel's input register (A or B) receives the write
// dac_d     : 8-bit digital value sent to the DAC, dac_d[7] = MSB
// led_out   : shows the current value to write (dac_d_temp) on the LEDs
module DAC(clk, rst, btn, add_sel, dac_csn, dac_ldacn, dac_wrn, dac_a_b, dac_d, led_out);

input clk, rst;
input [5:0] btn; // push button used for increment or decrease of baud rate
input add_sel; // output pin select(dac output A, B)
output reg dac_csn, dac_ldacn, dac_wrn, dac_a_b;
output reg [7:0] dac_d;
output reg [7:0] led_out;

reg [7:0] dac_d_temp;   // value to write, changed by the buttons
reg [7:0] cnt;          // clocks spent in the current state
wire [5:0] btn_t;       // one clock pulse per button press

reg [1:0] state;

parameter DELAY   = 2'b00,  // WR = 1 (rising edge latches dac_d)
          SET_WRN = 2'b01,  // WR = 0
          UP_DATA = 2'b10;  // dac_d <= dac_d_temp

oneshot_universal #(.WIDTH(6)) O1(clk, rst, {btn[5:0]}, {btn_t[5:0]}); // apply one-shot trigger to buttons

// state transition
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        state <= DELAY;
    end
    else begin
        case(state)
            DELAY   : if(cnt == 200) state <= SET_WRN;
            SET_WRN : if(cnt == 50) state <= UP_DATA;
            UP_DATA : if(cnt == 30) state <= DELAY;
        endcase
    end
end

// cnt: counts up in each state, back to 0 when the state changes
always @(posedge clk or negedge rst) begin
    if(!rst)
        cnt <= 8'b0000_0000;
    else begin
        case(state)
            DELAY :
                if(cnt >= 200) cnt <= 0;
                else cnt <= cnt + 1;
            SET_WRN :
                if(cnt >= 50) cnt <= 0;
                else cnt <= cnt + 1;
            UP_DATA :
                if(cnt >= 30) cnt <= 0;
                else cnt <= cnt + 1;
        endcase
    end
end

// WR and data outputs for each state
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        dac_wrn <= 1;
    end
    else begin
        case(state)
            DELAY :
                dac_wrn <= 1;
            SET_WRN :
                dac_wrn <= 0; // load enable(negative level sensitive)
            UP_DATA :
                dac_d <= dac_d_temp;    // dac_wrn stays 0
        endcase
    end
end

// buttons: change dac_d_temp by 1, 2, 8 (8-bit, wraps 0 <-> 255)
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        dac_d_temp <= 8'b0000_0000;
        led_out <= 8'b0101_0101;
    end
    else begin
        if(btn_t == 6'b100000)      dac_d_temp <= dac_d_temp - 8'b0000_0001;   // SM_1 ==> -1
        else if(btn_t == 6'b010000) dac_d_temp <= dac_d_temp + 8'b0000_0001;   // SM_3 ==> +1
        else if(btn_t == 6'b001000) dac_d_temp <= dac_d_temp - 8'b0000_0010;   // SM_4 ==> -2
        else if(btn_t == 6'b000100) dac_d_temp <= dac_d_temp + 8'b0000_0010;   // SM_6 ==> +2
        else if(btn_t == 6'b000010) dac_d_temp <= dac_d_temp - 8'b0000_1000;   // SM_7 ==> -8
        else if(btn_t == 6'b000001) dac_d_temp <= dac_d_temp + 8'b0000_1000;   // SM_9 ==> +8
        led_out <= dac_d_temp;
    end
end

// fixed control pins and output select
always @(posedge clk) begin
    dac_csn <= 0;
    dac_ldacn <= 0;
    dac_a_b <= add_sel;     // 0 : select A, 1 : select B
end

endmodule
