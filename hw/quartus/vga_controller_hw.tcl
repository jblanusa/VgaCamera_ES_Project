# TCL File Generated by Component Editor 16.0
# Fri Dec 23 05:15:01 CET 2016
# DO NOT MODIFY


# 
# vga_controller "vga_controller" v1.0
#  2016.12.23.05:15:01
# 
# 

# 
# request TCL package from ACDS 16.0
# 
package require -exact qsys 16.0


# 
# module vga_controller
# 
set_module_property DESCRIPTION ""
set_module_property NAME vga_controller
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME vga_controller
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL VGA_controller
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file VGA_controller.vhd VHDL PATH ../hdl/VGA_controller.vhd TOP_LEVEL_FILE
add_fileset_file Master_component.vhd VHDL PATH ../hdl/Master_component.vhd
add_fileset_file Slave_component.vhd VHDL PATH ../hdl/Slave_component.vhd
add_fileset_file vga_sync.vhd VHDL PATH ../hdl/vga_sync.vhd
add_fileset_file vga_pkg.vhd VHDL PATH ../hdl/vga_pkg.vhd
add_fileset_file fifo64.vhd VHDL PATH ip/fifo64/fifo64.vhd


# 
# parameters
# 


# 
# display items
# 


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock_sink_main
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point mm_params
# 
add_interface mm_params avalon end
set_interface_property mm_params addressUnits WORDS
set_interface_property mm_params associatedClock clock_sink_main
set_interface_property mm_params associatedReset reset
set_interface_property mm_params bitsPerSymbol 8
set_interface_property mm_params burstOnBurstBoundariesOnly false
set_interface_property mm_params burstcountUnits WORDS
set_interface_property mm_params explicitAddressSpan 0
set_interface_property mm_params holdTime 0
set_interface_property mm_params linewrapBursts false
set_interface_property mm_params maximumPendingReadTransactions 0
set_interface_property mm_params maximumPendingWriteTransactions 0
set_interface_property mm_params readLatency 0
set_interface_property mm_params readWaitTime 1
set_interface_property mm_params setupTime 0
set_interface_property mm_params timingUnits Cycles
set_interface_property mm_params writeWaitTime 0
set_interface_property mm_params ENABLED true
set_interface_property mm_params EXPORT_OF ""
set_interface_property mm_params PORT_NAME_MAP ""
set_interface_property mm_params CMSIS_SVD_VARIABLES ""
set_interface_property mm_params SVD_ADDRESS_GROUP ""

add_interface_port mm_params mm_params_address address Input 28
add_interface_port mm_params mm_params_read read Input 1
add_interface_port mm_params mm_params_readdata readdata Output 32
add_interface_port mm_params mm_params_write write Input 1
add_interface_port mm_params mm_params_writedata writedata Input 32
add_interface_port mm_params mm_params_waitrequest waitrequest Output 1
set_interface_assignment mm_params embeddedsw.configuration.isFlash 0
set_interface_assignment mm_params embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment mm_params embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment mm_params embeddedsw.configuration.isPrintableDevice 0


# 
# connection point conduit_vga
# 
add_interface conduit_vga conduit end
set_interface_property conduit_vga associatedClock clock_sink_main
set_interface_property conduit_vga associatedReset reset
set_interface_property conduit_vga ENABLED true
set_interface_property conduit_vga EXPORT_OF ""
set_interface_property conduit_vga PORT_NAME_MAP ""
set_interface_property conduit_vga CMSIS_SVD_VARIABLES ""
set_interface_property conduit_vga SVD_ADDRESS_GROUP ""

add_interface_port conduit_vga VGA_BOARD_ID board_id Bidir 1
add_interface_port conduit_vga VGA_CAM_PAL_VGA_SCL vga_scl Output 1
add_interface_port conduit_vga VGA_CAM_PAL_VGA_SDA vga_sda Bidir 1
add_interface_port conduit_vga VGA_VIDEO_B vga_video_b Output 8
add_interface_port conduit_vga VGA_VIDEO_CLK vga_clk Output 1
add_interface_port conduit_vga VGA_VIDEO_G vga_video_g Output 8
add_interface_port conduit_vga VGA_VIDEO_HSYNC vga_hsync Output 1
add_interface_port conduit_vga VGA_VIDEO_R vga_video_r Output 8
add_interface_port conduit_vga VGA_VIDEO_VSYNC vga_vsync Output 1


