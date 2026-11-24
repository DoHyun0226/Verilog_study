# common : clock, reset and 24 lamp pins
#          (same as Final_Project common.xdc, keep both the same)
#
#   clk   : main clock B6
#   rst   : DIP switch SW1, active low (SW1 off = 0 -> reset, all lamps off)
#   state : 24 lamps of the traffic lights module
#             [23:20] East  vehicle {RED, YELLOW, GREEN, LEFT}
#             [19:16] West  vehicle
#             [15:12] South vehicle
#             [11: 8] North vehicle
#             [ 7: 6] East  walk {RED, GREEN}
#             [ 5: 4] West  walk
#             [ 3: 2] South walk
#             [ 1: 0] North walk
#
#   Directions follow the compass printed on the module board.
#   The direction names of the lab pin table do NOT match that compass
#   (found by board test). Pin-table name -> lamp position on the board:
#     N_* -> West,  E_* -> North,  S_* -> South,  W_* -> East
#   so each state[] group below uses the pin-table group that sits there.
#   Also *_GREEN and *_LEFT of the pin table are swapped on the board
#   (*_GREEN lights the left arrow, *_LEFT lights the green lamp).

set_property PACKAGE_PIN B6  [get_ports clk]            ;# Main_clock1
set_property PACKAGE_PIN Y1  [get_ports rst]            ;# SW1 (DIP, active low)

# Vehicle lights
set_property PACKAGE_PIN C17 [get_ports {state[23]}]    ;# East  RED    (pin table W_RED)
set_property PACKAGE_PIN C18 [get_ports {state[22]}]    ;# East  YELLOW (pin table W_YELLOW)
set_property PACKAGE_PIN C19 [get_ports {state[21]}]    ;# East  GREEN  (pin table W_LEFT)
set_property PACKAGE_PIN A20 [get_ports {state[20]}]    ;# East  LEFT   (pin table W_GREEN)
set_property PACKAGE_PIN G14 [get_ports {state[19]}]    ;# West  RED    (pin table N_RED)
set_property PACKAGE_PIN A14 [get_ports {state[18]}]    ;# West  YELLOW (pin table N_YELLOW)
set_property PACKAGE_PIN D15 [get_ports {state[17]}]    ;# West  GREEN  (pin table N_LEFT)
set_property PACKAGE_PIN C16 [get_ports {state[16]}]    ;# West  LEFT   (pin table N_GREEN)
set_property PACKAGE_PIN B13 [get_ports {state[15]}]    ;# South RED    (pin table S_RED)
set_property PACKAGE_PIN L18 [get_ports {state[14]}]    ;# South YELLOW (pin table S_YELLOW)
set_property PACKAGE_PIN F15 [get_ports {state[13]}]    ;# South GREEN  (pin table S_LEFT)
set_property PACKAGE_PIN E16 [get_ports {state[12]}]    ;# South LEFT   (pin table S_GREEN)
set_property PACKAGE_PIN C12 [get_ports {state[11]}]    ;# North RED    (pin table E_RED)
set_property PACKAGE_PIN D13 [get_ports {state[10]}]    ;# North YELLOW (pin table E_YELLOW)
set_property PACKAGE_PIN F10 [get_ports {state[9]}]     ;# North GREEN  (pin table E_LEFT)
set_property PACKAGE_PIN E11 [get_ports {state[8]}]     ;# North LEFT   (pin table E_GREEN)

# Pedestrian lights
set_property PACKAGE_PIN E18 [get_ports {state[7]}]     ;# East  walk RED   (pin table W_W_RED)
set_property PACKAGE_PIN A16 [get_ports {state[6]}]     ;# East  walk GREEN (pin table W_W_GREEN)
set_property PACKAGE_PIN G13 [get_ports {state[5]}]     ;# West  walk RED   (pin table N_W_RED)
set_property PACKAGE_PIN F12 [get_ports {state[4]}]     ;# West  walk GREEN (pin table N_W_GREEN)
set_property PACKAGE_PIN A19 [get_ports {state[3]}]     ;# South walk RED   (pin table S_W_RED)
set_property PACKAGE_PIN E19 [get_ports {state[2]}]     ;# South walk GREEN (pin table S_W_GREEN)
set_property PACKAGE_PIN C11 [get_ports {state[1]}]     ;# North walk RED   (pin table E_W_RED)
set_property PACKAGE_PIN G11 [get_ports {state[0]}]     ;# North walk GREEN (pin table E_W_GREEN)

# all I/O of the board is 3.3 V
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports {state[*]}]
