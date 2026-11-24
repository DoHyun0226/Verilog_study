`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: lamp_pattern
// Description: state letter (A ~ H) -> 24-bit lamp pattern of the lab figures
//
//   Pure combinational lookup table. traffic_ctrl uses two of these:
//   one for the state shown now ("from") and one for the state that comes
//   next ("to"), so it can build the yellow and blinking patterns.
//
//   The table is the same as ST_A ~ ST_H in Test_Lamp_Button.v of
//   WEEK_Fianl_Project/Final_Project_Test_Lamp_Button, which were checked on
//   the board on 2026-11-17. If one changes, change the other too.
//
//   Lights are named by the compass printed on the module board
//   (North = top of the lab figures). common.xdc maps the names to pins.
//
//   24-bit lamp vector layout (vehicle high, pedestrian low; E > W > S > N):
//     [23:20] East  vehicle   [19:16] West  vehicle
//     [15:12] South vehicle   [11: 8] North vehicle
//     [ 7: 6] East  walk      [ 5: 4] West  walk
//     [ 3: 2] South walk      [ 1: 0] North walk
//
//   Vehicle light nibble  : {RED, YELLOW, GREEN, LEFT}
//   Pedestrian light pair : {RED, GREEN}
//////////////////////////////////////////////////////////////////////////////////


// letter : 0 = A, 1 = B, ... 7 = H
// lamp   : 24 lamps, 1 = on
module lamp_pattern(letter, lamp);

input  [2:0]  letter;
output reg [23:0] lamp;

// vehicle light nibbles {RED, YELLOW, GREEN, LEFT}
localparam [3:0] V_R  = 4'b1000,    // red
                 V_G  = 4'b0010,    // green (straight)
                 V_L  = 4'b0001,    // left arrow only
                 V_GL = 4'b0011;    // green + left arrow

// pedestrian light pairs {RED, GREEN}
localparam [1:0] P_R  = 2'b10,      // walk red
                 P_G  = 2'b01;      // walk green

always @(*)
begin
    case(letter)
        //                      E_veh W_veh S_veh N_veh  E_wk W_wk S_wk N_wk
        3'd0 : lamp = { V_R,  V_R,  V_G,  V_G,   P_G, P_G, P_R, P_R };   // A: N/S straight, E/W walk
        3'd1 : lamp = { V_R,  V_R,  V_R,  V_GL,  P_G, P_R, P_R, P_R };   // B: North straight + left
        3'd2 : lamp = { V_R,  V_R,  V_GL, V_R,   P_R, P_G, P_R, P_R };   // C: South straight + left
        3'd3 : lamp = { V_R,  V_R,  V_L,  V_L,   P_R, P_R, P_R, P_R };   // D: N/S left turn
        3'd4 : lamp = { V_G,  V_G,  V_R,  V_R,   P_R, P_R, P_G, P_G };   // E: E/W straight, N/S walk
        3'd5 : lamp = { V_R,  V_GL, V_R,  V_R,   P_R, P_R, P_R, P_G };   // F: West straight + left
        3'd6 : lamp = { V_GL, V_R,  V_R,  V_R,   P_R, P_R, P_G, P_R };   // G: East straight + left
        default : lamp = { V_L,  V_L,  V_R,  V_R,   P_R, P_R, P_R, P_R }; // H: E/W left turn
    endcase
end

endmodule
