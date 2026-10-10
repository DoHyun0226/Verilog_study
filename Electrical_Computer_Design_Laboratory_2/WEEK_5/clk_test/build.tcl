read_verilog clk_test.v
read_xdc clk_test.xdc
synth_design -top clk_test -part xc7s75fgga484-1
opt_design; place_design; route_design
write_bitstream -force clk_test.bit
