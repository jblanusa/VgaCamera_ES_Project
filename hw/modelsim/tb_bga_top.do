onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {top level}
add wave -noupdate /tb_vga_top/vga_clk
add wave -noupdate /tb_vga_top/master_clk
add wave -noupdate /tb_vga_top/rst_tb
add wave -noupdate /tb_vga_top/hsync_tb
add wave -noupdate /tb_vga_top/vsync_tb
add wave -noupdate /tb_vga_top/I_VGA/hpos
add wave -noupdate /tb_vga_top/I_VGA/vpos
add wave -noupdate /tb_vga_top/R_fifo_out
add wave -noupdate /tb_vga_top/G_fifo_out
add wave -noupdate /tb_vga_top/B_fifo_out
add wave -noupdate /tb_vga_top/Rout_tb
add wave -noupdate /tb_vga_top/Gout_tb
add wave -noupdate /tb_vga_top/Bout_tb
add wave -noupdate /tb_vga_top/fifo_data_in
add wave -noupdate /tb_vga_top/fifo_data_out
add wave -noupdate /tb_vga_top/write_full
add wave -noupdate /tb_vga_top/write_empty
add wave -noupdate /tb_vga_top/write_halffull
add wave -noupdate /tb_vga_top/write_req
add wave -noupdate /tb_vga_top/read_req
add wave -noupdate /tb_vga_top/read_full
add wave -noupdate /tb_vga_top/read_empty
add wave -noupdate /tb_vga_top/I_FIFO/dcfifo_component/wrfull
add wave -noupdate -radix unsigned /tb_vga_top/wr_used
add wave -noupdate /tb_vga_top/aclr_top
add wave -noupdate -divider {VGA sync}
add wave -noupdate /tb_vga_top/I_VGA/state_reg
add wave -noupdate /tb_vga_top/I_VGA/state_next
add wave -noupdate /tb_vga_top/I_VGA/hcount_reg
add wave -noupdate /tb_vga_top/I_VGA/hcount_next
add wave -noupdate /tb_vga_top/I_VGA/vcount_reg
add wave -noupdate /tb_vga_top/I_VGA/vcount_next
add wave -noupdate /tb_vga_top/I_VGA/disp_ena
add wave -noupdate -divider Master
add wave -noupdate /tb_vga_top/I_MASTER/clk_50
add wave -noupdate /tb_vga_top/I_MASTER/rst
add wave -noupdate /tb_vga_top/I_MASTER/aclr
add wave -noupdate /tb_vga_top/I_MASTER/data_out
add wave -noupdate /tb_vga_top/I_MASTER/en_in
add wave -noupdate /tb_vga_top/I_MASTER/half
add wave -noupdate /tb_vga_top/I_MASTER/DisplayCom
add wave -noupdate -radix unsigned /tb_vga_top/I_MASTER/FBAdd
add wave -noupdate -radix unsigned /tb_vga_top/I_MASTER/FBLen
add wave -noupdate /tb_vga_top/I_MASTER/DisplayStat
add wave -noupdate -radix unsigned /tb_vga_top/I_MASTER/mm_paramm_address
add wave -noupdate /tb_vga_top/I_MASTER/mm_paramm_read
add wave -noupdate -radix unsigned /tb_vga_top/I_MASTER/mm_paramm_readdata
add wave -noupdate /tb_vga_top/I_MASTER/mm_paramm_readdatavalid
add wave -noupdate /tb_vga_top/I_MASTER/mm_paramm_waitrequest
add wave -noupdate /tb_vga_top/I_MASTER/mm_paramm_burstcount
add wave -noupdate /tb_vga_top/I_MASTER/state_reg
add wave -noupdate /tb_vga_top/I_MASTER/state_next
add wave -noupdate -radix unsigned /tb_vga_top/I_MASTER/current_address_reg
add wave -noupdate -radix unsigned /tb_vga_top/I_MASTER/current_address_next
add wave -noupdate -radix unsigned /tb_vga_top/I_MASTER/counter_reg
add wave -noupdate -radix unsigned /tb_vga_top/I_MASTER/counter_next
add wave -noupdate /tb_vga_top/I_MASTER/read_burst
add wave -noupdate -divider Driver
add wave -noupdate /tb_vga_top/I_DRIVER/clk_50
add wave -noupdate /tb_vga_top/I_DRIVER/rst
add wave -noupdate -radix unsigned /tb_vga_top/I_DRIVER/mm_paramm_address
add wave -noupdate /tb_vga_top/I_DRIVER/mm_paramm_read
add wave -noupdate /tb_vga_top/I_DRIVER/mm_paramm_readdata
add wave -noupdate /tb_vga_top/I_DRIVER/mm_paramm_readdatavalid
add wave -noupdate /tb_vga_top/I_DRIVER/mm_paramm_waitrequest
add wave -noupdate /tb_vga_top/I_DRIVER/mm_paramm_burstcount
add wave -noupdate /tb_vga_top/I_DRIVER/state_next
add wave -noupdate /tb_vga_top/I_DRIVER/state_reg
add wave -noupdate -radix unsigned /tb_vga_top/I_DRIVER/burstcount_reg
add wave -noupdate -radix unsigned /tb_vga_top/I_DRIVER/burstcount_next
add wave -noupdate -radix unsigned /tb_vga_top/I_DRIVER/address_reg
add wave -noupdate -radix unsigned /tb_vga_top/I_DRIVER/address_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6463 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 161
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
WaveRestoreZoom {0 ps} {116896 ps}
