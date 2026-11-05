`timescale 1ns / 1ps

// t_DAC : testbench for preliminary report D (state and DAC input on each button)
//   clock 50 MHz -> 1 clock = 20 ns, rst is active low
//   one write cycle = DELAY 201 + SET_WRN 51 + UP_DATA 31 = 283 clocks = 5.66 us
//
//   buttons (btn[5:0] = {SM_1, SM_3, SM_4, SM_6, SM_7, SM_9}):
//     SM_1 -1, SM_3 +1, SM_4 -2, SM_6 +2, SM_7 -8, SM_9 +8
//
//   inputs (each press held 1 us, then 10 us wait so every value gets written):
//     SM_9 +8, SM_6 +2, SM_3 +1, SM_1 -1, SM_4 -2, SM_7 -8,
//     SM_1 -1 (0 -> 255 wrap), SM_3 +1 (255 -> 0 wrap), then add_sel 1 (output B)
//
//   expected dac_d_temp : 0 -> 8 -> 10 -> 11 -> 10 -> 8 -> 0 -> 255 -> 0
//   dac_d follows dac_d_temp at the next UP_DATA state,
//   and the DAC latches dac_d on the WR (dac_wrn) rising edge.
//
//   In the waveform, add btn, U1/btn_t, U1/state, U1/cnt, U1/dac_d_temp,
//   dac_wrn, dac_d, dac_a_b, led_out.
//   Every button press and every newly latched DAC value is printed in the Tcl console.
module t_DAC;

reg clk, rst;
reg [5:0] btn;
reg add_sel;
wire dac_csn, dac_ldacn, dac_wrn, dac_a_b;
wire [7:0] dac_d;
wire [7:0] led_out;

DAC U1(clk, rst, btn, add_sel, dac_csn, dac_ldacn, dac_wrn, dac_a_b, dac_d, led_out);

// 50 MHz clock: period 20 ns
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

// press one button for 1 us, then wait 10 us (longer than one write cycle)
task press;
input [5:0] b;
begin
    btn = b;
    #1000 btn = 6'b000000;
    #10000;
end
endtask

initial begin
    rst = 0;                    // reset (active low) for 100 ns
    btn = 6'b000000;
    add_sel = 0;                // output A
    #100 rst = 1;

    #10000;
    press(6'b000001);           // SM_9 +8 -> 8
    press(6'b000100);           // SM_6 +2 -> 10
    press(6'b010000);           // SM_3 +1 -> 11
    press(6'b100000);           // SM_1 -1 -> 10
    press(6'b001000);           // SM_4 -2 -> 8
    press(6'b000010);           // SM_7 -8 -> 0
    press(6'b100000);           // SM_1 -1 -> 255 (wrap)
    press(6'b010000);           // SM_3 +1 -> 0   (wrap)
    add_sel = 1;                // output B
    #10000 $finish;
end

// print dac_d_temp right after each button pulse is applied
reg [5:0] bt;
always @(posedge clk)
    if(U1.btn_t != 6'b000000) begin
        bt = U1.btn_t;
        #1 $display("[%8.2f us] btn_t = %b -> dac_d_temp = %3d", $realtime / 1000, bt, U1.dac_d_temp);
    end

// print the value the DAC latches on each WR rising edge, when it changes
reg [7:0] last_d;
initial last_d = 8'bx;
always @(posedge dac_wrn)
    if(rst && dac_d !== last_d) begin
        $display("[%8.2f us] WR rise : dac_d = %3d (%b), A/B = %b", $realtime / 1000, dac_d, dac_d, dac_a_b);
        last_d = dac_d;
    end

endmodule
