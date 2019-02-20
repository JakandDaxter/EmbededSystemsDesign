vlib work
vcom -93 -work work ../../src/ALU.vhd
vcom -93 -work work ../../src/rising_edge_synchronizer.vhd
vcom -93 -work work ../../src/seven_seg.vhd
vcom -93 -work work ../../src/memory.vhd
vcom -93 -work work ../../src/Generic_synchronizer.vhd
vcom -93 -work work ../../src/my_components.vhd
vcom -93 -work work ../../src/top_level.vhd
vcom -93 -work work ../src/top_level_tb.vhd
vsim -novopt top_level_tb
do wave.do
run 76700 ns
