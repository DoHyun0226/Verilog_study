#clk, rst, in, out, state
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports in]
set_property IOSTANDARD LVCMOS33 [get_ports out]
set_property IOSTANDARD LVCMOS33 [get_ports {state[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {state[1]}]

set_property PACKAGE_PIN L4 [get_ports out]        ;# LED1
set_property PACKAGE_PIN M4 [get_ports {state[1]}] ;# LED2
set_property PACKAGE_PIN M2 [get_ports {state[0]}] ;# LED3
set_property PACKAGE_PIN K4 [get_ports clk]        ;# SM_1
set_property PACKAGE_PIN Y1 [get_ports rst]        ;# DIP1
set_property PACKAGE_PIN W3 [get_ports in]         ;# DIP2

# K4 is not a clock-capable (CCIO) pin
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_IBUF]
