# clk, rst, btn[7:0], piezo

set_property PACKAGE_PIN B6 [get_ports clk]       ;# Main_clock1 (1 MHz)
set_property PACKAGE_PIN Y1 [get_ports rst]       ;# SW1 (DIP)
set_property PACKAGE_PIN K4 [get_ports {btn[0]}]  ;# SM_1 (do)
set_property PACKAGE_PIN N8 [get_ports {btn[1]}]  ;# SM_2 (re)
set_property PACKAGE_PIN N4 [get_ports {btn[2]}]  ;# SM_3 (mi)
set_property PACKAGE_PIN N1 [get_ports {btn[3]}]  ;# SM_4 (fa)
set_property PACKAGE_PIN P6 [get_ports {btn[4]}]  ;# SM_5 (sol)
set_property PACKAGE_PIN N6 [get_ports {btn[5]}]  ;# SM_6 (la)
set_property PACKAGE_PIN L5 [get_ports {btn[6]}]  ;# SM_7 (si)
set_property PACKAGE_PIN J2 [get_ports {btn[7]}]  ;# SM_8 (high do)
set_property PACKAGE_PIN Y21 [get_ports piezo]    ;# Piezo

set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

set_property IOSTANDARD LVCMOS33 [get_ports {btn[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btn[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btn[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btn[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btn[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btn[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btn[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {btn[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports piezo]
