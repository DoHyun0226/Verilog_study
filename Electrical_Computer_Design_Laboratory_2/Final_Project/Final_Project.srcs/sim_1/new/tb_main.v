`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: tb_main
// Description: testbench of the TEST_MAIN build (enable `define TEST_MAIN in main.v)
//
//   CLK_HZ is set to 1000 here, so one "real second" of the design is only
//   1000 clocks (10 us of simulation time). All times printed below are in
//   these design seconds, counted from the reset release.
//
//   Start time 07:59:40 (night), scale x1. Scenario:
//      0 s : night sequence starts at B
//     20 s : clock reaches 08:00:00 -> after the running state, day sequence (A)
//     36 s : emergency button (with contact bounce) -> 1 s yellow, A 15 s,
//            1 s yellow, the interrupted state F again
//     45 s : emergency pressed again during the emergency (must be ignored)
//     85 s : +1 hour x 15 (with bounce) -> 23:xx -> night sequence from B
//    170 s : scale x10 / x100 / x200 for some seconds -> clock runs faster
//
//   Output:
//     one line per lamp change : time, phase, letter, lamps, LCD text
//     "LCD |...|"              : what an HD44780 model connected to
//                                LCD_E/RS/RW/DATA really shows
//////////////////////////////////////////////////////////////////////////////////

module tb_main;

localparam CLK_HZ = 1000;           // clocks per design second
localparam T      = 10;             // clock period [ns]
localparam real SEC = T * CLK_HZ;   // ns per design second

reg clk = 1'b0;
reg rst = 1'b0;
reg [1:0] scale_sel = 2'd0;
reg btn_hour = 1'b0;
reg btn_emg  = 1'b0;

wire LCD_E, LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
wire [23:0] state;

main #(.CLK_HZ(CLK_HZ), .INIT_HOUR(7), .INIT_MIN(59), .INIT_SEC(40)) dut(
    .clk(clk), .rst(rst), .scale_sel(scale_sel), .btn_hour(btn_hour), .btn_emg(btn_emg),
    .LCD_E(LCD_E), .LCD_RS(LCD_RS), .LCD_RW(LCD_RW), .LCD_DATA(LCD_DATA), .state(state));

always #(T/2) clk = ~clk;

real t0 = 0.0;                      // simulation time of the reset release

// ------------------------------------------------------------------
// lamp decoding for the printout
// ------------------------------------------------------------------
// vehicle nibble {R, Y, G, L} -> "RYGL", '.' = off
function [31:0] veh_str;
input [3:0] v;
begin
    veh_str = { (v[3] ? "R" : "."), (v[2] ? "Y" : "."), (v[1] ? "G" : "."), (v[0] ? "L" : ".") };
end
endfunction

// pedestrian pair {R, G} -> R / G / . (both off = blink off) / ? (both on: error)
function [7:0] ped_chr;
input [1:0] p;
begin
    case(p)
        2'b10   : ped_chr = "R";
        2'b01   : ped_chr = "G";
        2'b00   : ped_chr = ".";
        default : ped_chr = "?";
    endcase
end
endfunction

function [39:0] phase_name;
input [2:0] p;
begin
    case(p)
        3'd0    : phase_name = "START";
        3'd1    : phase_name = "RUN  ";
        3'd2    : phase_name = "YEL  ";
        3'd3    : phase_name = "EMG_Y";
        3'd4    : phase_name = "EMG  ";
        3'd5    : phase_name = "RET_Y";
        default : phase_name = "?????";
    endcase
end
endfunction

always @(state)
begin
    if(rst)
        $display("%8.3f s  %s %s | E:%s W:%s S:%s N:%s | walk E:%s W:%s S:%s N:%s | %s| %s|",
                 ($realtime - t0) / SEC,
                 phase_name(dut.TC.phase), "A" + dut.TC.cur_letter,
                 veh_str(state[23:20]), veh_str(state[19:16]), veh_str(state[15:12]), veh_str(state[11:8]),
                 ped_chr(state[7:6]), ped_chr(state[5:4]), ped_chr(state[3:2]), ped_chr(state[1:0]),
                 dut.line1, dut.line2);
end

// ------------------------------------------------------------------
// HD44780 model: DD-RAM written on the falling edge of LCD_E
// ------------------------------------------------------------------
reg [7:0] ddram [0:127];
reg [6:0] addr = 0;
integer k;
initial for(k = 0; k < 128; k = k + 1) ddram[k] = "~";    // '~' = never written

