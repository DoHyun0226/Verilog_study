`timescale 1ns / 1ps

// t_LED_control : testbench for preliminary report 4.4
//   single LED PWM with an 8 bit counter, 1 MHz clock
//
//   clock 1 MHz -> 1 clock = 1 us, one PWM period = 256 clocks = 256 us
//   comparator is (cnt <= bin), so the LED is on for (bin + 1) us in every 256 us
//
//     time (after reset)   bin   ON time / period   duty
//     0     ~  768 us        0      1 us / 256 us   about 0.4 % (closest to 0 %)
//     768   ~ 1536 us       63     64 us / 256 us   25 %
//     1536  ~ 2304 us      127    128 us / 256 us   50 %
//     2304  ~ 3072 us      191    192 us / 256 us   75 %
//     3072  ~ 3840 us      255    256 us / 256 us   100 % (always on)
//
//   Each value is held for 768 us = 3 PWM periods.
//   In the waveform, measure the ON and OFF time of led_signal in one period
//   and check ON / (ON + OFF) against the table.
//
//   The measured result is also printed in the Tcl console ($display):
//     for each bin, 256 us after bin changes (so the PWM is settled),
//     led_signal is sampled at 256 falling edges of clk (= exactly one PWM period).
//     ON time  = number of samples with led_signal = 1 (x 1 us)
//     OFF time = 256 us - ON time
//     duty     = ON / 256, compared with the expected (bin + 1) / 256 -> PASS / FAIL
//   The simulation runtime is set to 4000 us in the project ($finish at about 3842 us).
module t_LED_control;

reg clk, rst;
reg [7:0] bin; // reference signal (DIP switches on the board)
wire [7:0] seg_data, seg_sel;
wire led_signal;

integer on_cnt; // number of clocks led_signal = 1 in one PWM period
integer i;
integer errors; // number of FAIL results

LED_control U1(clk, rst, bin, seg_data, seg_sel, led_signal);

// 1 MHz clock: period 1000 ns, toggle every 500 ns
initial begin
    clk = 0;
    forever #500 clk = ~clk; // 1 MHz
end

// measure ON / OFF time of led_signal over one PWM period (256 clocks)
//   sampled at the falling edge, half a clock away from the posedge where
//   led_signal changes, so every sample sees a stable value
task measure_duty;
    input [7:0] ref_val; // reference signal (bin) being measured
    real duty, expected;
    begin
        on_cnt = 0;
        for(i = 0; i < 256; i = i + 1) begin
            @(negedge clk);
            if(led_signal == 1'b1) on_cnt = on_cnt + 1;
        end
        duty = on_cnt * 100.0 / 256.0;
        expected = (ref_val + 1) * 100.0 / 256.0;
        if(on_cnt == ref_val + 1)
            $display("[%7.1f us] bin = %3d : ON %3d us, OFF %3d us (period 256 us) -> duty %6.2f %% (expected (bin+1)/256 = %6.2f %%)  PASS",
                     $realtime / 1000.0, ref_val, on_cnt, 256 - on_cnt, duty, expected);
        else begin
            $display("[%7.1f us] bin = %3d : ON %3d us, OFF %3d us (period 256 us) -> duty %6.2f %% (expected (bin+1)/256 = %6.2f %%)  FAIL",
                     $realtime / 1000.0, ref_val, on_cnt, 256 - on_cnt, duty, expected);
            errors = errors + 1;
        end
    end
endtask

// change bin, wait 256 us for the PWM to settle, then measure one period
//   fork/join keeps each bin value held for exactly 768 us
task check_bin;
    input [7:0] value;
    begin
        bin = value;
        fork
            #768000;
            begin
                #256000;
                measure_duty(value);
            end
        join
    end
endtask

initial begin
    errors = 0;
    rst = 1; bin = 8'd0;   // hold reset for 2 us
    #2000 rst = 0;
    $display("==== 4.4 single LED PWM (8 bit counter, clock 1 MHz) ====");
    check_bin(8'd0);   // 0%   (actually 1/256)
    check_bin(8'd63);  // 25%
    check_bin(8'd127); // 50%
    check_bin(8'd191); // 75%
    check_bin(8'd255); // 100%
    if(errors == 0) $display("==== all 5 duty values PASS ====");
    else $display("==== %0d FAIL ====", errors);
    $finish;
end

endmodule
