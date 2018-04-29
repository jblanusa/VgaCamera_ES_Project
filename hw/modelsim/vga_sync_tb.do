onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_vga_sync/clk_tb
add wave -noupdate /tb_vga_sync/rst_tb
add wave -noupdate /tb_vga_sync/hpos_tb
add wave -noupdate /tb_vga_sync/vpos_tb
add wave -noupdate /tb_vga_sync/R_tb
add wave -noupdate /tb_vga_sync/G_tb
add wave -noupdate /tb_vga_sync/B_tb
add wave -noupdate /tb_vga_sync/Rout_tb
add wave -noupdate /tb_vga_sync/Gout_tb
add wave -noupdate /tb_vga_sync/Bout_tb
add wave -noupdate /tb_vga_sync/hsync_tb
add wave -noupdate /tb_vga_sync/vsync_tb
add wave -noupdate /tb_vga_sync/npix_tb
add wave -noupdate /tb_vga_sync/done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {234 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ns} {1 us}
