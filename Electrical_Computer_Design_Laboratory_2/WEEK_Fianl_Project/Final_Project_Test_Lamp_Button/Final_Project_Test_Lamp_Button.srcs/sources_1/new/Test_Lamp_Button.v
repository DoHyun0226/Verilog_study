`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2026/11/24 14:25:06
// Design Name:
// Module Name: Test_Lamp_Button
// Project Name: Final project - traffic lights module lamp test
// Target Devices: xc7s75fgga484-1 (Combo II-DLD + traffic lights module)
// Tool Versions: Vivado 2025.2.1
// Description: board test of the 24 lamps, SM_1 ~ SM_8 show states A ~ H
//
// Dependencies: oneshot_trigger.v
//               constraints: common.xdc + test_lamp_btn.xdc
//
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Moved here from the TEST_LAMP_BTN build of Final_Project main.v
// Additional Comments:
//
//   SW1        : reset, active low (SW1 off -> all lamps off)
//   SM_1 ~ SM_8: show state A ~ H of the lab figures
//                (no press or two buttons at once: keep the lamps)
//
//   The table ST_A ~ ST_H below is the same as lamp_pattern.v of
//   Final_Project. It was checked on the board on 2026-11-17.
//   If one changes, change the other too.
//
//////////////////////////////////////////////////////////////////////////////////


module Test_Lamp_Button(
    input clk,
    input rst,
    // btn[0]: button 1 (SM_1) ... btn[7]: button 8 (SM_8)
    input [7:0] btn,
    output reg [23:0] state         // 24 lamps, 1 = on
);
    // ------------------------------------------------------------------
    // Lamp patterns
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
    parameter  [3:0] V_R  = 4'b1000,    // red
                     V_Y  = 4'b0100,    // yellow
                     V_G  = 4'b0010,    // green
                     V_L  = 4'b0001,    // left arrow only
                     V_GL = 4'b0011;    // green + left arrow

    parameter  [1:0] P_R  = 2'b10,      // walk red
                     P_G  = 2'b01;      // walk green

    //                         E_veh W_veh S_veh N_veh  E_wk W_wk S_wk N_wk
    parameter  [23:0] ST_A = { V_R,  V_R,  V_G,  V_G,   P_G, P_G, P_R, P_R };
    parameter  [23:0] ST_B = { V_R,  V_R,  V_R,  V_GL,  P_G, P_R, P_R, P_R };
    parameter  [23:0] ST_C = { V_R,  V_R,  V_GL, V_R,   P_R, P_G, P_R, P_R };
    parameter  [23:0] ST_D = { V_R,  V_R,  V_L,  V_L,   P_R, P_R, P_R, P_R };
    parameter  [23:0] ST_E = { V_G,  V_G,  V_R,  V_R,   P_R, P_R, P_G, P_G };
    parameter  [23:0] ST_F = { V_R,  V_GL, V_R,  V_R,   P_R, P_R, P_R, P_G };
    parameter  [23:0] ST_G = { V_GL, V_R,  V_R,  V_R,   P_R, P_R, P_G, P_R };
    parameter  [23:0] ST_H = { V_L,  V_L,  V_R,  V_R,   P_R, P_R, P_R, P_R };
    parameter  [23:0] ST_default = 0;

    // ------------------------------------------------------------------
    // Buttons
    // ------------------------------------------------------------------
    parameter [7:0] btn_1 = 8'b00000001;
    parameter [7:0] btn_2 = 8'b00000010;
    parameter [7:0] btn_3 = 8'b00000100;
    parameter [7:0] btn_4 = 8'b00001000;
    parameter [7:0] btn_5 = 8'b00010000;
    parameter [7:0] btn_6 = 8'b00100000;
    parameter [7:0] btn_7 = 8'b01000000;
    parameter [7:0] btn_8 = 8'b10000000;

    wire [7:0] btn_trig;    // one clock pulse per press
    oneshot_universal #(.WIDTH(8)) O_TEST_LAMP_BTN(.clk(clk), .rst(rst), .btn(btn), .btn_trig(btn_trig));

    always @(posedge clk, negedge rst)
    begin
        if(!rst)
            state <= ST_default;
        else
        begin
            case (btn_trig)
                btn_1: state <= ST_A;
                btn_2: state <= ST_B;
                btn_3: state <= ST_C;
                btn_4: state <= ST_D;
                btn_5: state <= ST_E;
                btn_6: state <= ST_F;
                btn_7: state <= ST_G;
                btn_8: state <= ST_H;
                default: state <= state;    // no press or multiple presses: hold
            endcase
        end
    end
endmodule
