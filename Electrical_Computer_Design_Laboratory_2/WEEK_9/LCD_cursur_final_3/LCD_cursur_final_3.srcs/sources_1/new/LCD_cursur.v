`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2026/11/03 09:36:28
// Design Name:
// Module Name: LCD_cursur
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Week 9 (Text LCD cursor) result report C - report B (DIP switch 2
//              changes the line) + # at the last visible column wraps to column 0
//
// Dependencies: oneshot_universal
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   Based on LCD_cursur_final_2 (report B), with this change:
//   6) # at DISP_LAST_COL sends a DD-RAM address set to column 0 of the same line
//      instead of Cursor shift right, so the cursor never enters the internal area
//      (0x0F -> 0x00, 0x4F -> 0x40). col also follows address sets now.
//
//   Report B changes, compared to the WEEK_9 LCD_cursur example:
//   1) new input dip: 0 = LINE1, 1 = LINE2
//   2) {dip, ~dip} added to the one-shot: it only sees rising edges, so ~dip is
//      what catches dip going 1 -> 0 (back to LINE1)
//   3) new state LINE_CHANGE: state is now 4 bits (3 bits were all used)
//   4) col remembers the cursor column, so the cursor keeps its column when the
//      line changes (line 1 = 0x00~, line 2 = 0x40~: only address bit A6 differs)
//   5) SET_ADDRESS sets the address from dip instead of Cursor At Home, so the
//      cursor starts on the line the switch is already on
//
//   State flow:
//     DELAY -> FUNCTION_SET -> DISP_ONOFF -> ENTRY_MODE -> SET_ADDRESS   (once after reset)
//     -> DELAY_T -> WRITE       -> DELAY_T ...    (number button pressed)
//     -> DELAY_T -> CURSOR      -> DELAY_T ...    (* or # button pressed)
//     -> DELAY_T -> LINE_CHANGE -> DELAY_T ...    (dip changed)
//
//   Clock: ~1 kHz, same as the example. The switch is only seen in DELAY_T: a
//   change during WRITE / CURSOR / LINE_CHANGE (31 ms) is missed until the next change.
//////////////////////////////////////////////////////////////////////////////////


// rst         : active-low reset
// clk         : system clock (also used directly as LCD_E)
// LCD_E       : enable, LCD latches RS/RW/DATA on the falling edge
// LCD_RS      : register select, 0 = instruction, 1 = data (character)
// LCD_RW      : 0 = write to LCD, 1 = read from LCD
// LCD_DATA    : DB[7:0], instruction code or character code
// LED_out     : one-hot display of the current state (LED8 = DELAY ... LED1 = CURSOR),
//               LED2 and LED1 together = LINE_CHANGE
// number_btn  : [9] = button 1, [8] = button 2 ... [1] = button 9, [0] = button 0
// control_btn : [1] = * (cursor left), [0] = # (cursor right)
// dip         : cursor line, 0 = LINE1, 1 = LINE2
module LCD_cursur(rst, clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out, number_btn, control_btn, dip);

input rst, clk;
input [9:0] number_btn;
input [1:0] control_btn;
input dip;

wire [9:0] number_btn_t;
wire [1:0] control_btn_t;
wire [1:0] dip_t;           // [1] = dip 0 -> 1, [0] = dip 1 -> 0

// one clock pulses, only used to leave DELAY_T once per press / switch change
oneshot_universal #(.WIDTH(14)) O1(clk, rst, {number_btn[9:0], control_btn[1:0], dip, ~dip}, {number_btn_t[9:0], control_btn_t[1:0], dip_t[1:0]});

output LCD_E, LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;
output reg [7:0] LED_out;

wire LCD_E;
reg LCD_RS, LCD_RW;

// clock counter inside the current state (0 ~ limit)
reg [7:0] cnt;

// cursor column, 0 ~ 39 (address A5~A0, each line is 40 characters long)
reg [5:0] col;

// one state per LCD instruction
reg [3:0] state;
parameter DELAY        = 4'b0000,   // wait for LCD power-on reset
          FUNCTION_SET = 4'b0001,   // data length / number of lines
          DISP_ONOFF   = 4'b0010,   // display, cursor, blink on/off
          ENTRY_MODE   = 4'b0011,   // cursor move direction / display shift
          SET_ADDRESS  = 4'b0100,   // cursor to column 0 of the dip line
          DELAY_T      = 4'b0101,   // idle, wait for a button
          WRITE        = 4'b0110,   // write the pressed number at the cursor
          CURSOR       = 4'b0111,   // move the cursor left / right
          LINE_CHANGE  = 4'b1000;   // move the cursor to the other line

// cnt limit of each state: the state lasts (limit + 1) clocks
// DELAY_T has no limit, it stays until a button is pressed
parameter DELAY_CNT        = 70,
          FUNCTION_SET_CNT = 30,
          DISP_ONOFF_CNT   = 30,
          ENTRY_MODE_CNT   = 30,
          SET_ADDRESS_CNT  = 100,
          WRITE_CNT        = 30,
          CURSOR_CNT       = 30,
          LINE_CHANGE_CNT  = 30;

// WRITE / CURSOR / LINE_CHANGE act only at this cnt, so one press = one LCD operation
parameter EXEC_CNT = 20;

// last column of a line in DD-RAM (0x27 / 0x67)
parameter LAST_COL = 39;

// last column visible on the 16 x 2 LCD (0x0F / 0x4F)
parameter DISP_LAST_COL = 15;

// state transition
// move to the next state when cnt reaches the state's limit
always @(posedge clk or negedge rst)
begin
    if(!rst) begin
        state <= DELAY;
        LED_out <= 8'b0000_0000;
    end
    else begin
        case(state)
            DELAY : begin
                if(cnt == DELAY_CNT) state <= FUNCTION_SET;
                LED_out <= 8'b1000_0000;
            end
            FUNCTION_SET : begin
                if(cnt == FUNCTION_SET_CNT) state <= DISP_ONOFF;
                LED_out <= 8'b0100_0000;
            end
            DISP_ONOFF : begin
                if(cnt == DISP_ONOFF_CNT) state <= ENTRY_MODE;
                LED_out <= 8'b0010_0000;
            end
            ENTRY_MODE : begin
                if(cnt == ENTRY_MODE_CNT) state <= SET_ADDRESS;
                LED_out <= 8'b0001_0000;
            end
            SET_ADDRESS : begin
                if(cnt == SET_ADDRESS_CNT) state <= DELAY_T;
                LED_out <= 8'b0000_1000;
            end
            DELAY_T : begin
                state <= |number_btn_t ? WRITE : (|control_btn_t ? CURSOR : (|dip_t ? LINE_CHANGE : DELAY_T));
                LED_out <= 8'b0000_0100;
            end
            WRITE : begin
                if(cnt == WRITE_CNT) state <= DELAY_T;
                LED_out <= 8'b0000_0010;
            end
            CURSOR : begin
                if(cnt == CURSOR_CNT) state <= DELAY_T;
                LED_out <= 8'b0000_0001;
            end
            LINE_CHANGE : begin
                if(cnt == LINE_CHANGE_CNT) state <= DELAY_T;
                LED_out <= 8'b0000_0011;
            end
            default : begin state <= DELAY; LED_out <= 8'b0000_0000; end
        endcase
    end
end

// cnt: +1 every clock, cleared when the state's limit is reached
// (limits must match the ones in the state transition block, so cnt is 0
//  at the first clock of every new state)
always @(posedge clk or negedge rst)
begin
    if(!rst)
        cnt <= 8'b0000_0000;
    else begin
        case(state)
            DELAY :
                if(cnt >= DELAY_CNT) cnt <= 0;
                else cnt <= cnt + 1;
            FUNCTION_SET :
                if(cnt >= FUNCTION_SET_CNT) cnt <= 0;
                else cnt <= cnt + 1;
            DISP_ONOFF :
                if(cnt >= DISP_ONOFF_CNT) cnt <= 0;
                else cnt <= cnt + 1;
            ENTRY_MODE :
                if(cnt >= ENTRY_MODE_CNT) cnt <= 0;
                else cnt <= cnt + 1;
            SET_ADDRESS :
                if(cnt >= SET_ADDRESS_CNT) cnt <= 0;
                else cnt <= cnt + 1;
            DELAY_T :
                cnt <= 0;
            WRITE :
                if(cnt >= WRITE_CNT) cnt <= 0;
                else cnt <= cnt + 1;
            CURSOR :
                if(cnt >= CURSOR_CNT) cnt <= 0;
                else cnt <= cnt + 1;
            LINE_CHANGE :
                if(cnt >= LINE_CHANGE_CNT) cnt <= 0;
                else cnt <= cnt + 1;
            default : cnt <= 0;
        endcase
    end
end

// instruction / data output for each state
// {LCD_RS, LCD_RW, LCD_DATA} = {RS, RW, DB[7:0]}
//   RS = 0, RW = 0 : write instruction
//   RS = 1, RW = 0 : write data (character code) to DD-RAM at the cursor
// The DELAY state has no case item, so the reset value (Clear Display) stays on
// the outputs until FUNCTION_SET: the screen starts empty after reset.
always @(posedge clk or negedge rst)
begin
    if(!rst)
        {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_0001;
    else begin
        case(state)
            FUNCTION_SET :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0011_1000;
                // DB = 0 0 1 IF N x x x
                // IF = 1 => 8 bit data
                // N  = 1 => 2 lines
            DISP_ONOFF :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_1111;
                // DB = 0 0 0 0 1 D C B
                // D = 1 => display on, C = 1 => cursor on, B = 1 => cursor blink on
            ENTRY_MODE :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_0110;
                // DB = 0 0 0 0 0 1 I/D S
                // I/D = 1 => cursor moves right (address +1) after each write
                // S   = 0 => display does not shift
            SET_ADDRESS :
                {LCD_RS, LCD_RW, LCD_DATA} <= {2'b00, 1'b1, dip, col};
                // DD-RAM address set, DB = 1 A6~A0 (col is 0 here)
                // dip = 0 => 0x00 (LINE1), dip = 1 => 0x40 (LINE2)
            DELAY_T :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_1111;
                // idle: same as DISP_ONOFF, the screen and cursor do not change
            WRITE : begin
                // number_btn, not number_btn_t: the one-shot pulse is over at cnt 20,
                // so the button must still be held here
                if(cnt == EXEC_CNT) begin
                    case(number_btn)
                        10'b1000_0000_00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0001; // 1
                        10'b0100_0000_00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0010; // 2
                        10'b0010_0000_00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0011; // 3
                        10'b0001_0000_00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0100; // 4
                        10'b0000_1000_00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0101; // 5
                        10'b0000_0100_00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0110; // 6
                        10'b0000_0010_00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0111; // 7
                        10'b0000_0001_00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_1000; // 8
                        10'b0000_0000_10 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_1001; // 9
                        10'b0000_0000_01 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0000; // 0
                    endcase
                end
                else {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_1111;
            end
            CURSOR : begin
                // DB = 0 0 0 1 S/C R/L x x
                // S/C = 0 => move the cursor, R/L = 0 => left, 1 => right
                if(cnt == EXEC_CNT) begin
                    case(control_btn)
                        2'b10 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0001_0000; // left
                        2'b01 : begin
                            // >= : also comes back if a write left the cursor past the last column
                            if(col >= DISP_LAST_COL) {LCD_RS, LCD_RW, LCD_DATA} <= {2'b00, 1'b1, dip, 6'd0}; // column 0
                            else {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0001_0100; // right
                        end
                    endcase
                end
                else {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_1111;
            end
            LINE_CHANGE : begin
                // DD-RAM address set, DB = 1 A6~A0
                // A6 = dip selects the line, A5~A0 = col keeps the column
                if(cnt == EXEC_CNT) {LCD_RS, LCD_RW, LCD_DATA} <= {2'b00, 1'b1, dip, col};
                else {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_1111;
            end
        endcase
    end
end

// col follows what was actually sent to the LCD, so a press that wrote nothing
// (button released before cnt 20) does not move it
//   character written  : address +1 (entry mode I/D = 1)
//   cursor left, right : address -1, +1
//   address set        : column = A5~A0
always @(posedge clk or negedge rst)
begin
    if(!rst)
        col <= 6'd0;
    else if(LCD_RS || LCD_DATA == 8'b0001_0100)
        col <= (col == LAST_COL) ? 6'd0 : col + 1;
    else if(LCD_DATA == 8'b0001_0000)
        col <= (col == 0) ? LAST_COL : col - 1;
    else if(LCD_DATA[7])
        col <= LCD_DATA[5:0];
end

// LCD enable driven directly by the clock (one write per clock)
assign LCD_E = clk;

endmodule
