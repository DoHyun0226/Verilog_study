# clk, rst, btn, seg_data[7:0], seg_sel[7:0], state_bin[3:0]

set_property PACKAGE_PIN B6 [get_ports clk]            ;# Main_clock1
set_property PACKAGE_PIN Y1 [get_ports rst]            ;# SW1 (DIP)
set_property PACKAGE_PIN K4 [get_ports btn]            ;# SM_1
set_property PACKAGE_PIN L4 [get_ports {state_bin[3]}] ;# LED1
set_property PACKAGE_PIN M4 [get_ports {state_bin[2]}] ;# LED2
set_property PACKAGE_PIN M2 [get_ports {state_bin[1]}] ;# LED3
set_property PACKAGE_PIN N7 [get_ports {state_bin[0]}] ;# LED4
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

set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports btn]

set_property IOSTANDARD LVCMOS33 [get_ports {state_bin[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state_bin[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state_bin[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state_bin[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {seg_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_data[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {seg_sel[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_sel[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_sel[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_sel[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_sel[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_sel[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_sel[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_sel[0]}]
