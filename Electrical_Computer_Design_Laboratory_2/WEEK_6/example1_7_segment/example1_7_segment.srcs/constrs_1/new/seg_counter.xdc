# clk, rst, btn, seg[7:0], state[3:0]

set_property PACKAGE_PIN B6 [get_ports clk]        ;# Main_clock1
set_property PACKAGE_PIN Y1 [get_ports rst]        ;# SW1 (DIP)
set_property PACKAGE_PIN K4 [get_ports btn]        ;# SM_1
set_property PACKAGE_PIN L4 [get_ports {state[3]}] ;# LED1
set_property PACKAGE_PIN M4 [get_ports {state[2]}] ;# LED2
set_property PACKAGE_PIN M2 [get_ports {state[1]}] ;# LED3
set_property PACKAGE_PIN N7 [get_ports {state[0]}] ;# LED4
set_property PACKAGE_PIN P1 [get_ports {seg[7]}]   ;# SEG_A
set_property PACKAGE_PIN P3 [get_ports {seg[6]}]   ;# SEG_B
set_property PACKAGE_PIN P7 [get_ports {seg[5]}]   ;# SEG_C
set_property PACKAGE_PIN N3 [get_ports {seg[4]}]   ;# SEG_D
set_property PACKAGE_PIN T5 [get_ports {seg[3]}]   ;# SEG_E
set_property PACKAGE_PIN R2 [get_ports {seg[2]}]   ;# SEG_F
set_property PACKAGE_PIN R4 [get_ports {seg[1]}]   ;# SEG_G
set_property PACKAGE_PIN R6 [get_ports {seg[0]}]   ;# SEG_DP

set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports btn]

set_property IOSTANDARD LVCMOS33 [get_ports {seg[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {state[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state[0]}]
