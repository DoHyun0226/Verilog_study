`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2026/10/24 20:54:07
// Design Name:
// Module Name: text_LCD_basic
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Week 8 (Text LCD) example - line 1 "HELLO WORLD!", line 2 student ID + initials
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   Based on the lab manual example, with two changes:
//   1) clocked always blocks use non-blocking (<=) assignments
//   2) "default : state = DELAY;" in the cnt block -> "default : cnt <= 0;"
//      (state must be driven from only one always block)
//   3) cnt limits moved to parameters (*_CNT), values same as the lab manual
//   D version (text shifts left one column per loop, like an LED sign board):
//   4) DELAY_T    : Return Home (0x02)   -> Display ON/OFF (0x0C, no change)
//      CLEAR_DISP : Clear Display (0x01) -> Display Shift left (0x18) at cnt 0,
//                                           Display ON/OFF (0x0C) otherwise
//      Clear Display / Return Home both reset the display shift, so they are
//      replaced by instructions that leave the shift as it is.
//      LINE1 / LINE2 rewrite the same text every loop, and address set / data
//      write do not change the shift, so the screen moves one column per loop.
//      In 2-line mode each line rotates within its 40 columns
//      (0x00~0x27 / 0x40~0x67): after 40 loops the screen is back to the start.
//      Speed: one column per loop (54 clocks); increase DELAY_T_CNT to slow down.
//
//   16 x 2 text LCD control sequence (lab manual 1.2):
//     power on -> wait >= 50 ms (LCD internal reset) -> Function Set
//     -> Display ON/OFF -> Entry Mode Set -> DD-RAM address set
//     -> DD-RAM data (characters) -> repeat
//
//   State flow:
//     DELAY -> FUNCTION_SET -> DISP_ONOFF -> ENTRY_MODE      (once after reset)
//     -> LINE1 -> LINE2 -> DELAY_T -> CLEAR_DISP -> LINE1 ... (repeated)
//
//   Clock: one LCD write per clk period, so clk must be slow enough for the LCD.
//   e.g. ~1 kHz: DELAY lasts 71 clocks ~ 71 ms (> 50 ms power-on wait), and
//   every instruction used in the loop (shift, display on/off, address set,
//   data write) takes ~37~43 us, well within one 1 ms clock.
//   A 50 MHz clock is far too fast for the LCD.
//////////////////////////////////////////////////////////////////////////////////


// rst      : active-low reset
// clk      : system clock (also used directly as LCD_E)
// LCD_E    : enable, LCD latches RS/RW/DATA on the falling edge
// LCD_RS   : register select, 0 = instruction, 1 = data (character)
// LCD_RW   : 0 = write to LCD, 1 = read from LCD
// LCD_DATA : DB[7:0], instruction code or character code
// LED_out  : one-hot display of the current state (LED8 = DELAY ... LED1 = CLEAR_DISP)
module text_LCD_basic(rst, clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out);

input rst, clk;

output LCD_E, LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;
output reg [7:0] LED_out;

wire LCD_E;
reg LCD_RS, LCD_RW;

// one state per LCD instruction
reg [2:0] state;
parameter DELAY        = 3'b000,    // wait for LCD power-on reset
          FUNCTION_SET = 3'b001,    // data length / number of lines
          ENTRY_MODE   = 3'b010,    // cursor move direction / display shift
          DISP_ONOFF   = 3'b011,    // display, cursor, blink on/off
          LINE1        = 3'b100,    // write line 1 (address 0x00~)
          LINE2        = 3'b101,    // write line 2 (address 0x40~)
          DELAY_T      = 3'b110,    // hold the text on screen
          CLEAR_DISP   = 3'b111;    // shift the display left by one column

// cnt limit of each state: the state lasts (limit + 1) clocks
// LINE1 / LINE2: cnt 0 = address set, cnt 1~16 = 16 characters (columns 0~15),
// cnt 17~20 = spaces written past column 15 (0x10~0x13 / 0x50~0x53, not visible)
// (set LINE1_CNT / LINE2_CNT = 16 to stop right after column 15)
parameter DELAY_CNT        = 70,
          FUNCTION_SET_CNT = 30,
          DISP_ONOFF_CNT   = 30,
          ENTRY_MODE_CNT   = 30,
          LINE1_CNT        = 20,
          LINE2_CNT        = 20,
          DELAY_T_CNT      = 5,
          CLEAR_DISP_CNT   = 5;

// clock counter inside the current state (0 ~ limit)
integer cnt;

// state transition
// move to the next state when cnt reaches the state's limit,
// so each state lasts (limit + 1) clocks. A larger limit = longer stay.
always @(posedge clk or negedge rst)
begin
    if(!rst) begin
        state <= DELAY;
        LED_out <= 8'b1000_0000;
    end
    else
    begin
        case(state)
            DELAY : begin
                LED_out <= 8'b1000_0000;
                if(cnt == DELAY_CNT) state <= FUNCTION_SET;
            end
            FUNCTION_SET : begin
                LED_out <= 8'b0100_0000;
                if(cnt == FUNCTION_SET_CNT) state <= DISP_ONOFF;
            end
            DISP_ONOFF : begin
                LED_out <= 8'b0010_0000;
                if(cnt == DISP_ONOFF_CNT) state <= ENTRY_MODE;
            end
            ENTRY_MODE : begin
                LED_out <= 8'b0001_0000;
                if(cnt == ENTRY_MODE_CNT) state <= LINE1;
            end
            LINE1 : begin
                LED_out <= 8'b0000_1000;
                if(cnt == LINE1_CNT) state <= LINE2;
            end
            LINE2 : begin
                LED_out <= 8'b0000_0100;
                if(cnt == LINE2_CNT) state <= DELAY_T;
            end
            DELAY_T : begin
                LED_out <= 8'b0000_0010;
                if(cnt == DELAY_T_CNT) state <= CLEAR_DISP;
            end
            CLEAR_DISP : begin
                LED_out <= 8'b0000_0001;
                if(cnt == CLEAR_DISP_CNT) state <= LINE1;    // back to LINE1, init states are skipped
            end
            default : begin state <= DELAY; LED_out <= 8'b1000_0000; end
        endcase
    end
end

// cnt: +1 every clock, cleared when the state's limit is reached
// (limits must match the ones in the state transition block, so cnt is 0
//  at the first clock of every new state)
always @(posedge clk or negedge rst)
begin
    if(!rst)
        cnt <= 0;
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
            LINE1 :
                if(cnt >= LINE1_CNT) cnt <= 0;
                else cnt <= cnt + 1;
            LINE2 :
                if(cnt >= LINE2_CNT) cnt <= 0;
                else cnt <= cnt + 1;
            DELAY_T :
                if(cnt >= DELAY_T_CNT) cnt <= 0;
                else cnt <= cnt + 1;
            CLEAR_DISP :
                if(cnt >= CLEAR_DISP_CNT) cnt <= 0;
                else cnt <= cnt + 1;
            default : cnt <= 0;
        endcase
    end
end

// instruction / data output for each state
// {LCD_RS, LCD_RW, LCD_DATA} = {RS, RW, DB[7:0]}
//   RS = 0, RW = 0 : write instruction
//   RS = 1, RW = 0 : write data (character code) to DD-RAM
// The outputs are registered, so they change on the rising edge of clk and
// the LCD latches them half a clock later on the falling edge of LCD_E (= clk).
always @(posedge clk or negedge rst)
begin
    if(!rst)
        {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_1_0000_0000;    // RW = 1: nothing is written
    else begin
        case(state)
            FUNCTION_SET :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0011_1000;
                // DB = 0 0 1 DL N F x x
                // DL = 1 => Data Length: 8 bit (0: 4 bit)
                // N  = 1 => Row: 2 lines   (0: 1 line)
                // F  = 0 => 5 x 8 dot font
            DISP_ONOFF :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_1100;
                // DB = 0 0 0 0 1 D C B
                // D = 1 => display on, C = 0 => cursor off, B = 0 => cursor blink off
            ENTRY_MODE :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_0110;
                // DB = 0 0 0 0 0 1 I/D S
                // I/D = 1 => cursor moves right (address +1) after each write
                // S   = 0 => display does not shift
            LINE1 :
                // cnt 0     : DD-RAM address set (DB = 1 A6~A0), start position of line 1
                // cnt 1~16  : characters for columns 0~15 (address auto-increments)
                // cnt 17~20 : default (space) -> address 0x10~0x13, not visible
                // character codes follow the LCD character table (same as ASCII)
                // comment format:
                //   set addr : RS = 0, DATA = instruction (1 A6~A0) that sets the address counter
                //   addr     : RS = 1, DD-RAM address the character is written to
                //              (not in DATA, the LCD address counter supplies it)
                //   ascii    : RS = 1, DATA = character code written to that address
                begin
                    case(cnt)
                        00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_1000_0000; // set addr 0x00  | instr 0x80 (DD-RAM address set)
                        01 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0010_0000; // addr 0x00      | ascii 0x20 (space)
                        02 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_1000; // addr 0x01      | ascii 0x48 H
                        03 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_0101; // addr 0x02      | ascii 0x45 E
                        04 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_1100; // addr 0x03      | ascii 0x4C L
                        05 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_1100; // addr 0x04      | ascii 0x4C L
                        06 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_1111; // addr 0x05      | ascii 0x4F O
                        07 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0010_0000; // addr 0x06      | ascii 0x20 (space)
                        08 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0101_0111; // addr 0x07      | ascii 0x57 W
                        09 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_1111; // addr 0x08      | ascii 0x4F O
                        10 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0101_0010; // addr 0x09      | ascii 0x52 R
                        11 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_1100; // addr 0x0A      | ascii 0x4C L
                        12 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_0100; // addr 0x0B      | ascii 0x44 D
                        13 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0010_0001; // addr 0x0C      | ascii 0x21 !
                        14 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0010_0000; // addr 0x0D      | ascii 0x20 (space)
                        15 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0010_0000; // addr 0x0E      | ascii 0x20 (space)
                        16 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0010_0000; // addr 0x0F      | ascii 0x20 (space)
                        default : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0010_0000; // addr 0x10~0x13 | ascii 0x20 (space)
                    endcase
                end
            LINE2 :
                // same structure as LINE1, starting at address 0x40 (hex)
                // = first column of line 2 (DB = 1 100_0000)
                // 2-line mode: line 2 = 0x40~0x67, visible 0x40~0x4F
                // cnt 17~20 -> address 0x50~0x53, not visible
                begin
                    case(cnt)
                        00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_1100_0000; // set addr 0x40  | instr 0xC0 (DD-RAM address set)
                        01 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0010; // addr 0x40      | ascii 0x32 2
                        02 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0000; // addr 0x41      | ascii 0x30 0
                        03 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0010; // addr 0x42      | ascii 0x32 2
                        04 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0011; // addr 0x43      | ascii 0x33 3
                        05 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0100; // addr 0x44      | ascii 0x34 4
                        06 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0100; // addr 0x45      | ascii 0x34 4
                        07 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0000; // addr 0x46      | ascii 0x30 0
                        08 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0000; // addr 0x47      | ascii 0x30 0
                        09 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0111; // addr 0x48      | ascii 0x37 7
                        10 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0011_0101; // addr 0x49      | ascii 0x35 5
                        11 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0010_0000; // addr 0x4A      | ascii 0x20 (space)
                        12 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0101_1001; // addr 0x4B      | ascii 0x59 Y
                        13 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_0100; // addr 0x4C      | ascii 0x44 D
                        14 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0100_1000; // addr 0x4D      | ascii 0x48 H
                        15 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0010_0000; // addr 0x4E      | ascii 0x20 (space)
                        16 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0010_0000; // addr 0x4F      | ascii 0x20 (space)
                        default : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_0_0010_0000; // addr 0x50~0x53 | ascii 0x20 (space)
                    endcase
                end
            DELAY_T :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_1100;
                // Display ON/OFF Control (same value as DISP_ONOFF, no change)
                // Return Home (0x02) is not used: it would also undo the display shift
            CLEAR_DISP :
                // Clear Display (0x01) is not used: it would clear DD-RAM and undo the shift
                if(cnt == 0)
                    {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0001_1000;
                    // Cursor or Display Shift: DB = 0 0 0 1 S/C R/L x x
                    // S/C = 1 => shift the display (not just the cursor)
                    // R/L = 0 => shift left
                    // DD-RAM and address counter are not changed
                    // only once per loop (cnt 0), otherwise it would shift 6 times
                else
                    {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_1100;
                    // Display ON/OFF Control (no change)
            default :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_1_0000_0000;
                // DELAY state: RW = 1, no instruction is written during power-on wait
        endcase
    end
end

// LCD enable driven directly by the clock (one write per clock)
assign LCD_E = clk;

endmodule
