
# Quartus II compile script for DE1-SoC  board

# 1] name your project here
set project_name "Lab_4"

file delete -force project
file delete -force output_files
file mkdir project
cd project
load_package flow
project_new $project_name
set_global_assignment -name FAMILY Cyclone
set_global_assignment -name DEVICE 5CSEMA5F31C6 
set_global_assignment -name TOP_LEVEL_ENTITY Top
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY ../output_files

# 2] include your relative path files here
set_global_assignment -name VHDL_FILE ../../src/synchronizer4bit.vhd
set_global_assignment -name VHDL_FILE ../../src/rising_edge_synchronizer.vhd
set_global_assignment -name VHDL_FILE ../../src/synchronizer8bit.vhd
set_global_assignment -name VHDL_FILE ../../src/generic_counter_Time.vhd
set_global_assignment -name VHDL_FILE ../../src/generic_counter_Angle.vhd
set_global_assignment -name VHDL_FILE ../../src/memory.vhd
set_global_assignment -name VHDL_FILE ../../src/FSM_Angle.vhd
set_global_assignment -name VHDL_FILE ../../src/BCD.vhd
set_global_assignment -name VHDL_FILE ../../src/FSM_Servo.vhd
set_global_assignment -name VHDL_FILE ../../src/components_include.vhd
set_global_assignment -name VHDL_FILE ../../src/Top.vhd

# 3] set your pin constraints here

set_location_assignment PIN_AF14 -to clk

set_location_assignment PIN_AB12  -to switch[0]
set_location_assignment PIN_AC12  -to switch[1]
set_location_assignment PIN_AF9   -to switch[2]
set_location_assignment PIN_AF10  -to switch[3]
set_location_assignment PIN_AD11  -to switch[4]
set_location_assignment PIN_AD12  -to switch[5]
set_location_assignment PIN_AE11  -to switch[6]
set_location_assignment PIN_AC9   -to switch[7]

# output gpio
set_location_assignment PIN_AC18  -to GPIO_0[0]	

# the LED is set here
set_location_assignment PIN_V16  -to LED[0]
set_location_assignment PIN_W16  -to LED[1]
set_location_assignment PIN_V17  -to LED[2]
set_location_assignment PIN_V18  -to LED[3]

# selection assignment for Execution
set_location_assignment PIN_AA14 -to resetBtn 


#set the hex 2
set_location_assignment PIN_AB23 -to Hex2[0]
set_location_assignment PIN_AE29 -to Hex2[1]
set_location_assignment PIN_AD29 -to Hex2[2]
set_location_assignment PIN_AC28 -to Hex2[3]
set_location_assignment PIN_AD30 -to Hex2[4]
set_location_assignment PIN_AC29 -to Hex2[5]
set_location_assignment PIN_AC30 -to Hex2[6]
                                     
# set the hex 3                      
set_location_assignment PIN_AD26 -to Hex3[0]
set_location_assignment PIN_AC27 -to Hex3[1]
set_location_assignment PIN_AD25 -to Hex3[2]
set_location_assignment PIN_AC25 -to Hex3[3]
set_location_assignment PIN_AB28 -to Hex3[4]
set_location_assignment PIN_AB25 -to Hex3[5]
set_location_assignment PIN_AB22 -to Hex3[6]
                                     
# set the hex 4                      
set_location_assignment PIN_AA24 -to Hex4[0]
set_location_assignment PIN_Y23 -to Hex4[1]
set_location_assignment PIN_Y24 -to Hex4[2]
set_location_assignment PIN_W22 -to Hex4[3]
set_location_assignment PIN_W24 -to Hex4[4]
set_location_assignment PIN_V23 -to Hex4[5]
set_location_assignment PIN_W25 -to Hex4[6]
                                     
# set the hex 3                      
# set_location_assignment PIN_V25  -to Hex5[0]
# set_location_assignment PIN_AA28 -to Hex5[1]
# set_location_assignment PIN_Y27  -to Hex5[2]
# set_location_assignment PIN_AB27 -to Hex5[3]
# set_location_assignment PIN_AB26 -to Hex5[4]
# set_location_assignment PIN_AA26 -to Hex5[5]
# set_location_assignment PIN_AA25 -to Hex5[6]


execute_flow -compile
project_close