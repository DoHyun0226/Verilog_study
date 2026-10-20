`timescale 1ns / 1ps

// t_LED3_control : testbench for preliminary report 4.5
//   3-color LED PWM: red -> orange -> yellow
//
//   clock 1 MHz -> 1 clock = 1 us, one PWM period = 256 clocks = 256 us
//   comparator is (cnt < reference), so each color is on for (reference) us in every 256 us
//
//     color    button  state {R, G, B}    R ON     G ON     B ON
//     red      btn[0]  {255,   0, 0}     255 us     0 us    0 us
//     orange   btn[1]  {255, 102, 0}     255 us   102 us    0 us
//     yellow   btn[2]  {255, 255, 0}     255 us   255 us    0 us
//     (ON time in every 256 us period)
//
//   Each button is pressed for 10 us, then released. state keeps the color,
//   and each color is watched for 768 us = 3 PWM periods.
//   In the waveform, add U1/state (reference signal) and led_signal_R/G/B.
//
//   The measured result is also printed in the Tcl console ($display):
//     for each color, 256 us after the button is released (so the PWM is settled),
//     led_signal_R/G/B are sampled at 256 falling edges of clk (= one PWM period).
//     ON time = number of samples with 4'b1111 (x 1 us), OFF time = 256 us - ON time
//     ON time is compared with the reference signal in state -> PASS / FAIL
//     (a value other than 4'b1111 / 4'b0000 is also reported as FAIL)
//   The simulation runtime is set to 2400 us in the project ($finish at about 2336 us).
module t_LED3_control;

reg clk, rst;
reg [7:0] btn; // button switches (1 = pressed)
wire [3:0] led_signal_R, led_signal_G, led_signal_B;

integer on_R, on_G, on_B; // number of clocks each color is on in one PWM period
integer bad; // samples that are neither 4'b1111 nor 4'b0000
integer i;
integer errors; // number of FAIL results

LED3_control U1(clk, rst, btn, led_signal_R, led_signal_G, led_signal_B);

// 1 MHz clock: period 1000 ns, toggle every 500 ns
initial begin
    clk = 0;
    forever #500 clk = ~clk; // 1 MHz
end

// measure ON / OFF time of R, G, B over one PWM period (256 clocks)
//   sampled at the falling edge so every sample sees a stable value
task measure_rgb;
    input [8*6:1] name; // color name for the message
    reg [7:0] ref_R, ref_G, ref_B;
    begin
        ref_R = U1.state[23:16];
        ref_G = U1.state[15:8];
        ref_B = U1.state[7:0];
        on_R = 0; on_G = 0; on_B = 0; bad = 0;
        for(i = 0; i < 256; i = i + 1) begin
            @(negedge clk);
            if(led_signal_R == 4'b1111) on_R = on_R + 1; else if(led_signal_R != 4'b0000) bad = bad + 1;
            if(led_signal_G == 4'b1111) on_G = on_G + 1; else if(led_signal_G != 4'b0000) bad = bad + 1;
            if(led_signal_B == 4'b1111) on_B = on_B + 1; else if(led_signal_B != 4'b0000) bad = bad + 1;
        end
        $display("[%7.1f us] %0s : reference signal state = {R %3d, G %3d, B %3d}",
                 $realtime / 1000.0, name, ref_R, ref_G, ref_B);
        $display("             R : ON %3d us, OFF %3d us -> duty %6.2f %% (expected %3d/256 = %6.2f %%)",
                 on_R, 256 - on_R, on_R * 100.0 / 256.0, ref_R, ref_R * 100.0 / 256.0);
        $display("             G : ON %3d us, OFF %3d us -> duty %6.2f %% (expected %3d/256 = %6.2f %%)",
                 on_G, 256 - on_G, on_G * 100.0 / 256.0, ref_G, ref_G * 100.0 / 256.0);
        $display("             B : ON %3d us, OFF %3d us -> duty %6.2f %% (expected %3d/256 = %6.2f %%)",
                 on_B, 256 - on_B, on_B * 100.0 / 256.0, ref_B, ref_B * 100.0 / 256.0);
        if(on_R == ref_R && on_G == ref_G && on_B == ref_B && bad == 0)
            $display("             -> PASS");
        else begin
            $display("             -> FAIL (%0d samples not 4'b1111 / 4'b0000)", bad);
            errors = errors + 1;
        end
    end
endtask

// press a button for 10 us, wait 256 us for the PWM to settle, then measure one period
//   fork/join keeps each color for exactly 768 us after the button is released
task check_color;
    input [7:0] button;
    input [8*6:1] name;
    begin
        btn = button; #10000 btn = 8'b00000000;
        $display("[%7.1f us] btn = %b pressed for 10 us -> state = {%0d, %0d, %0d}",
                 $realtime / 1000.0, button, U1.state[23:16], U1.state[15:8], U1.state[7:0]);
        fork
            #768000;
            begin
                #256000;
                measure_rgb(name);
            end
        join
    end
endtask

initial begin
    errors = 0;
    rst = 1; btn = 8'b00000000; // hold reset for 2 us
    #2000 rst = 0;
    $display("==== 4.5 3-color LED PWM (8 bit counter, clock 1 MHz) ====");
    check_color(8'b00000001, "red");    // red    {255, 0, 0}
    check_color(8'b00000010, "orange"); // orange {255, 102, 0}
    check_color(8'b00000100, "yellow"); // yellow {255, 255, 0}
    if(errors == 0) $display("==== red, orange, yellow all PASS ====");
    else $display("==== %0d FAIL ====", errors);
    $finish;
end

endmodule
