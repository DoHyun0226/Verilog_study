`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2026/11/17 14:07:05
// Design Name:
// Module Name: main
// Project Name: Final project - 4-way traffic light controller
// Target Devices: xc7s75fgga484-1 (Combo II-DLD + traffic lights module)
// Tool Versions: Vivado 2025.2.1
// Description: top module
//
// Dependencies: btn_debounce.v, oneshot_trigger.v, time_keeper.v,
//               traffic_ctrl.v, lamp_pattern.v, lcd_driver.v
//               constraints: common.xdc + test_main.xdc
//
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - TEST_MAIN build (day/night sequences, LCD, emergency mode)
// Revision 0.03 - TEST_LAMP_BTN build moved to its own project
//                 (WEEK_Fianl_Project/Final_Project_Test_Lamp_Button),
//                 so the `define build switch is gone
// Additional Comments:
//
//   ===== Board controls =======================================================
//     SW1        : reset, active low (SW1 off -> reset: lamps off, time = 00:00:00)
//     SW3 SW2    : clock speed-up  00 = x1, 01 = x10, 10 = x100, 11 = x200
//     SM_1       : +1 hour
//     SM_2       : emergency vehicle (South -> North)
//
//   ===== What it does =========================================================
//     Day   (08:00 ~ 23:00) : A -> D -> F -> E -> G -> E   5 s each
//     Night (23:00 ~ 08:00) : B -> A -> C -> A -> E -> H  10 s each
//     - 1 s yellow between two states (after the 5 / 10 s)
//     - pedestrian greens that turn red next blink in the second half
//     - day / night is checked when a state ends; a change starts the
//       other sequence from its first state
//     - emergency button: 1 s (yellow) later state A for 15 s, 1 s yellow,
//       then the state that was running restarts with its full time
//     - the signal times are real time; the speed-up only changes the clock
//
//     LCD line 1 : "Time : 11:48:32 "
//     LCD line 2 : "State: A (night)"    normal
//                  "EMG  : A (night)"    emergency mode
//                  (16 characters per line, so "State : A (night)" of the
//                   lab example is written without the space before ':')
//                  (day) / (night) follows the clock.
//
//   ===== Block diagram ========================================================
//
//     btn_hour -> btn_debounce -+-> oneshot -+-> hour_inc -> time_keeper --> hour, min, sec -+
//     btn_emg  -> btn_debounce -+            |                ^    |                        |
//     scale_sel (SW3 SW2) -> 2-FF sync ------|----------------+    | is_day                 |
//                                            |                     v                        |
//                                            +-> emg_btn ----> traffic_ctrl --> state[23:0] (24 lamps)
//                                                                  |                        |
//                                                 disp_letter, emg_active                   |
//                                                                  v                        v
//                                                            line2 text               line1 text
//                                                                  +--> lcd_driver <--------+
//                                                                           |
//                                                              LCD_E, LCD_RS, LCD_RW, LCD_DATA
//
//////////////////////////////////////////////////////////////////////////////////


