# LED3_control : pin constraints for result report 5.3, 5.4
#
# clk, rst, btn[7:0], led_signal_R[3:0], led_signal_G[3:0], led_signal_B[3:0]
#
#   clk          : main clock B6 (50 MHz by default, 5.4 changes it from 10 Hz to 1 MHz)
#   rst          : button SM_9, active high (pressed = 1 -> reset, LEDs off)
#                  SM_1 ~ SM_8 are used for the colors, so reset uses SM_9
#   btn[7:0]     : buttons SM_1 ~ SM_8, btn[0] = SM_1
#                  SM_1 red, SM_2 orange, SM_3 yellow, SM_4 green,
#                  SM_5 blue, SM_6 indigo, SM_7 purple, SM_8 white
#   led_signal_R : red   of the 4 RGB LEDs, led_signal_R[0] = CLED_R1
#   led_signal_G : green of the 4 RGB LEDs, led_signal_G[0] = CLED_G1
#   led_signal_B : blue  of the 4 RGB LEDs, led_signal_B[0] = CLED_B1

set_property PACKAGE_PIN B6 [get_ports clk]                ;# Main_clock1
set_property PACKAGE_PIN K2 [get_ports rst]                ;# SM_9 (button, active high)
set_property PACKAGE_PIN K4 [get_ports {btn[0]}]           ;# SM_1 red
set_property PACKAGE_PIN N8 [get_ports {btn[1]}]           ;# SM_2 orange
set_property PACKAGE_PIN N4 [get_ports {btn[2]}]           ;# SM_3 yellow
set_property PACKAGE_PIN N1 [get_ports {btn[3]}]           ;# SM_4 green
set_property PACKAGE_PIN P6 [get_ports {btn[4]}]           ;# SM_5 blue
set_property PACKAGE_PIN N6 [get_ports {btn[5]}]           ;# SM_6 indigo
set_property PACKAGE_PIN L5 [get_ports {btn[6]}]           ;# SM_7 purple
set_property PACKAGE_PIN J2 [get_ports {btn[7]}]           ;# SM_8 white
set_property PACKAGE_PIN T2 [get_ports {led_signal_R[0]}]  ;# CLED_R1
set_property PACKAGE_PIN U1 [get_ports {led_signal_R[1]}]  ;# CLED_R2
set_property PACKAGE_PIN P2 [get_ports {led_signal_R[2]}]  ;# CLED_R3
set_property PACKAGE_PIN R3 [get_ports {led_signal_R[3]}]  ;# CLED_R4
set_property PACKAGE_PIN U5 [get_ports {led_signal_G[0]}]  ;# CLED_G1
set_property PACKAGE_PIN V1 [get_ports {led_signal_G[1]}]  ;# CLED_G2
set_property PACKAGE_PIN R7 [get_ports {led_signal_G[2]}]  ;# CLED_G3
set_property PACKAGE_PIN T6 [get_ports {led_signal_G[3]}]  ;# CLED_G4
set_property PACKAGE_PIN U3 [get_ports {led_signal_B[0]}]  ;# CLED_B1
set_property PACKAGE_PIN W2 [get_ports {led_signal_B[1]}]  ;# CLED_B2
set_property PACKAGE_PIN R5 [get_ports {led_signal_B[2]}]  ;# CLED_B3
set_property PACKAGE_PIN T3 [get_ports {led_signal_B[3]}]  ;# CLED_B4

# all I/O of the board is 3.3 V
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports {btn[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_signal_R[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_signal_G[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_signal_B[*]}]
