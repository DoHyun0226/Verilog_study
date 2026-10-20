# LED_control : pin constraints for result report 5.1, 5.2
#
# clk, rst, bin[7:0], seg_data[7:0], seg_sel[7:0], led_signal
#
#   clk        : main clock B6 (50 MHz by default, 5.2 lowers it to 10 Hz)
#   rst        : button SM_1, active high (pressed = 1 -> reset)
#   bin[7:0]   : DIP switches SW1 ~ SW8, SW1 is the MSB (bin[7])
#   led_signal : single LED, LED1
#   seg_data   : {a, b, c, d, e, f, g, dp} of the 7-segment array (active high)
#   seg_sel    : digit select of the 7-segment array (active low),
#                seg_sel[0] is the rightmost digit (S7)

set_property PACKAGE_PIN B6 [get_ports clk]            ;# Main_clock1
set_property PACKAGE_PIN K4 [get_ports rst]            ;# SM_1 (button, active high)
set_property PACKAGE_PIN Y1 [get_ports {bin[7]}]       ;# SW1 (DIP)
set_property PACKAGE_PIN W3 [get_ports {bin[6]}]       ;# SW2
set_property PACKAGE_PIN U2 [get_ports {bin[5]}]       ;# SW3
set_property PACKAGE_PIN T1 [get_ports {bin[4]}]       ;# SW4
set_property PACKAGE_PIN W4 [get_ports {bin[3]}]       ;# SW5
set_property PACKAGE_PIN W1 [get_ports {bin[2]}]       ;# SW6
set_property PACKAGE_PIN V4 [get_ports {bin[1]}]       ;# SW7
set_property PACKAGE_PIN U4 [get_ports {bin[0]}]       ;# SW8
set_property PACKAGE_PIN L4 [get_ports led_signal]     ;# LED1
set_property PACKAGE_PIN F1 [get_ports {seg_data[7]}]  ;# AR_SEG_A
set_property PACKAGE_PIN F5 [get_ports {seg_data[6]}]  ;# AR_SEG_B
set_property PACKAGE_PIN E2 [get_ports {seg_data[5]}]  ;# AR_SEG_C
set_property PACKAGE_PIN E4 [get_ports {seg_data[4]}]  ;# AR_SEG_D
set_property PACKAGE_PIN J1 [get_ports {seg_data[3]}]  ;# AR_SEG_E
set_property PACKAGE_PIN J3 [get_ports {seg_data[2]}]  ;# AR_SEG_F
set_property PACKAGE_PIN J7 [get_ports {seg_data[1]}]  ;# AR_SEG_G
set_property PACKAGE_PIN H2 [get_ports {seg_data[0]}]  ;# AR_SEG_DP
set_property PACKAGE_PIN K5 [get_ports {seg_sel[0]}]   ;# AR_SEG_S7 (rightmost)
set_property PACKAGE_PIN K3 [get_ports {seg_sel[1]}]   ;# AR_SEG_S6
set_property PACKAGE_PIN K1 [get_ports {seg_sel[2]}]   ;# AR_SEG_S5
set_property PACKAGE_PIN L6 [get_ports {seg_sel[3]}]   ;# AR_SEG_S4
set_property PACKAGE_PIN G3 [get_ports {seg_sel[4]}]   ;# AR_SEG_S3
set_property PACKAGE_PIN G1 [get_ports {seg_sel[5]}]   ;# AR_SEG_S2
set_property PACKAGE_PIN H6 [get_ports {seg_sel[6]}]   ;# AR_SEG_S1
set_property PACKAGE_PIN H4 [get_ports {seg_sel[7]}]   ;# AR_SEG_S0 (leftmost)

# all I/O of the board is 3.3 V
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports {bin[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports led_signal]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_data[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_sel[*]}]
