# DAC : pin constraints for result report A, B (week 10 manual 3.)
#
# clk, rst, btn[5:0], add_sel, dac_csn, dac_ldacn, dac_wrn, dac_a_b, dac_d[7:0], led_out[7:0]
#
#   clk       : main clock B6
#   rst       : DIP switch SW1, active low (SW1 off = 0 -> reset)
#   add_sel   : DIP switch SW2, 0 = DAC_OUT_A (board voltmeter LEDs), 1 = DAC_OUT_B (DAC_OUT pin, oscilloscope)
#   btn       : [5] = SM_1 (-1), [4] = SM_3 (+1), [3] = SM_4 (-2),
#               [2] = SM_6 (+2), [1] = SM_7 (-8), [0] = SM_9 (+8)
#   dac_d     : AD7302 D7 (MSB) ... D0
#   led_out   : DAC input value, led_out[7] (MSB) = LED8 ... led_out[0] = LED1

set_property PACKAGE_PIN B6 [get_ports clk]              ;# Main_clock1
set_property PACKAGE_PIN Y1 [get_ports rst]              ;# SW1 (DIP)
set_property PACKAGE_PIN W3 [get_ports add_sel]          ;# SW2 (DIP)

set_property PACKAGE_PIN K4 [get_ports {btn[5]}]         ;# SM_1 (-1)
set_property PACKAGE_PIN N4 [get_ports {btn[4]}]         ;# SM_3 (+1)
set_property PACKAGE_PIN N1 [get_ports {btn[3]}]         ;# SM_4 (-2)
set_property PACKAGE_PIN N6 [get_ports {btn[2]}]         ;# SM_6 (+2)
set_property PACKAGE_PIN L5 [get_ports {btn[1]}]         ;# SM_7 (-8)
set_property PACKAGE_PIN K2 [get_ports {btn[0]}]         ;# SM_9 (+8)

set_property PACKAGE_PIN B3 [get_ports {dac_d[7]}]       ;# DAC_D7 (MSB)
set_property PACKAGE_PIN B1 [get_ports {dac_d[6]}]       ;# DAC_D6
set_property PACKAGE_PIN C4 [get_ports {dac_d[5]}]       ;# DAC_D5
set_property PACKAGE_PIN C2 [get_ports {dac_d[4]}]       ;# DAC_D4
set_property PACKAGE_PIN D5 [get_ports {dac_d[3]}]       ;# DAC_D3
set_property PACKAGE_PIN D2 [get_ports {dac_d[2]}]       ;# DAC_D2
set_property PACKAGE_PIN E5 [get_ports {dac_d[1]}]       ;# DAC_D1
set_property PACKAGE_PIN E3 [get_ports {dac_d[0]}]       ;# DAC_D0
set_property PACKAGE_PIN G2 [get_ports dac_a_b]          ;# DAC_A_B
set_property PACKAGE_PIN E1 [get_ports dac_csn]          ;# DAC_CSN
set_property PACKAGE_PIN F4 [get_ports dac_ldacn]        ;# DAC_LDACN
set_property PACKAGE_PIN G4 [get_ports dac_wrn]          ;# DAC_WRN

set_property PACKAGE_PIN L4 [get_ports {led_out[0]}]     ;# LED1
set_property PACKAGE_PIN M4 [get_ports {led_out[1]}]     ;# LED2
set_property PACKAGE_PIN M2 [get_ports {led_out[2]}]     ;# LED3
set_property PACKAGE_PIN N7 [get_ports {led_out[3]}]     ;# LED4
set_property PACKAGE_PIN M7 [get_ports {led_out[4]}]     ;# LED5
set_property PACKAGE_PIN M3 [get_ports {led_out[5]}]     ;# LED6
set_property PACKAGE_PIN M1 [get_ports {led_out[6]}]     ;# LED7
set_property PACKAGE_PIN N5 [get_ports {led_out[7]}]     ;# LED8

# all I/O of the board is 3.3 V
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports add_sel]
set_property IOSTANDARD LVCMOS33 [get_ports {btn[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dac_d[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports dac_a_b]
set_property IOSTANDARD LVCMOS33 [get_ports dac_csn]
set_property IOSTANDARD LVCMOS33 [get_ports dac_ldacn]
set_property IOSTANDARD LVCMOS33 [get_ports dac_wrn]
set_property IOSTANDARD LVCMOS33 [get_ports {led_out[*]}]