# 
# connection point clock_sink_main
# 
add_interface clock_sink_main clock end
set_interface_property clock_sink_main clockRate 0
set_interface_property clock_sink_main ENABLED true
set_interface_property clock_sink_main EXPORT_OF ""
set_interface_property clock_sink_main PORT_NAME_MAP ""
set_interface_property clock_sink_main CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink_main SVD_ADDRESS_GROUP ""

add_interface_port clock_sink_main master_clk clk Input 1


# 
# connection point clock_sink_vga
# 
add_interface clock_sink_vga clock end
set_interface_property clock_sink_vga clockRate 0
set_interface_property clock_sink_vga ENABLED true
set_interface_property clock_sink_vga EXPORT_OF ""
set_interface_property clock_sink_vga PORT_NAME_MAP ""
set_interface_property clock_sink_vga CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink_vga SVD_ADDRESS_GROUP ""

add_interface_port clock_sink_vga vga_clk clk Input 1


# 
# connection point mm_paramm
# 
add_interface mm_paramm avalon start
set_interface_property mm_paramm addressUnits SYMBOLS
set_interface_property mm_paramm associatedClock clock_sink_main
set_interface_property mm_paramm associatedReset reset
set_interface_property mm_paramm bitsPerSymbol 8
set_interface_property mm_paramm burstOnBurstBoundariesOnly false
set_interface_property mm_paramm burstcountUnits WORDS
set_interface_property mm_paramm doStreamReads false
set_interface_property mm_paramm doStreamWrites false
set_interface_property mm_paramm holdTime 0
set_interface_property mm_paramm linewrapBursts false
set_interface_property mm_paramm maximumPendingReadTransactions 0
set_interface_property mm_paramm maximumPendingWriteTransactions 0
set_interface_property mm_paramm readLatency 0
set_interface_property mm_paramm readWaitTime 1
set_interface_property mm_paramm setupTime 0
set_interface_property mm_paramm timingUnits Cycles
set_interface_property mm_paramm writeWaitTime 0
set_interface_property mm_paramm ENABLED true
set_interface_property mm_paramm EXPORT_OF ""
set_interface_property mm_paramm PORT_NAME_MAP ""
set_interface_property mm_paramm CMSIS_SVD_VARIABLES ""
set_interface_property mm_paramm SVD_ADDRESS_GROUP ""

add_interface_port mm_paramm mm_paramm_address address Output 32
add_interface_port mm_paramm mm_paramm_read read Output 1
add_interface_port mm_paramm mm_paramm_readdata readdata Input 32
add_interface_port mm_paramm mm_paramm_readdatavalid readdatavalid Input 1
add_interface_port mm_paramm mm_paramm_waitrequest waitrequest Input 1
add_interface_port mm_paramm mm_paramm_burstcount burstcount Output 6
add_interface_port mm_paramm mm_paramm_byteenable byteenable Output 4


# 
# connection point conduit_debug
# 
add_interface conduit_debug conduit end
set_interface_property conduit_debug associatedClock clock_sink_main
set_interface_property conduit_debug associatedReset reset
set_interface_property conduit_debug ENABLED true
set_interface_property conduit_debug EXPORT_OF ""
set_interface_property conduit_debug PORT_NAME_MAP ""
set_interface_property conduit_debug CMSIS_SVD_VARIABLES ""
set_interface_property conduit_debug SVD_ADDRESS_GROUP ""

add_interface_port conduit_debug FIFO_EMPTY fifo_empty Output 1
add_interface_port conduit_debug FIFO_FULL fifo_full Output 1
add_interface_port conduit_debug FIFO_HALF fifo_half Output 1
add_interface_port conduit_debug WAITREQ waitreq Output 1
add_interface_port conduit_debug READVALID readvalid Output 1
add_interface_port conduit_debug DISPLAY_COM_OUT disp_com Output 1
add_interface_port conduit_debug DISPLAY_STAT_OUT disp_stat Output 1
add_interface_port conduit_debug BURST_COUNT burst_count Output 6
add_interface_port conduit_debug MASTER_READ read Output 1
add_interface_port conduit_debug MASTER_STATE state Output 3

