onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mux4_struct/a
add wave -noupdate /mux4_struct/b
add wave -noupdate /mux4_struct/c
add wave -noupdate /mux4_struct/d
add wave -noupdate -divider -height 30 {in & out}
add wave -noupdate /mux4_struct/sel
add wave -noupdate /mux4_struct/out
add wave -noupdate /mux4_struct/w1
add wave -noupdate /mux4_struct/w2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {370 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {204 ps} {410 ps}
