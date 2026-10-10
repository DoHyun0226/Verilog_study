//////////////////////////////////////////////////////////////////////////////////
// Company: Electrical_Computer_Design_Laboratory_2
// Engineer: DoHyun0226
//
// Create Date: 2026/10/10 20:18:29
// Design Name: piezo_basic
// Module Name: piezo_basic
// Project Name: example4_piezo_basic
// Target Devices: xc7s75fgga484-1 (Spartan-7)
// Tool Versions: Vivado 2025.2.1
// Description: 8-button piezo buzzer player.
//              btn[n] (n = 0~7) selects one note (do ~ high do, ~261 ~ 523 Hz),
//              and piezo outputs a 50% duty square wave of that frequency.
//
// Dependencies: none (requires a 1 MHz clock)
//
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Note parameters, button priority logic and tone generator added
// Additional Comments:
//   tone frequency = 1 MHz / cnt_limit
//   Several buttons at once -> the smallest index wins.
//
//////////////////////////////////////////////////////////////////////////////////


// piezo_basic: press btn[n] (n = 0~7) -> piezo plays one note of the scale (do ~ high do)
module piezo_basic(clk, rst, btn, piezo);

input clk, rst;    // clk: 1 MHz, rst: asynchronous active-low reset
input [7:0] btn;   // 8 buttons, btn[n] selects the n-th note
output reg piezo;  // square wave to the (passive) piezo buzzer, 50% duty

// reference clock = 1 MHz
// each value = clocks per one full period -> tone frequency = 1 MHz / value
parameter C2 = 12'd3830; // ~261.1 Hz (C4, do)
parameter D2 = 12'd3400; // ~294.1 Hz (D4, re)
parameter E2 = 12'd3038; // ~329.2 Hz (E4, mi)
parameter F2 = 12'd2864; // ~349.2 Hz (F4, fa)
parameter G2 = 12'd2550; // ~392.2 Hz (G4, sol)
parameter A2 = 12'd2272; // ~440.1 Hz (A4, la)
parameter B2 = 12'd2028; // ~493.1 Hz (B4, si)
parameter C3 = 12'd1912; // ~523.0 Hz (C5, high do)

reg [11:0] cnt;        // clock counter inside one half period
reg [11:0] cnt_limit;  // one full period (in clocks) of the selected note, 0 = no note

// button -> tone period
// priority: if several buttons are pushed simultaneously, the smallest index wins
// no button -> cnt_limit = 0 (no tone)
always @(btn, rst) begin
    if(!rst) cnt_limit = 0;
    else if (btn[0]) cnt_limit = C2;
    else if (btn[1]) cnt_limit = D2;
    else if (btn[2]) cnt_limit = E2;
    else if (btn[3]) cnt_limit = F2;
    else if (btn[4]) cnt_limit = G2;
    else if (btn[5]) cnt_limit = A2;
    else if (btn[6]) cnt_limit = B2;
    else if (btn[7]) cnt_limit = C3;
    else cnt_limit = 0;
end

// tone generator: toggle piezo every half period (cnt_limit/2 clocks)
//   -> period = cnt_limit clocks, 50% duty, frequency = 1 MHz / cnt_limit
//   cnt counts 0 ~ cnt_limit/2, so the real half period is cnt_limit/2 + 1 clocks (slightly lower pitch)
//   cnt_limit = 0 -> cnt >= 0 is always true, piezo toggles every clock (500 kHz, inaudible)
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        cnt = 0;
        piezo = 0;
    end
    else if(cnt >= cnt_limit/2) begin // half period reached
        piezo = ~piezo;
        cnt = 0;
    end
    else cnt = cnt + 1;
end

endmodule