module main(
    input clk,
    input rst,
    input [1:0] scale_sel,          // SW3 SW2: 0 = x1, 1 = x10, 2 = x100, 3 = x200
    input btn_hour,                 // SM_1: +1 hour
    input btn_emg,                  // SM_2: emergency vehicle
    output LCD_E,                   // text LCD enable
    output LCD_RS,                  // text LCD register select
    output LCD_RW,                  // text LCD read / write
    output [7:0] LCD_DATA,          // text LCD DB[7:0]
    output [23:0] state             // 24 lamps, driven by traffic_ctrl
);
    // ------------------------------------------------------------------
    // Settings (the testbench overrides them: main #(.CLK_HZ(1000), ...))
    //   Declared here and not in a #( ) list on the module line: with a
    //   #( ) list, Verilog turns every parameter below into a localparam.
    // ------------------------------------------------------------------
    parameter CLK_HZ    = 50_000_000;   // B6 clock frequency [Hz]
    parameter INIT_HOUR = 0;            // clock value after reset
    parameter INIT_MIN  = 0;
    parameter INIT_SEC  = 0;

    // ------------------------------------------------------------------
    // Lamp output state[23:0]
    //   The patterns of states A ~ H are in lamp_pattern.v (used by traffic_ctrl).
    //   Lights are named by the compass printed on the module board
    //   (same as the state figures of the lab: North = top of the figure).
    //   The pin-table direction names differ; common.xdc does the remapping.
    //
    //   Vehicle light nibble    : {RED, YELLOW, GREEN, LEFT}
    //   Pedestrian light pair   : {RED, GREEN}  (both lamps of a crosswalk share one pin pair)
    //
    //   24-bit lamp vector layout (vehicle high, pedestrian low; E > W > S > N):
    //     [23:20] East  vehicle   [19:16] West  vehicle
    //     [15:12] South vehicle   [11: 8] North vehicle
    //     [ 7: 6] East  walk      [ 5: 4] West  walk
    //     [ 3: 2] South walk      [ 1: 0] North walk
    // ------------------------------------------------------------------

    // ---- DIP switches: 2-FF synchronizer -----------------------------
    // The switches are not related to clk. Two flip-flops make sure that
    // time_keeper sees a clean value (a switch can change at any moment).
    reg [1:0] scale_s1, scale_s2;
    always @(posedge clk or negedge rst)
    begin
        if(!rst) begin
            scale_s1 <= 2'b00;
            scale_s2 <= 2'b00;
        end
        else begin
            scale_s1 <= scale_sel;
            scale_s2 <= scale_s1;
        end
    end

    // ---- buttons: debounce -> one clock pulse per press --------------
    //   btn_debounce : 50 MHz sees every bounce of the contact, so the
    //                  level is accepted only after 10 ms without change
    //   oneshot      : 1 clock pulse at the press (rising edge of the level)
    wire hour_db, emg_db;       // clean button levels
    btn_debounce #(.CLK_HZ(CLK_HZ)) DB_HOUR(.clk(clk), .rst(rst), .btn(btn_hour), .btn_db(hour_db));
    btn_debounce #(.CLK_HZ(CLK_HZ)) DB_EMG (.clk(clk), .rst(rst), .btn(btn_emg),  .btn_db(emg_db));

    wire [1:0] main_trig;       // [1] = +1 hour, [0] = emergency
    oneshot_universal #(.WIDTH(2)) O_MAIN(.clk(clk), .rst(rst), .btn({hour_db, emg_db}), .btn_trig(main_trig));

    wire hour_inc = main_trig[1];
    wire emg_btn  = main_trig[0];

    // ---- traffic light time (hh:mm:ss) -------------------------------
    wire [4:0] hour;
    wire [5:0] min, sec;
    wire       is_day;          // 1 = 08:00 ~ 23:00
    time_keeper #(.CLK_HZ(CLK_HZ), .INIT_HOUR(INIT_HOUR), .INIT_MIN(INIT_MIN), .INIT_SEC(INIT_SEC))
        TK(.clk(clk), .rst(rst), .scale_sel(scale_s2), .hour_inc(hour_inc),
           .hour(hour), .min(min), .sec(sec), .is_day(is_day));

    // ---- traffic lights ----------------------------------------------
    wire [2:0] disp_letter;     // state shown on the LCD, 0 = A ... 7 = H
    wire       emg_active;      // 1 = emergency mode
    traffic_ctrl #(.CLK_HZ(CLK_HZ))
        TC(.clk(clk), .rst(rst), .is_day(is_day), .emg_btn(emg_btn),
           .lamp(state), .disp_letter(disp_letter), .emg_active(emg_active));

    // ---- LCD text ----------------------------------------------------
    // ASCII code of a decimal digit 0 ~ 9: '0' = 0x30
    function [7:0] dec_ascii;
    input [3:0] d;
    begin
        dec_ascii = 8'h30 + d;
    end
    endfunction

    // line 1 : "Time : hh:mm:ss "   (7 + 8 + 1 = 16 characters)
    wire [127:0] line1 = { "Time : ",
                           dec_ascii(hour / 10), dec_ascii(hour % 10), ":",
                           dec_ascii(min  / 10), dec_ascii(min  % 10), ":",
                           dec_ascii(sec  / 10), dec_ascii(sec  % 10), " " };

    // line 2 : "State: A (night)"   (5 + 2 + 1 + 1 + 7 = 16 characters)
    //          "EMG  : A (day)  "   during the emergency mode
    wire [7:0] letter_ascii = 8'h41 + disp_letter;     // 'A' = 0x41, 'B' = 0x42, ...
    wire [127:0] line2 = { (emg_active ? "EMG  " : "State"),
                           ": ",
                           letter_ascii,
                           " ",
                           (is_day ? "(day)  " : "(night)") };

    lcd_driver #(.CLK_HZ(CLK_HZ))
        LCD(.clk(clk), .rst(rst), .line1(line1), .line2(line2),
            .LCD_E(LCD_E), .LCD_RS(LCD_RS), .LCD_RW(LCD_RW), .LCD_DATA(LCD_DATA));
endmodule


