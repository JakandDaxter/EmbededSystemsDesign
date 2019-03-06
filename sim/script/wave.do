onerror {resume}
radix define States {
    "7'b1000000" "0" -color "pink",
    "7'b1111001" "1" -color "pink",
    "7'b0100100" "2" -color "pink",
    "7'b0110000" "3" -color "pink",
    "7'b0011001" "4" -color "pink",
    "7'b0010010" "5" -color "pink",
    "7'b0000010" "6" -color "pink",
    "7'b1111000" "7" -color "pink",
    "7'b0000000" "8" -color "pink",
    "7'b0011000" "9" -color "pink",
    -default default
}


quietly WaveActivateNextPane {} 0

add wave -noupdate /top_level_tb/clk
add wave -noupdate /top_level_tb/switch_sig
add wave -noupdate /top_level_tb/pwm
add wave -noupdate /top_level_tb/LEDS
add wave -noupdate /top_level_tb/Button
add wave -noupdate /top_level_tb/Hex_2
add wave -noupdate /top_level_tb/Hex_3
add wave -noupdate /top_level_tb/Hex_4
add wave -noupdate /top_level_tb/Hex_5

TreeUpdate [SetDefaultTree]

WaveRestoreCursors {{Cursor 1} {50 ns} 0}

quietly wave cursor active 1

configure wave -namecolwidth 177
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update

WaveRestoreZoom {0 ns} {1000 ns}