always @(negedge LCD_E)
begin
    if(!LCD_RW) begin
        if(!LCD_RS) begin
            if(LCD_DATA[7]) addr <= LCD_DATA[6:0];          // Set DD-RAM address
        end
        else begin
            ddram[addr] <= LCD_DATA;                        // write character
            addr <= addr + 1;                               // entry mode: +1
        end
    end
end

task show_lcd;
reg [127:0] l1, l2;
integer c;
begin
    for(c = 0; c < 16; c = c + 1) begin
        l1[127 - 8*c -: 8] = ddram[c];
        l2[127 - 8*c -: 8] = ddram[64 + c];
    end
    $display("%8.3f s  LCD |%s|", ($realtime - t0) / SEC, l1);
    $display("            LCD |%s|", l2);
end
endtask

// ------------------------------------------------------------------
// button press with contact bounce (debounce time = 10 clocks here)
// ------------------------------------------------------------------
task press_hour;
begin
    btn_hour = 1; #(T*2);  btn_hour = 0; #(T*3);    // bounce
    btn_hour = 1; #(T*1);  btn_hour = 0; #(T*2);    // bounce
    btn_hour = 1; #(T*60);                          // held
    btn_hour = 0; #(T*3);  btn_hour = 1; #(T*2);    // release bounce
    btn_hour = 0; #(T*60);
end
endtask

task press_emg;
begin
    btn_emg = 1; #(T*2);  btn_emg = 0; #(T*3);
    btn_emg = 1; #(T*1);  btn_emg = 0; #(T*2);
    btn_emg = 1; #(T*60);
    btn_emg = 0; #(T*3);  btn_emg = 1; #(T*2);
    btn_emg = 0; #(T*60);
end
endtask

// count the one-clock pulses after debounce + oneshot
integer n_hour_inc = 0, n_emg_btn = 0;
always @(posedge clk)
begin
    if(dut.hour_inc) n_hour_inc = n_hour_inc + 1;
    if(dut.emg_btn)  n_emg_btn  = n_emg_btn + 1;
end

task wait_until;    // wait until design second s
input real s;
begin
    #((t0 + s * SEC) - $realtime);
end
endtask

// ------------------------------------------------------------------
// scenario
// ------------------------------------------------------------------
integer p;
initial
begin
    #(T*10.5);
    rst = 1;
    t0 = $realtime;
    $display("---- reset released, 07:59:40, scale x1 ----");

    wait_until(2.0);    show_lcd;
    wait_until(23.0);   show_lcd;

    wait_until(36.0);
    $display("---- %0.3f s: emergency button ----", ($realtime - t0) / SEC);
    press_emg;
    wait_until(38.0);   show_lcd;
    wait_until(45.0);
    $display("---- %0.3f s: emergency button again (ignored) ----", ($realtime - t0) / SEC);
    press_emg;
    wait_until(54.0);   show_lcd;

    wait_until(85.0);
    $display("---- %0.3f s: +1 hour x 15 ----", ($realtime - t0) / SEC);
    for(p = 0; p < 15; p = p + 1) press_hour;
    $display("---- %0.3f s: presses done, clock %s ----", ($realtime - t0) / SEC, dut.line1);
    wait_until(90.0);   show_lcd;

    wait_until(170.0);
    $display("---- %0.3f s: clock %s, scale x10 for 2 s ----", ($realtime - t0) / SEC, dut.line1);
    scale_sel = 2'd1;
    wait_until(172.0);
    $display("---- %0.3f s: clock %s, scale x100 for 2 s ----", ($realtime - t0) / SEC, dut.line1);
    scale_sel = 2'd2;
    wait_until(174.0);
    $display("---- %0.3f s: clock %s, scale x200 ----", ($realtime - t0) / SEC, dut.line1);
    scale_sel = 2'd3;
    wait_until(176.0);
    $display("---- %0.3f s: clock %s ----", ($realtime - t0) / SEC, dut.line1);

    // x200 until the clock passes 08:00 (about 23:2x -> 08:00 = ~8.6 h = ~155 s)
    wait_until(345.0);
    show_lcd;
    $display("---- end: hour_inc pulses = %0d (expect 15), emg_btn pulses = %0d (expect 2, 2nd ignored) ----",
             n_hour_inc, n_emg_btn);
    $finish;
end

endmodule
