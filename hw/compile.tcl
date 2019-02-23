
# Quartus II compile script for DE1-SoC  board

# 1] name your project here
set project_name "top_level"

file delete -force project
file delete -force output_files
file mkdir project
cd project
load_package flow
project_new $project_name
set_global_assignment -name FAMILY Cyclone
set_global_assignment -name DEVICE 5CSEMA5F31C6 
set_global_assignment -name TOP_LEVEL_ENTITY top_level
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY ../output_files

# 2] include your relative path files here
# set_global_assignment -name VHDL_FILE ../../src/ALU.vhd
# set_global_assignment -name VHDL_FILE ../../src/rising_edge_synchronizer.vhd
# set_global_assignment -name VHDL_FILE ../../src/seven_seg.vhd
# set_global_assignment -name VHDL_FILE ../../src/memory.vhd
# set_global_assignment -name VHDL_FILE ../../src/Generic_synchronizer.vhd
# set_global_assignment -name VHDL_FILE ../../src/my_components.vhd
set_global_assignment -name VHDL_FILE ../../src/top_level.vhd

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



# the LED is set here
set_location_assignment PIN_V16  -to LED[0]
set_location_assignment PIN_W16  -to LED[1]
set_location_assignment PIN_V17  -to LED[2]
set_location_assignment PIN_V18  -to LED[3]

# selection assignment for Execution
set_location_assignment PIN_AA14 -to resetBtn 


#set the hex0
set_location_assignment PIN_AE26 -to Hex0[0]
set_location_assignment PIN_AE27 -to Hex0[1]
set_location_assignment PIN_AE28 -to Hex0[2]
set_location_assignment PIN_AG27 -to Hex0[3]
set_location_assignment PIN_AF28 -to Hex0[4]
set_location_assignment PIN_AG28 -to Hex0[5]
set_location_assignment PIN_AH28 -to Hex0[6]
                                     
# set the hex 1                      
set_location_assignment PIN_AJ29 -to Hex1[0]
set_location_assignment PIN_AH29 -to Hex1[1]
set_location_assignment PIN_AH30 -to Hex1[2]
set_location_assignment PIN_AG30 -to Hex1[3]
set_location_assignment PIN_AF29 -to Hex1[4]
set_location_assignment PIN_AF30 -to Hex1[5]
set_location_assignment PIN_AD27 -to Hex1[6]
                                     
# set the hex 2                      
set_location_assignment PIN_AB23 -to Hex2[0]
set_location_assignment PIN_AE29 -to Hex2[1]
set_location_assignment PIN_AD29 -to Hex2[2]
set_location_assignment PIN_AC28 -to Hex2[3]
set_location_assignment PIN_AD30 -to Hex2[4]
set_location_assignment PIN_AC29 -to Hex2[5]
set_location_assignment PIN_AC30 -to Hex2[6]
                                     
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