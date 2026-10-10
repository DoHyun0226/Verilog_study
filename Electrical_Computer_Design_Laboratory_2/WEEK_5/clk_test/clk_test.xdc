set_property IOSTANDARD LVCMOS33 [get_ports {clk rst btn led[*]}]
set_property PACKAGE_PIN B6 [get_ports clk]     ;# Main_clock1
set_property PACKAGE_PIN Y1 [get_ports rst]     ;# DIP1
set_property PACKAGE_PIN K4 [get_ports btn]     ;# SM_1
set_property PACKAGE_PIN L4 [get_ports {led[0]}] ;# LED1
set_property PACKAGE_PIN M4 [get_ports {led[1]}] ;# LED2
set_property PACKAGE_PIN M2 [get_ports {led[2]}] ;# LED3
set_property PACKAGE_PIN N7 [get_ports {led[3]}] ;# LED4
