`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2026/11/06 12:00:00
// Design Name:
// Module Name: LCD_display
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Week 10 (DAC) - shows the DAC digital input on the 16 x 2 text LCD
//
// Dependencies: bin2bcd.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   Screen (e.g. bin = 173 = 0xAD, a_b = 0):
//     line 1 : "DEC:173  HEX:AD "
//     line 2 : "BIN:10101101 [A]"     [A] = VOUTA, [B] = VOUTB
//
//   Same control method as the WEEK_8 text_LCD_basic example: LCD_E = clk, so
//   one LCD write per clock, and one state per LCD instruction.
//
//   State flow:
//     DELAY -> FUNCTION_SET -> DISP_ONOFF -> ENTRY_MODE   (once after reset)
//     -> LINE1 -> LINE2 -> LINE1 -> LINE2 ...             (repeated)
//
//   LINE1 / LINE2 rewrite all 16 characters of the line every loop, so the
//   screen follows bin without Clear Display (no flicker). One loop is
//   34 clocks = 34 ms at 1 kHz.
//
//   Clock: ~1 kHz, same as WEEK_8 / WEEK_9. 50 MHz is far too fast for the LCD.
//////////////////////////////////////////////////////////////////////////////////


// rst      : active-low reset
// clk      : system clock (also used directly as LCD_E)
// bin      : value to display (DAC digital input, 0 ~ 255)
// a_b      : DAC output select to display, 0 = A (VOUTA), 1 = B (VOUTB)
// LCD_E    : enable, LCD latches RS/RW/DATA on the falling edge
// LCD_RS   : register select, 0 = instruction, 1 = data (character)
// LCD_RW   : 0 = write to LCD, 1 = read from LCD
// LCD_DATA : DB[7:0], instruction code or character code
module LCD_display(rst, clk, bin, a_b, LCD_E, LCD_RS, LCD_RW, LCD_DATA);

input rst, clk;
input [7:0] bin;
input a_b;

output LCD_E, LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;

wire LCD_E;
reg LCD_RS, LCD_RW;

wire [11:0] bcd;    // {hundreds, tens, ones} of bin

// binary -> BCD (bin2bcd uses an active-high reset)
bin2bcd b1(clk, ~rst, bin, bcd);

// one state per LCD instruction
reg [2:0] state;
parameter DELAY        = 3'b000,    // wait for LCD power-on reset
          FUNCTION_SET = 3'b001,    // data length / number of lines
          DISP_ONOFF   = 3'b010,    // display, cursor, blink on/off
          ENTRY_MODE   = 3'b011,    // cursor move direction / display shift
          LINE1        = 3'b100,    // write line 1 (address 0x00~0x0F)
          LINE2        = 3'b101;    // write line 2 (address 0x40~0x4F)

// cnt limit of each state: the state lasts (limit + 1) clocks
// LINE1 / LINE2: cnt 0 = address set, cnt 1~16 = 16 characters (columns 0~15)
parameter DELAY_CNT        = 70,
          FUNCTION_SET_CNT = 30,
          DISP_ONOFF_CNT   = 30,
          ENTRY_MODE_CNT   = 30,
          LINE1_CNT        = 16,
          LINE2_CNT        = 16;

// clock counter inside the current state (0 ~ limit)
reg [7:0] cnt;

// ASCII code of one hex digit: 0~9 -> '0'~'9' (0x30~0x39), 10~15 -> 'A'~'F' (0x41~0x46)
function [7:0] hex_ascii;
input [3:0] h;
begin
    if(h < 10) hex_ascii = 8'h30 + h;
    else       hex_ascii = 8'h37 + h;   // 0x37 + 10 = 0x41 = 'A'
end
endfunction

// ASCII code of one bit: 0 -> '0' (0x30), 1 -> '1' (0x31)
function [7:0] bit_ascii;
input b;
begin
    bit_ascii = {7'b0011_000, b};
end
endfunction

// state transition
always @(posedge clk or negedge rst)
begin
    if(!rst)
        state <= DELAY;
    else begin
        case(state)
            DELAY        : if(cnt == DELAY_CNT) state <= FUNCTION_SET;
            FUNCTION_SET : if(cnt == FUNCTION_SET_CNT) state <= DISP_ONOFF;
            DISP_ONOFF   : if(cnt == DISP_ONOFF_CNT) state <= ENTRY_MODE;
            ENTRY_MODE   : if(cnt == ENTRY_MODE_CNT) state <= LINE1;
            LINE1        : if(cnt == LINE1_CNT) state <= LINE2;
            LINE2        : if(cnt == LINE2_CNT) state <= LINE1;    // back to LINE1, init states are skipped
            default      : state <= DELAY;
        endcase
    end
end

// cnt: +1 every clock, cleared when the state's limit is reached
// (limits must match the ones in the state transition block)
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
            LINE1 :
                if(cnt >= LINE1_CNT) cnt <= 0;
                else cnt <= cnt + 1;
            LINE2 :
                if(cnt >= LINE2_CNT) cnt <= 0;
                else cnt <= cnt + 1;
            default : cnt <= 0;
        endcase
    end
end

// instruction / data output for each state
// {LCD_RS, LCD_RW, LCD_DATA} = {RS, RW, DB[7:0]}
//   RS = 0, RW = 0 : write instruction
//   RS = 1, RW = 0 : write data (character code) to DD-RAM
always @(posedge clk or negedge rst)
begin
    if(!rst)
        {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_1_0000_0000;    // RW = 1: nothing is written
    else begin
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
                // "DEC:173  HEX:AD "
                case(cnt)
                    00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_1000_0000;            // set addr 0x00 | instr 0x80
                    01 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, 8'h44};               // addr 0x00 | D
                    02 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, 8'h45};               // addr 0x01 | E
                    03 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, 8'h43};               // addr 0x02 | C
                    04 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, 8'h3A};               // addr 0x03 | :
                    05 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, hex_ascii(bcd[11:8])}; // addr 0x04 | hundreds
                    06 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, hex_ascii(bcd[7:4])};  // addr 0x05 | tens
                    07 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, hex_ascii(bcd[3:0])};  // addr 0x06 | ones
                    08 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, 8'h20};               // addr 0x07 | (space)
                    09 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, 8'h20};               // addr 0x08 | (space)
                    10 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, 8'h48};               // addr 0x09 | H
                    11 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, 8'h45};               // addr 0x0A | E
                    12 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, 8'h58};               // addr 0x0B | X
                    13 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, 8'h3A};               // addr 0x0C | :
                    14 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, hex_ascii(bin[7:4])};  // addr 0x0D | upper hex digit
                    15 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, hex_ascii(bin[3:0])};  // addr 0x0E | lower hex digit
                    default : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, 8'h20};          // addr 0x0F | (space)
                endcase
            LINE2 :
                // "BIN:10101101 [A]"
                case(cnt)
                    00 : {LCD_RS, LCD_RW, LCD_DATA} <= 10'b0_0_1100_0000;            // set addr 0x40 | instr 0xC0
                    01 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, 8'h42};               // addr 0x40 | B
                    02 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, 8'h49};               // addr 0x41 | I
                    03 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, 8'h4E};               // addr 0x42 | N
                    04 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, 8'h3A};               // addr 0x43 | :
                    05 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, bit_ascii(bin[7])};   // addr 0x44 | D7 (MSB)
                    06 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, bit_ascii(bin[6])};   // addr 0x45 | D6
                    07 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, bit_ascii(bin[5])};   // addr 0x46 | D5
                    08 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, bit_ascii(bin[4])};   // addr 0x47 | D4
                    09 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, bit_ascii(bin[3])};   // addr 0x48 | D3
                    10 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, bit_ascii(bin[2])};   // addr 0x49 | D2
                    11 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, bit_ascii(bin[1])};   // addr 0x4A | D1
                    12 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, bit_ascii(bin[0])};   // addr 0x4B | D0 (LSB)
                    13 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, 8'h20};               // addr 0x4C | (space)
                    14 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, 8'h5B};               // addr 0x4D | [
                    15 : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, a_b ? 8'h42 : 8'h41}; // addr 0x4E | B or A
                    default : {LCD_RS, LCD_RW, LCD_DATA} <= {2'b10, 8'h5D};          // addr 0x4F | ]
                endcase
            default :
                {LCD_RS, LCD_RW, LCD_DATA} <= 10'b1_1_0000_0000;
                // DELAY state: RW = 1, nothing is written during the power-on wait
        endcase
    end
end

// LCD enable driven directly by the clock (one write per clock)
assign LCD_E = clk;

endmodule
