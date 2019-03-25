vlib work
vcom -93 -work work ../../src/BCD.vhd
vcom -93 -work work ../../src/double_dabble.vhd
vcom -93 -work work ../../src/FSM_Angle.vhd
vcom -93 -work work ../../src/FSM_Servo.vhd
vcom -93 -work work ../../src/generic_counter_Angle.vhd
vcom -93 -work work ../../src/generic_counter_Time.vhd
vcom -93 -work work ../../src/components_include.vhd
vcom -93 -work work ../../src/memory.vhd
vcom -93 -work work ../../src/rising_edge_synchronizer.vhd
vcom -93 -work work ../../src/synchronizer4bit.vhd
vcom -93 -work work ../../src/synchronizer8bit.vhd
vcom -93 -work work ../../src/Top.vhd
vcom -93 -work work ../src/top_level_tb.vhd
vsim -novopt top_level_tb
do wave.do
run 76700 ns
