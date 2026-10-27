# text_LCD_basic : pin constraints for result report A, B (week 8 manual 4.)
#
# rst, clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA[7:0], LED_out[7:0]
#
#   clk      : main clock B6, lower it on the board (~1 kHz for A, 1 Hz for B)
#              LCD_E = clk, so one LCD write per clock
#   rst      : DIP switch SW1, active low (SW1 off = 0 -> reset)
#   LCD_*    : 16 x 2 text LCD, LCD_DATA[0] = LCD_D0
#   LED_out  : current state, one-hot, LED_out[7] (MSB) = LED8 ... LED_out[0] = LED1
#              (LED8 = DELAY ... LED1 = CLEAR_DISP)

set_property PACKAGE_PIN B6 [get_ports clk]            ;# Main_clock1
set_property PACKAGE_PIN Y1 [get_ports rst]            ;# SW1 (DIP)

set_property PACKAGE_PIN A6 [get_ports LCD_E]          ;# LCD_E
set_property PACKAGE_PIN G6 [get_ports LCD_RS]         ;# LCD_RS
set_property PACKAGE_PIN D6 [get_ports LCD_RW]         ;# LCD_RW
set_property PACKAGE_PIN A4 [get_ports {LCD_DATA[0]}]  ;# LCD_D0
set_property PACKAGE_PIN B2 [get_ports {LCD_DATA[1]}]  ;# LCD_D1
set_property PACKAGE_PIN C3 [get_ports {LCD_DATA[2]}]  ;# LCD_D2
set_property PACKAGE_PIN D4 [get_ports {LCD_DATA[3]}]  ;# LCD_D3
set_property PACKAGE_PIN A2 [get_ports {LCD_DATA[4]}]  ;# LCD_D4
set_property PACKAGE_PIN C5 [get_ports {LCD_DATA[5]}]  ;# LCD_D5
set_property PACKAGE_PIN C1 [get_ports {LCD_DATA[6]}]  ;# LCD_D6
set_property PACKAGE_PIN D1 [get_ports {LCD_DATA[7]}]  ;# LCD_D7

set_property PACKAGE_PIN L4 [get_ports {LED_out[0]}]   ;# LED1 (CLEAR_DISP)
set_property PACKAGE_PIN M4 [get_ports {LED_out[1]}]   ;# LED2 (DELAY_T)
set_property PACKAGE_PIN M2 [get_ports {LED_out[2]}]   ;# LED3 (LINE2)
set_property PACKAGE_PIN N7 [get_ports {LED_out[3]}]   ;# LED4 (LINE1)
set_property PACKAGE_PIN M7 [get_ports {LED_out[4]}]   ;# LED5 (ENTRY_MODE)
set_property PACKAGE_PIN M3 [get_ports {LED_out[5]}]   ;# LED6 (DISP_ONOFF)
set_property PACKAGE_PIN M1 [get_ports {LED_out[6]}]   ;# LED7 (FUNCTION_SET)
set_property PACKAGE_PIN N5 [get_ports {LED_out[7]}]   ;# LED8 (DELAY)

# all I/O of the board is 3.3 V
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_E]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_RS]
set_property IOSTANDARD LVCMOS33 [get_ports LCD_RW]
set_property IOSTANDARD LVCMOS33 [get_ports {LCD_DATA[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_out[*]}]
