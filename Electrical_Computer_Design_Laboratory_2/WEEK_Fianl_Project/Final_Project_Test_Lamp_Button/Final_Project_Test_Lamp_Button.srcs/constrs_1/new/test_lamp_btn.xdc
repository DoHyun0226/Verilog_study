# test_lamp_btn : button pins of Final_Project_Test_Lamp_Button (lamp test)
#                 (used together with common.xdc)
#
#   btn : buttons SM_1 ~ SM_8, btn[0] = SM_1 -> state A ... btn[7] = SM_8 -> state H

set_property PACKAGE_PIN K4  [get_ports {btn[0]}]       ;# SM_1 -> state A
set_property PACKAGE_PIN N8  [get_ports {btn[1]}]       ;# SM_2 -> state B
set_property PACKAGE_PIN N4  [get_ports {btn[2]}]       ;# SM_3 -> state C
set_property PACKAGE_PIN N1  [get_ports {btn[3]}]       ;# SM_4 -> state D
set_property PACKAGE_PIN P6  [get_ports {btn[4]}]       ;# SM_5 -> state E
set_property PACKAGE_PIN N6  [get_ports {btn[5]}]       ;# SM_6 -> state F
set_property PACKAGE_PIN L5  [get_ports {btn[6]}]       ;# SM_7 -> state G
set_property PACKAGE_PIN J2  [get_ports {btn[7]}]       ;# SM_8 -> state H

set_property IOSTANDARD LVCMOS33 [get_ports {btn[*]}]
