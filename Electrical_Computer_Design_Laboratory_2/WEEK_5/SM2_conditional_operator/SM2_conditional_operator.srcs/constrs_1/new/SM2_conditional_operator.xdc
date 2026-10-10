#clk, rst, A, B, C, state, y
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports A]
set_property IOSTANDARD LVCMOS33 [get_ports B]
set_property IOSTANDARD LVCMOS33 [get_ports C]
set_property IOSTANDARD LVCMOS33 [get_ports {state[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports y]

set_property PACKAGE_PIN B6 [get_ports clk]        ;# Main_clock1
set_property PACKAGE_PIN Y1 [get_ports rst]        ;# DIP1
set_property PACKAGE_PIN K4 [get_ports A]          ;# SM_1
set_property PACKAGE_PIN N8 [get_ports B]          ;# SM_2
set_property PACKAGE_PIN N4 [get_ports C]          ;# SM_3
set_property PACKAGE_PIN L4 [get_ports {state[2]}] ;# LED1
set_property PACKAGE_PIN M4 [get_ports {state[1]}] ;# LED2
set_property PACKAGE_PIN M2 [get_ports {state[0]}] ;# LED3
set_property PACKAGE_PIN N7 [get_ports y]          ;# LED4
