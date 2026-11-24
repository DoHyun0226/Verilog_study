`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: lcd_driver
// Description: writes two 16-character lines to the 16 x 2 text LCD,
//              running from the 50 MHz system clock
//
//   Same instruction flow as the WEEK_8 ~ WEEK_10 LCD examples:
//     DELAY -> FUNCTION_SET -> DISP_ONOFF -> ENTRY_MODE   (once after reset)
//     -> LINE1 -> LINE2 -> LINE1 -> LINE2 ...             (repeated)
//   LINE1 / LINE2 rewrite all 16 characters every loop, so the screen
//   follows line1 / line2 without Clear Display (no flicker).
//
//   Difference from the earlier examples:
//     There, the board clock was lowered to ~1 kHz and LCD_E = clk.
//     Here the clock is 50 MHz (far too fast for the LCD), so the time is
//     split into 1 ms "slots" with a counter, and each slot does exactly
//     what one 1 kHz clock did before:
//
//       slot_cnt  0          SLOT/4            3*SLOT/4        SLOT-1
//                 |            |                   |              |
//       RS/RW/DB  X== new value, stable for the whole slot ========X
//       LCD_E     ____________|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|_______________
//                                                  ^ LCD latches here
//
//     The data changes at the start of the slot, LCD_E goes high 0.25 ms
//     later and low 0.75 ms after the start; the LCD takes RS/RW/DB on the
//     falling edge of LCD_E. Every timing of the LCD (setup, hold, 37 us
//     command time) is met by a wide margin. One full screen refresh is
//     34 slots = 34 ms.
//
//   Characters: line1 / line2 are 16 ASCII codes, character 0 (leftmost)
//   in bits [127:120], character 15 (rightmost) in bits [7:0]. A Verilog
//   string such as "Time : 12:00:00 " has exactly this layout.
//////////////////////////////////////////////////////////////////////////////////


// clk      : system clock
// rst      : active-low reset
// line1    : 16 characters of the upper line
// line2    : 16 characters of the lower line
// LCD_E    : enable, LCD latches RS/RW/DATA on the falling edge
// LCD_RS   : register select, 0 = instruction, 1 = data (character)
// LCD_RW   : 0 = write to LCD, 1 = read from LCD
// LCD_DATA : DB[7:0], instruction code or character code
module lcd_driver(clk, rst, line1, line2, LCD_E, LCD_RS, LCD_RW, LCD_DATA);

parameter CLK_HZ = 50_000_000;  // clock frequency

// clocks in one 1 ms slot (at least 4 so that the E pulse exists in a small-CLK_HZ simulation)
localparam SLOT = (CLK_HZ / 1000 >= 4) ? CLK_HZ / 1000 : 4;

input clk, rst;
input [127:0] line1, line2;
output reg LCD_E, LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;

// ------------------------------------------------------------------
// 1 ms slot timing
// ------------------------------------------------------------------
reg [31:0] slot_cnt;
wire slot_start = (slot_cnt == 0);      // state / data update once per slot

always @(posedge clk or negedge rst)
begin
    if(!rst)
        slot_cnt <= 0;
    else if(slot_cnt >= SLOT - 1)
        slot_cnt <= 0;
    else
        slot_cnt <= slot_cnt + 1;
end

// LCD_E high in the middle half of the slot
always @(posedge clk or negedge rst)
begin
    if(!rst)
        LCD_E <= 1'b0;
    else
        LCD_E <= (slot_cnt >= SLOT / 4) && (slot_cnt < SLOT * 3 / 4);
end

// ------------------------------------------------------------------
// instruction state machine (one state per LCD instruction)
// ------------------------------------------------------------------
reg [2:0] state;
localparam DELAY        = 3'd0,     // wait for LCD power-on reset
           FUNCTION_SET = 3'd1,     // data length / number of lines
           DISP_ONOFF   = 3'd2,     // display, cursor, blink on/off
           ENTRY_MODE   = 3'd3,     // cursor move direction / display shift
           LINE1        = 3'd4,     // write line 1 (address 0x00~0x0F)
           LINE2        = 3'd5;     // write line 2 (address 0x40~0x4F)

// cnt limit of each state: the state lasts (limit + 1) slots
// LINE1 / LINE2: cnt 0 = address set, cnt 1~16 = characters 0~15
localparam DELAY_CNT        = 70,
           FUNCTION_SET_CNT = 30,
           DISP_ONOFF_CNT   = 30,
           ENTRY_MODE_CNT   = 30,
           LINE_CNT         = 16;

reg [7:0] cnt;      // slot counter inside the current state

reg [7:0] cnt_limit;
always @(*)
begin
    case(state)
        DELAY        : cnt_limit = DELAY_CNT;
        FUNCTION_SET : cnt_limit = FUNCTION_SET_CNT;
        DISP_ONOFF   : cnt_limit = DISP_ONOFF_CNT;
        ENTRY_MODE   : cnt_limit = ENTRY_MODE_CNT;
        default      : cnt_limit = LINE_CNT;            // LINE1, LINE2
    endcase
end

// state transition + cnt, once per slot
always @(posedge clk or negedge rst)
begin
    if(!rst) begin
        state <= DELAY;
        cnt   <= 0;
    end
    else if(slot_start) begin
        if(cnt >= cnt_limit) begin
            cnt <= 0;
            case(state)
                DELAY        : state <= FUNCTION_SET;
                FUNCTION_SET : state <= DISP_ONOFF;
                DISP_ONOFF   : state <= ENTRY_MODE;
                ENTRY_MODE   : state <= LINE1;
                LINE1        : state <= LINE2;
                LINE2        : state <= LINE1;      // back to LINE1, init states are skipped
                default      : state <= DELAY;
            endcase
        end
        else
            cnt <= cnt + 1;
    end
end

// character number c (0 = leftmost) of a 16-character line
function [7:0] char_at;
input [127:0] line;
input [3:0]   c;
begin
    char_at = line[127 - 8*c -: 8];
end
endfunction

// ------------------------------------------------------------------
// instruction / data output, once per slot
// {LCD_RS, LCD_RW, LCD_DATA} = {RS, RW, DB[7:0]}
//   RS = 0, RW = 0 : write instruction
//   RS = 1, RW = 0 : write data (character code) to DD-RAM
// ------------------------------------------------------------------
always @(posedge clk or negedge rst)
begin
    if(!rst)
        {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_1_0000_0000;    // RW = 1: nothing is written
    else if(slot_start) begin
        case(state)
            FUNCTION_SET :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0011_1000;
                // DB = 0 0 1 DL N F x x
                // DL = 1 => 8 bit data, N = 1 => 2 lines, F = 0 => 5 x 8 dots
            DISP_ONOFF :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_1100;
                // DB = 0 0 0 0 1 D C B
                // D = 1 => display on, C = 0 => cursor off, B = 0 => blink off
            ENTRY_MODE :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_0000_0110;
                // DB = 0 0 0 0 0 1 I/D S
                // I/D = 1 => address +1 after each write, S = 0 => no display shift
            LINE1 :
                if(cnt == 0)
                    {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_1000_0000;            // set DD-RAM addr 0x00
                else
                    {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, char_at(line1, cnt - 1)}; // char cnt-1 (addr auto +1)
            LINE2 :
                if(cnt == 0)
                    {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_1100_0000;            // set DD-RAM addr 0x40
                else
                    {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, char_at(line2, cnt - 1)};
            default :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_1_0000_0000;
                // DELAY state: RW = 1, nothing is written during the power-on wait
        endcase
    end
end

endmodule
