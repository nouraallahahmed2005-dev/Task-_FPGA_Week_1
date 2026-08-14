onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group clk_rst /top_module_tb/ACLK
add wave -noupdate -expand -group clk_rst /top_module_tb/ARESETN
add wave -noupdate -expand -group write_data_channel /top_module_tb/WVALID
add wave -noupdate -expand -group write_data_channel /top_module_tb/WREADY
add wave -noupdate -expand -group write_data_channel /top_module_tb/WSTRB
add wave -noupdate -expand -group write_data_channel /top_module_tb/WDATA
add wave -noupdate -expand -group read_data_channel /top_module_tb/RVALID
add wave -noupdate -expand -group read_data_channel /top_module_tb/RRESP
add wave -noupdate -expand -group read_data_channel /top_module_tb/RREADY
add wave -noupdate -expand -group read_data_channel /top_module_tb/RDATA
add wave -noupdate -expand -group response_channel /top_module_tb/BVALID
add wave -noupdate -expand -group response_channel /top_module_tb/BRESP
add wave -noupdate -expand -group response_channel /top_module_tb/BREADY
add wave -noupdate -expand -group write_address_channel /top_module_tb/AWVALID
add wave -noupdate -expand -group write_address_channel /top_module_tb/AWREADY
add wave -noupdate -expand -group write_address_channel /top_module_tb/AWADDR
add wave -noupdate -expand -group read_address_channel /top_module_tb/ARVALID
add wave -noupdate -expand -group read_address_channel /top_module_tb/ARREADY
add wave -noupdate -expand -group read_address_channel /top_module_tb/ARADDR
add wave -noupdate -expand -group pass_fail_count /top_module_tb/pass_count
add wave -noupdate -expand -group pass_fail_count /top_module_tb/fail_count
add wave -noupdate -expand -group reg_file_signals /top_module_tb/DUT/RF/write_strobe
add wave -noupdate -expand -group reg_file_signals /top_module_tb/DUT/RF/write_error
add wave -noupdate -expand -group reg_file_signals /top_module_tb/DUT/RF/write_enable
add wave -noupdate -expand -group reg_file_signals /top_module_tb/DUT/RF/write_done
add wave -noupdate -expand -group reg_file_signals /top_module_tb/DUT/RF/write_data
add wave -noupdate -expand -group reg_file_signals /top_module_tb/DUT/RF/write_address
add wave -noupdate -expand -group reg_file_signals /top_module_tb/DUT/RF/read_error
add wave -noupdate -expand -group reg_file_signals /top_module_tb/DUT/RF/read_enable
add wave -noupdate -expand -group reg_file_signals /top_module_tb/DUT/RF/read_done
add wave -noupdate -expand -group reg_file_signals /top_module_tb/DUT/RF/read_data
add wave -noupdate -expand -group reg_file_signals /top_module_tb/DUT/RF/read_address
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 135
configure wave -valuecolwidth 79
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {882 ns}
