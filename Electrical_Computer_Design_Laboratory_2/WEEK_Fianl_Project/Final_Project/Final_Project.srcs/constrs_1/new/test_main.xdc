# test_main : pin constraints for the TEST_MAIN build only
#             (enable together with common.xdc, disable test_lamp_btn.xdc)
#
#   scale_sel : DIP switches SW3 SW2, clock speed-up of the traffic light time
#                 SW3 SW2 = off off -> x1, off on -> x10, on off -> x100, on on -> x200
#   btn_hour  : button SM_1, +1 hour
#   btn_emg   : button SM_2, emergency vehicle (state A for 15 s)
#   LCD_*     : 16 x 2 text LCD, LCD_DATA[0] = LCD_D0
#
#   clk (B6), rst (SW1) and the 24 lamps are in common.xdc.
#   The clock stays at the board default of 50 MHz; every module divides it
#   by itself (CLK_HZ parameter of main.v).

set_property PACKAGE_PIN W3 [get_ports {scale_sel[0]}]   ;# SW2 (DIP)
set_property PACKAGE_PIN U2 [get_ports {scale_sel[1]}]   ;# SW3 (DIP)

set_property PACKAGE_PIN K4 [get_ports btn_hour]         ;# SM_1 (+1 hour)
set_property PACKAGE_PIN N8 [get_ports btn_emg]          ;# SM_2 (emergency)

# text LCD
set_property PACKAGE_PIN A6 [get_ports LCD_E]            ;# LCD_E
set_property PACKAGE_PIN G6 [get_ports LCD_RS]           ;# LCD_RS
set_property PACKAGE_PIN D6 [get_ports LCD_RW]           ;# LCD_RW
set_property PACKAGE_PIN A4 [get_ports {LCD_DATA[0]}]    ;# LCD_D0
set_property PACKAGE_PIN B2 [get_ports {LCD_DATA[1]}]    ;# LCD_D1
set_property PACKAGE_PIN C3 [get_ports {LCD_DATA[2]}]    ;# LCD_D2
set_property PACKAGE_PIN D4 [get_ports {LCD_DATA[3]}]    ;# LCD_D3
set_property PACKAGE_PIN A2 [get_ports {LCD_DATA[4]}]    ;# LCD_D4
set_property PACKAGE_PIN C5 [get_ports {LCD_DATA[5]}]    ;# LCD_D5
set_property PACKAGE_PIN C1 [get_ports {LCD_DATA[6]}]    ;# LCD_D6
set_property PACKAGE_PIN D1 [get_ports {LCD_DATA[7]}]    ;# LCD_D7

# all I/O of the board is 3.3 V
set_property IOSTANDARD LVCMOS33 [get_ports {scale_sel[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports btn_hour]
set_property IOSTANDARD LVCMOS33 [get_ports btn_emg]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_E]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_RS]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_RW]
set_property IOSTANDARD LVCMOS33 [get_ports {LCD_DATA[*]}]
