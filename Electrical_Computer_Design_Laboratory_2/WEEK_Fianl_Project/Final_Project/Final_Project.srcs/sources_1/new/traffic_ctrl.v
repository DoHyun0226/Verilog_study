`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: traffic_ctrl
// Description: traffic light state machine (day / night sequences, yellow,
//              pedestrian blinking, emergency vehicle mode)
//
// Dependencies: lamp_pattern.v
//
// ==============================================================================
//  1. Sequences
// ==============================================================================
//   day   (08:00 ~ 23:00) : A -> D -> F -> E -> G -> E -> (A ...)   5 s each
//   night (23:00 ~ 08:00) : B -> A -> C -> A -> E -> H -> (B ...)  10 s each
//
//   The running sequence is (seq_night, idx):
//     seq_night = 0 : day sequence,  1 : night sequence
//     idx       = position in the sequence, 0 ~ 5
//   seq_letter(seq_night, idx) gives the state letter (A = 0 ... H = 7).
//
//   Day / night change: is_day (from the clock) is checked only when the
//   current state (plus its yellow) ends. If the clock moved into the other
//   period, the next state is the FIRST state of the other sequence
//   (day -> night: B, night -> day: A). Otherwise idx just goes +1.
//
// ==============================================================================
//  2. Phases (the FSM register "phase")
// ==============================================================================
//
//      reset
//        |
//        v
//    P_START --(1 clock: pick day/night sequence from the clock)--+
//                                                                 |
//        +--------------------------------------------------------+
//        v
//    +--------+  state time over   +--------+  1 s over
//    | P_RUN  | -----------------> | P_YEL  | ---------> P_RUN (next state)
//    | 5/10 s |                    |  1 s   |
//    +--------+                    +--------+
//        |  emergency button            |  emergency button
//        +----------------+-------------+
//                         v
//                    +---------+  1 s   +-------+  15 s  +---------+  1 s
//                    | P_EMG_Y | -----> | P_EMG | -----> | P_RET_Y | ----> P_RUN
//                    |  1 s    |        |  A    |        |  1 s    |   (same state as
//                    +---------+        +-------+        +---------+    before, timer
//                    yellow to A        state A          yellow back    restarted)
//
//   P_RUN   : shows the current state. Pedestrian greens that turn red in the
//             next state blink in the second half of the state time.
//   P_YEL   : 1 s yellow between two states (added after the 5 / 10 s).
//   P_EMG_Y : the "1 second after the button" of the emergency rule; it is a
//             yellow from the current state to state A.
//   P_EMG   : emergency vehicle South -> North: state A for 15 s.
//   P_RET_Y : 1 s yellow from A back to the original state.
//             seq_night / idx are not touched during the emergency, so after
//             P_RET_Y the original state runs again with a fresh 5 / 10 s.
//             The clock (time_keeper) is independent and never stops.
//
//   The button is accepted in P_RUN and P_YEL only. Pressing it again while
//   the emergency is already running does nothing.
//
// ==============================================================================
//  3. Timer (real time, NOT affected by the clock speed-up scale)
// ==============================================================================
//   div_cnt  : counts clocks 0 ~ HALF_CYC-1 (HALF_CYC = 0.5 s of clocks)
//   half_cnt : number of 0.5 s steps elapsed in the current phase
//   Both are cleared whenever a phase starts (also when the emergency
//   button is accepted, so "1 s after the button" is exact).
//   A phase ends at the last clock of its last 0.5 s step (phase_done).
//
//   Phase length in 0.5 s steps: day state 10, night state 20,
//   yellow 2, emergency A 30.
//
// ==============================================================================
//  4. Lamp output
// ==============================================================================
//   from_pat = pattern of the state shown now
//   to_pat   = pattern of the state that comes next
//
//   Yellow (P_YEL, P_EMG_Y, P_RET_Y), for each vehicle light:
//     RED    : stays as in from_pat (a red light stays red until its green)
//     YELLOW : on if a green or left lamp is on now and off in the next state
//     GREEN / LEFT : only lamps that are on in BOTH states stay on
//     e.g. A -> D, North : green -> (yellow) -> left arrow
//          B -> A, North : green+left -> (green+yellow) -> green
//          E -> G, East  : green -> (green, no yellow) -> green+left
//   Yellow, for each pedestrian light:
//     green only if it is green now AND in the next state, otherwise red
//
//   P_RUN / P_EMG, pedestrian light that is green now and red next:
//     first half of the phase : green
//     second half             : blinks, 0.5 s off / 0.5 s on (red stays off)
//   A pedestrian green that stays green in the next state does not blink.
//////////////////////////////////////////////////////////////////////////////////


// clk        : system clock
// rst        : active-low reset (all lamps off)
// is_day     : 1 = clock is in 08:00 ~ 23:00 (from time_keeper)
// emg_btn    : one clock pulse = emergency button pressed
// lamp       : 24 lamps to the traffic module (layout: see lamp_pattern.v)
// disp_letter: state letter for the LCD (0 = A ... 7 = H)
// emg_active : 1 while the emergency mode (P_EMG_Y, P_EMG, P_RET_Y) runs
module traffic_ctrl(clk, rst, is_day, emg_btn, lamp, disp_letter, emg_active);

parameter CLK_HZ = 50_000_000;      // clock frequency

input clk, rst;
input is_day;
input emg_btn;
output reg [23:0] lamp;
output [2:0] disp_letter;
output emg_active;

// ------------------------------------------------------------------
// constants
// ------------------------------------------------------------------
localparam HALF_CYC = (CLK_HZ / 2 > 0) ? CLK_HZ / 2 : 1;   // clocks in 0.5 s

// phase length in 0.5 s steps
localparam [4:0] DAY_STEPS   = 5'd10,   //  5 s
                 NIGHT_STEPS = 5'd20,   // 10 s
                 YEL_STEPS   = 5'd2,    //  1 s
                 EMG_STEPS   = 5'd30;   // 15 s

// phases
localparam [2:0] P_START = 3'd0,
                 P_RUN   = 3'd1,
                 P_YEL   = 3'd2,
                 P_EMG_Y = 3'd3,
                 P_EMG   = 3'd4,
                 P_RET_Y = 3'd5;

// state letters
localparam [2:0] L_A = 3'd0, L_B = 3'd1, L_C = 3'd2, L_D = 3'd3,
                 L_E = 3'd4, L_F = 3'd5, L_G = 3'd6, L_H = 3'd7;

localparam [1:0] P_G = 2'b01,   // pedestrian pair {RED, GREEN} = green
                 P_R = 2'b10;   //                              = red

// ------------------------------------------------------------------
// sequence tables
// ------------------------------------------------------------------
// day   : idx 0~5 = A D F E G E
// night : idx 0~5 = B A C A E H
function [2:0] seq_letter;
input       night;
input [2:0] i;
begin
    if(!night)
        case(i)
            3'd0 : seq_letter = L_A;
            3'd1 : seq_letter = L_D;
            3'd2 : seq_letter = L_F;
            3'd3 : seq_letter = L_E;
            3'd4 : seq_letter = L_G;
            default : seq_letter = L_E;
        endcase
    else
        case(i)
            3'd0 : seq_letter = L_B;
            3'd1 : seq_letter = L_A;
            3'd2 : seq_letter = L_C;
            3'd3 : seq_letter = L_A;
            3'd4 : seq_letter = L_E;
            default : seq_letter = L_H;
        endcase
end
endfunction

// ------------------------------------------------------------------
// registers
// ------------------------------------------------------------------
reg [2:0]  phase;
reg        seq_night;   // running sequence: 0 = day, 1 = night
reg [2:0]  idx;         // position in the running sequence
reg        nxt_night;   // next state, latched when P_RUN ends
reg [2:0]  nxt_idx;     //   (so a clock change during the yellow does not change it)
reg [31:0] div_cnt;     // clocks inside the current 0.5 s step
reg [4:0]  half_cnt;    // 0.5 s steps elapsed in the current phase

// ------------------------------------------------------------------
// timer signals
// ------------------------------------------------------------------
reg [4:0] phase_len;    // length of the current phase in 0.5 s steps
always @(*)
begin
    case(phase)
        P_RUN   : phase_len = seq_night ? NIGHT_STEPS : DAY_STEPS;
        P_EMG   : phase_len = EMG_STEPS;
        default : phase_len = YEL_STEPS;    // P_YEL, P_EMG_Y, P_RET_Y (P_START is 1 clock)
    endcase
end

wire half_tick  = (div_cnt == HALF_CYC - 1);                    // last clock of a 0.5 s step
wire phase_done = half_tick && (half_cnt == phase_len - 1);     // last clock of the phase

// emergency button is accepted only in the normal phases
wire emg_accept = emg_btn && (phase == P_RUN || phase == P_YEL);

// ------------------------------------------------------------------
// next state of the sequence, computed live from the clock
// ------------------------------------------------------------------
//   live_night : sequence the clock asks for now (night = not day)
//   live_idx   : if that is the running sequence -> idx + 1 (5 wraps to 0)
//                if it is the other one          -> 0 (start of the other sequence)
wire       live_night = ~is_day;
wire [2:0] live_idx   = (live_night != seq_night) ? 3'd0 :
                        (idx == 3'd5)             ? 3'd0 : idx + 3'd1;

wire [2:0] cur_letter = seq_letter(seq_night, idx);

// ------------------------------------------------------------------
// main FSM + timer
// ------------------------------------------------------------------
always @(posedge clk or negedge rst)
begin
    if(!rst) begin
        phase     <= P_START;
        seq_night <= 1'b1;
        idx       <= 3'd0;
        nxt_night <= 1'b1;
        nxt_idx   <= 3'd0;
        div_cnt   <= 0;
        half_cnt  <= 0;
    end
    else begin
        // ---- timer: restart at every phase change, else count ----
        if(phase == P_START || phase_done || emg_accept) begin
            div_cnt  <= 0;
            half_cnt <= 0;
        end
        else if(half_tick) begin
            div_cnt  <= 0;
            half_cnt <= half_cnt + 1;
        end
        else
            div_cnt <= div_cnt + 1;

        // ---- phase transitions ----
        case(phase)
            P_START : begin
                // first clock after reset: start the sequence of the current time
                seq_night <= ~is_day;
                idx       <= 3'd0;
                phase     <= P_RUN;
            end
            P_RUN : begin
                if(emg_accept)
                    phase <= P_EMG_Y;
                else if(phase_done) begin
                    nxt_night <= live_night;    // remember where to go after the yellow
                    nxt_idx   <= live_idx;
                    phase     <= P_YEL;
                end
            end
            P_YEL : begin
                if(emg_accept)
                    phase <= P_EMG_Y;           // original state = the one still shown (cur)
                else if(phase_done) begin
                    seq_night <= nxt_night;     // move to the next state
                    idx       <= nxt_idx;
                    phase     <= P_RUN;
                end
            end
            P_EMG_Y : if(phase_done) phase <= P_EMG;
            P_EMG   : if(phase_done) phase <= P_RET_Y;
            P_RET_Y : if(phase_done) phase <= P_RUN;   // seq_night / idx unchanged = original state
            default : phase <= P_START;
        endcase
    end
end

// ------------------------------------------------------------------
// which two states the lamps are made from
// ------------------------------------------------------------------
reg [2:0] from_letter, to_letter;
always @(*)
begin
    case(phase)
        P_RUN   : begin from_letter = cur_letter; to_letter = seq_letter(live_night, live_idx); end
        P_YEL   : begin from_letter = cur_letter; to_letter = seq_letter(nxt_night, nxt_idx);   end
        P_EMG_Y : begin from_letter = cur_letter; to_letter = L_A;                              end
        P_EMG   : begin from_letter = L_A;        to_letter = cur_letter;                       end
        P_RET_Y : begin from_letter = L_A;        to_letter = cur_letter;                       end
        default : begin from_letter = L_A;        to_letter = L_A;                              end
    endcase
end

wire [23:0] from_pat, to_pat;
lamp_pattern LP_FROM(.letter(from_letter), .lamp(from_pat));
lamp_pattern LP_TO  (.letter(to_letter),   .lamp(to_pat));

// ------------------------------------------------------------------
// lamp mixing
// ------------------------------------------------------------------
wire is_yellow_phase = (phase == P_YEL) || (phase == P_EMG_Y) || (phase == P_RET_Y);

// pedestrian blinking: second half of P_RUN / P_EMG
wire [4:0] half_point = phase_len >> 1;             // 5 (day), 10 (night), 15 (emergency)
wire       blink_zone = (half_cnt >= half_point);
wire [4:0] blink_step = half_cnt - half_point;      // 0, 1, 2, ... inside the second half
wire       blink_on   = blink_step[0];              // off, on, off, on ... every 0.5 s

// vehicle light during yellow: {RED, YELLOW, GREEN, LEFT}
function [3:0] veh_yellow;
input [3:0] f;      // now
input [3:0] t;      // next
begin
    veh_yellow = { f[3],                        // red stays red
                   |(f[1:0] & ~t[1:0]),         // a green / left lamp goes off -> yellow
                   f[1:0] & t[1:0] };           // green / left kept in both states
end
endfunction

// pedestrian light during yellow: {RED, GREEN}
function [1:0] ped_yellow;
input [1:0] f;
input [1:0] t;
begin
    ped_yellow = (f == P_G && t == P_G) ? P_G : P_R;
end
endfunction

// pedestrian light during P_RUN / P_EMG
function [1:0] ped_run;
input [1:0] f;
input [1:0] t;
input zone;         // second half of the phase
input on;           // blink phase
begin
    if(f == P_G && t != P_G && zone)
        ped_run = {1'b0, on};           // green blinking, red off
    else
        ped_run = f;
end
endfunction

reg [23:0] lamp_next;
integer i;
always @(*)
begin
    lamp_next = 24'd0;
    if(phase != P_START) begin
        // vehicle lights: nibbles at [11:8] N, [15:12] S, [19:16] W, [23:20] E
        for(i = 0; i < 4; i = i + 1)
            lamp_next[8 + 4*i +: 4] = is_yellow_phase ? veh_yellow(from_pat[8 + 4*i +: 4], to_pat[8 + 4*i +: 4])
                                                      : from_pat[8 + 4*i +: 4];
        // pedestrian lights: pairs at [1:0] N, [3:2] S, [5:4] W, [7:6] E
        for(i = 0; i < 4; i = i + 1)
            lamp_next[2*i +: 2] = is_yellow_phase ? ped_yellow(from_pat[2*i +: 2], to_pat[2*i +: 2])
                                                  : ped_run(from_pat[2*i +: 2], to_pat[2*i +: 2], blink_zone, blink_on);
    end
end

// register the lamps (no glitches on the outputs)
always @(posedge clk or negedge rst)
begin
    if(!rst)
        lamp <= 24'd0;
    else
        lamp <= lamp_next;
end

// ------------------------------------------------------------------
// LCD information
// ------------------------------------------------------------------
// during the emergency A and the yellow after it, the LCD shows A;
// during P_EMG_Y the lights are still the old state (with yellow), so it shows that
assign disp_letter = (phase == P_EMG || phase == P_RET_Y) ? L_A : cur_letter;
assign emg_active  = (phase == P_EMG_Y) || (phase == P_EMG) || (phase == P_RET_Y);

endmodule
