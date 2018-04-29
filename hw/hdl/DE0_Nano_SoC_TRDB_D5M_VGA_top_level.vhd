-- #############################################################################
-- DE0_Nano_SoC_TRDB_D5M_VGA_top_level.vhd
--
-- BOARD         : DE0-Nano-SoC from Terasic
-- Author        : Sahand Kashani-Akhavan from Terasic documentation
-- Revision      : 1.2
-- Creation date : 11/06/2015
--
-- Syntax Rule : GROUP_NAME_N[bit]
--
-- GROUP : specify a particular interface (ex: SDR_)
-- NAME  : signal name (ex: CONFIG, D, ...)
-- bit   : signal index
-- _N    : to specify an active-low signal
-- #############################################################################

library ieee;
use ieee.std_logic_1164.all;

entity DE0_Nano_SoC_TRDB_D5M_VGA_top_level is
    port(
        -- ADC
        ADC_CONVST                 : out   std_logic;
        ADC_SCK                    : out   std_logic;
        ADC_SDI                    : out   std_logic;
        ADC_SDO                    : in    std_logic;

        -- ARDUINO
        ARDUINO_IO                 : inout std_logic_vector(15 downto 0);
        ARDUINO_RESET_N            : inout std_logic;

        -- CLOCK
        FPGA_CLK1_50               : in    std_logic;
        FPGA_CLK2_50               : in    std_logic;
        FPGA_CLK3_50               : in    std_logic;

        -- KEY
        KEY_N                      : in    std_logic_vector(1 downto 0);

        -- LED
        LED                        : out   std_logic_vector(7 downto 0);

        -- SW
        SW                         : in    std_logic_vector(3 downto 0);

        -- GPIO_0
        GPIO_0_VGA_VIDEO_R         : out   std_logic_vector(7 downto 0);
        GPIO_0_VGA_VIDEO_G         : out   std_logic_vector(7 downto 0);
        GPIO_0_VGA_VIDEO_B         : out   std_logic_vector(7 downto 0);
        GPIO_0_VGA_VIDEO_HSYNC     : out   std_logic;
        GPIO_0_VGA_VIDEO_VSYNC     : out   std_logic;
        GPIO_0_VGA_VIDEO_CLK       : out   std_logic;
        GPIO_0_VGA_CAM_PAL_VGA_SCL : out   std_logic;
        GPIO_0_VGA_CAM_PAL_VGA_SDA : inout std_logic;
        GPIO_0_VGA_BOARD_ID        : inout std_logic;

        -- GPIO_1
        GPIO_1_D5M_D               : in    std_logic_vector(11 downto 0); -- in
        GPIO_1_D5M_FVAL            : in    std_logic;
        GPIO_1_D5M_LVAL            : in    std_logic;
        GPIO_1_D5M_PIXCLK          : in    std_logic;
        GPIO_1_D5M_RESET_N         : out   std_logic;
        GPIO_1_D5M_SCLK            : inout std_logic;
        GPIO_1_D5M_SDATA           : inout std_logic;
        GPIO_1_D5M_STROBE          : in    std_logic;
        GPIO_1_D5M_TRIGGER         : out   std_logic;
        GPIO_1_D5M_XCLKIN          : out   std_logic;

        -- HPS
        HPS_CONV_USB_N             : inout std_logic;
        HPS_DDR3_ADDR              : out   std_logic_vector(14 downto 0);
        HPS_DDR3_BA                : out   std_logic_vector(2 downto 0);
        HPS_DDR3_CAS_N             : out   std_logic;
        HPS_DDR3_CK_N              : out   std_logic;
        HPS_DDR3_CK_P              : out   std_logic;
        HPS_DDR3_CKE               : out   std_logic;
        HPS_DDR3_CS_N              : out   std_logic;
        HPS_DDR3_DM                : out   std_logic_vector(3 downto 0);
        HPS_DDR3_DQ                : inout std_logic_vector(31 downto 0);
        HPS_DDR3_DQS_N             : inout std_logic_vector(3 downto 0);
        HPS_DDR3_DQS_P             : inout std_logic_vector(3 downto 0);
        HPS_DDR3_ODT               : out   std_logic;
        HPS_DDR3_RAS_N             : out   std_logic;
        HPS_DDR3_RESET_N           : out   std_logic;
        HPS_DDR3_RZQ               : in    std_logic;
        HPS_DDR3_WE_N              : out   std_logic;
        HPS_ENET_GTX_CLK           : out   std_logic;
        HPS_ENET_INT_N             : inout std_logic;
        HPS_ENET_MDC               : out   std_logic;
        HPS_ENET_MDIO              : inout std_logic;
        HPS_ENET_RX_CLK            : in    std_logic;
        HPS_ENET_RX_DATA           : in    std_logic_vector(3 downto 0);
        HPS_ENET_RX_DV             : in    std_logic;
        HPS_ENET_TX_DATA           : out   std_logic_vector(3 downto 0);
        HPS_ENET_TX_EN             : out   std_logic;
        HPS_GSENSOR_INT            : inout std_logic;
        HPS_I2C0_SCLK              : inout std_logic;
        HPS_I2C0_SDAT              : inout std_logic;
        HPS_I2C1_SCLK              : inout std_logic;
        HPS_I2C1_SDAT              : inout std_logic;
        HPS_KEY_N                  : inout std_logic;
        HPS_LED                    : inout std_logic;
        HPS_LTC_GPIO               : inout std_logic;
        HPS_SD_CLK                 : out   std_logic;
        HPS_SD_CMD                 : inout std_logic;
        HPS_SD_DATA                : inout std_logic_vector(3 downto 0);
        HPS_SPIM_CLK               : out   std_logic;
        HPS_SPIM_MISO              : in    std_logic;
        HPS_SPIM_MOSI              : out   std_logic;
        HPS_SPIM_SS                : inout std_logic;
        HPS_UART_RX                : in    std_logic;
        HPS_UART_TX                : out   std_logic;
        HPS_USB_CLKOUT             : in    std_logic;
        HPS_USB_DATA               : inout std_logic_vector(7 downto 0);
        HPS_USB_DIR                : in    std_logic;
        HPS_USB_NXT                : in    std_logic;
        HPS_USB_STP                : out   std_logic
    );
end entity DE0_Nano_SoC_TRDB_D5M_VGA_top_level;

architecture rtl of DE0_Nano_SoC_TRDB_D5M_VGA_top_level is

    component soc_system is
        port (
            clk_clk                           : in    std_logic                     := 'X';
            reset_reset_n                     : in    std_logic                     := 'X';
				pll_0_outclk1_clk                        : out   std_logic ;
				
				-- VGA
				vga_controller_0_conduit_vga_board_id    : inout std_logic                     := 'X';             -- board_id
				vga_controller_0_conduit_vga_vga_scl     : out   std_logic;                                        -- vga_scl
				vga_controller_0_conduit_vga_vga_sda     : inout std_logic                     := 'X';             -- vga_sda
				vga_controller_0_conduit_vga_vga_video_b : out   std_logic_vector(7 downto 0);                     -- vga_video_b
				vga_controller_0_conduit_vga_vga_clk     : out   std_logic;                                        -- vga_clk
				vga_controller_0_conduit_vga_vga_video_g : out   std_logic_vector(7 downto 0);                     -- vga_video_g
				vga_controller_0_conduit_vga_vga_hsync   : out   std_logic;                                        -- vga_hsync
				vga_controller_0_conduit_vga_vga_video_r : out   std_logic_vector(7 downto 0);                     -- vga_video_r
				vga_controller_0_conduit_vga_vga_vsync   : out   std_logic;       
				
				vga_controller_0_conduit_debug_fifo_empty : out   std_logic;                                        -- fifo_empty
				vga_controller_0_conduit_debug_fifo_full  : out   std_logic;                                        -- fifo_full
				vga_controller_0_conduit_debug_fifo_half  : out   std_logic;                                        -- fifo_half
				vga_controller_0_conduit_debug_waitreq    : out   std_logic;                                        -- waitreq
				vga_controller_0_conduit_debug_readvalid  : out   std_logic;                                        -- readvalid
				vga_controller_0_conduit_debug_disp_com   : out   std_logic;                                        -- disp_com
				vga_controller_0_conduit_debug_disp_stat  : out   std_logic;
				vga_controller_0_conduit_debug_burst_count : out   std_logic_vector(4 downto 0);                     -- burst_count
				vga_controller_0_conduit_debug_read        : out   std_logic;                                        -- read
				vga_controller_0_conduit_debug_state       : out   std_logic_vector(2 downto 0);                     -- state			
				
				-- VGA sync test
	--			vga_sync_test_0_conduit_end_vga_r        : out   std_logic_vector(7 downto 0);                     -- vga_r
	--			vga_sync_test_0_conduit_end_vga_g        : out   std_logic_vector(7 downto 0);                     -- vga_g
	--			vga_sync_test_0_conduit_end_vga_b        : out   std_logic_vector(7 downto 0);                     -- vga_b
	--			vga_sync_test_0_conduit_end_vga_hsync    : out   std_logic;                                        -- vga_hsync
	--			vga_sync_test_0_conduit_end_vga_vsync    : out   std_logic;                                        -- vga_vsync
	--			vga_sync_test_0_conduit_end_vga_clk      : out   std_logic;                                        -- vga_clk
	--			vga_sync_test_0_conduit_end_vga_scl      : out   std_logic;                                        -- vga_scl
	--			vga_sync_test_0_conduit_end_vga_sda      : inout std_logic                     := 'X';             -- vga_sda
	--			vga_sync_test_0_conduit_end_vga_id       : inout std_logic                     := 'X';              -- vga_id
				
				-- VGA fifo test
	--			vga_fifo_test_0_conduit_end_vga_r                         : out   std_logic_vector(7 downto 0);                     -- vga_r
	--			vga_fifo_test_0_conduit_end_vga_g                         : out   std_logic_vector(7 downto 0);                     -- vga_g
	--			vga_fifo_test_0_conduit_end_vga_b                         : out   std_logic_vector(7 downto 0);                     -- vga_b
	--			vga_fifo_test_0_conduit_end_vga_hsync 							 : out   std_logic;                                        -- writeresponsevalid_nvga_hsync
	--			vga_fifo_test_0_conduit_end_vga_vsync                     : out   std_logic;                                        -- vga_vsync
	--			vga_fifo_test_0_conduit_end_vga_clk                       : out   std_logic;                                        -- vga_clk
	--			vga_fifo_test_0_conduit_end_vga_scl                       : out   std_logic;                                        -- vga_scl
	--			vga_fifo_test_0_conduit_end_vga_sda                       : inout std_logic                     := 'X';             -- vga_sda
	--			vga_fifo_test_0_conduit_end_vga_board_id                  : inout std_logic                     := 'X';             -- vga_board_id
				
				-- Camera controller
				camera_controller_0_conduit_camera_pixclk      : in    std_logic                     := 'X';             -- pixclk
				camera_controller_0_conduit_camera_frame_valid : in    std_logic                     := 'X';             -- frame_valid
				camera_controller_0_conduit_camera_line_valid  : in    std_logic                     := 'X';             -- line_valid
				camera_controller_0_conduit_camera_cam_reset   : out   std_logic;                                        -- cam_reset
				camera_controller_0_conduit_camera_data_in     : in    std_logic_vector(11 downto 0) := (others => 'X');  -- data_in
				pll_0_cam_clk_clk                              : out   std_logic;                                        -- clk
				pll_0_cam2_clk_clk                              : out   std_logic;
				pll_0_cam3_clk_clk                              : out   std_logic;
				pll_0_cam4_clk_clk                              : out   std_logic;
				
				-- I2C
				i2c_0_i2c_scl                                  : inout std_logic                     := 'X';             -- scl
				i2c_0_i2c_sda                                  : inout std_logic                     := 'X';              -- sda
				
				-- VGA top test
	--			vga_top_test_0_conduit_end_vga_r                          : out   std_logic_vector(7 downto 0);                     -- vga_r
	--			vga_top_test_0_conduit_end_vga_g                          : out   std_logic_vector(7 downto 0);                     -- vga_g
	--			vga_top_test_0_conduit_end_vga_b                          : out   std_logic_vector(7 downto 0);                     -- vga_b
	--			vga_top_test_0_conduit_end_vga_hsync                      : out   std_logic;                                        -- vga_hsync
	--			vga_top_test_0_conduit_end_vga_vsync                      : out   std_logic;                                        -- vga_vsync
	--			vga_top_test_0_conduit_end_vga_clk                        : out   std_logic;                                        -- vga_clk
	--			vga_top_test_0_conduit_end_vga_scl                        : out   std_logic;                                        -- vga_scl
	--			vga_top_test_0_conduit_end_vga_sda                        : inout std_logic                     := 'X';             -- vga_sda
	--			vga_top_test_0_conduit_end_vga_board_id                   : inout std_logic                     := 'X';              -- vga_board_id
				
				-- VGA cont test
	--			vga_cont_test_0_conduit_end_vga_r        : out   std_logic_vector(7 downto 0);                     -- vga_r
	--			vga_cont_test_0_conduit_end_vga_g        : out   std_logic_vector(7 downto 0);                     -- vga_g
	--			vga_cont_test_0_conduit_end_vga_b        : out   std_logic_vector(7 downto 0);                     -- vga_b
	--			vga_cont_test_0_conduit_end_vga_hsync    : out   std_logic;                                        -- vga_hsync
	--			vga_cont_test_0_conduit_end_vga_vsync    : out   std_logic;                                        -- vga_vsync
	--			vga_cont_test_0_conduit_end_vga_clk      : out   std_logic;                                        -- vga_clk
	--			vga_cont_test_0_conduit_end_vga_scl      : out   std_logic;                                        -- vga_scl
	--			vga_cont_test_0_conduit_end_vga_sda      : inout std_logic                     := 'X';             -- vga_sda
	--			vga_cont_test_0_conduit_end_vga_board_id : inout std_logic                     := 'X';             -- vga_board_id
				
				-- HPS
            hps_0_ddr_mem_a                   : out   std_logic_vector(14 downto 0);
            hps_0_ddr_mem_ba                  : out   std_logic_vector(2 downto 0);
            hps_0_ddr_mem_ck                  : out   std_logic;
            hps_0_ddr_mem_ck_n                : out   std_logic;
            hps_0_ddr_mem_cke                 : out   std_logic;
            hps_0_ddr_mem_cs_n                : out   std_logic;
            hps_0_ddr_mem_ras_n               : out   std_logic;
            hps_0_ddr_mem_cas_n               : out   std_logic;
            hps_0_ddr_mem_we_n                : out   std_logic;
            hps_0_ddr_mem_reset_n             : out   std_logic;
            hps_0_ddr_mem_dq                  : inout std_logic_vector(31 downto 0) := (others => 'X');
            hps_0_ddr_mem_dqs                 : inout std_logic_vector(3 downto 0)  := (others => 'X');
            hps_0_ddr_mem_dqs_n               : inout std_logic_vector(3 downto 0)  := (others => 'X');
            hps_0_ddr_mem_odt                 : out   std_logic;
            hps_0_ddr_mem_dm                  : out   std_logic_vector(3 downto 0);
            hps_0_ddr_oct_rzqin               : in    std_logic                     := 'X';
            hps_0_io_hps_io_emac1_inst_TX_CLK : out   std_logic;
            hps_0_io_hps_io_emac1_inst_TX_CTL : out   std_logic;
            hps_0_io_hps_io_emac1_inst_TXD0   : out   std_logic;
            hps_0_io_hps_io_emac1_inst_TXD1   : out   std_logic;
            hps_0_io_hps_io_emac1_inst_TXD2   : out   std_logic;
            hps_0_io_hps_io_emac1_inst_TXD3   : out   std_logic;
            hps_0_io_hps_io_emac1_inst_RX_CLK : in    std_logic                     := 'X';
            hps_0_io_hps_io_emac1_inst_RX_CTL : in    std_logic                     := 'X';
            hps_0_io_hps_io_emac1_inst_RXD0   : in    std_logic                     := 'X';
            hps_0_io_hps_io_emac1_inst_RXD1   : in    std_logic                     := 'X';
            hps_0_io_hps_io_emac1_inst_RXD2   : in    std_logic                     := 'X';
            hps_0_io_hps_io_emac1_inst_RXD3   : in    std_logic                     := 'X';
            hps_0_io_hps_io_emac1_inst_MDIO   : inout std_logic                     := 'X';
            hps_0_io_hps_io_emac1_inst_MDC    : out   std_logic;
            hps_0_io_hps_io_sdio_inst_CLK     : out   std_logic;
            hps_0_io_hps_io_sdio_inst_CMD     : inout std_logic                     := 'X';
            hps_0_io_hps_io_sdio_inst_D0      : inout std_logic                     := 'X';
            hps_0_io_hps_io_sdio_inst_D1      : inout std_logic                     := 'X';
            hps_0_io_hps_io_sdio_inst_D2      : inout std_logic                     := 'X';
            hps_0_io_hps_io_sdio_inst_D3      : inout std_logic                     := 'X';
            hps_0_io_hps_io_usb1_inst_CLK     : in    std_logic                     := 'X';
            hps_0_io_hps_io_usb1_inst_STP     : out   std_logic;
            hps_0_io_hps_io_usb1_inst_DIR     : in    std_logic                     := 'X';
            hps_0_io_hps_io_usb1_inst_NXT     : in    std_logic                     := 'X';
            hps_0_io_hps_io_usb1_inst_D0      : inout std_logic                     := 'X';
            hps_0_io_hps_io_usb1_inst_D1      : inout std_logic                     := 'X';
            hps_0_io_hps_io_usb1_inst_D2      : inout std_logic                     := 'X';
            hps_0_io_hps_io_usb1_inst_D3      : inout std_logic                     := 'X';
            hps_0_io_hps_io_usb1_inst_D4      : inout std_logic                     := 'X';
            hps_0_io_hps_io_usb1_inst_D5      : inout std_logic                     := 'X';
            hps_0_io_hps_io_usb1_inst_D6      : inout std_logic                     := 'X';
            hps_0_io_hps_io_usb1_inst_D7      : inout std_logic                     := 'X';
            hps_0_io_hps_io_spim1_inst_CLK    : out   std_logic;
            hps_0_io_hps_io_spim1_inst_MOSI   : out   std_logic;
            hps_0_io_hps_io_spim1_inst_MISO   : in    std_logic                     := 'X';
            hps_0_io_hps_io_spim1_inst_SS0    : out   std_logic;
            hps_0_io_hps_io_uart0_inst_RX     : in    std_logic                     := 'X';
            hps_0_io_hps_io_uart0_inst_TX     : out   std_logic;
            hps_0_io_hps_io_i2c0_inst_SDA     : inout std_logic                     := 'X';
            hps_0_io_hps_io_i2c0_inst_SCL     : inout std_logic                     := 'X';
            hps_0_io_hps_io_i2c1_inst_SDA     : inout std_logic                     := 'X';
            hps_0_io_hps_io_i2c1_inst_SCL     : inout std_logic                     := 'X';
            hps_0_io_hps_io_gpio_inst_GPIO09  : inout std_logic                     := 'X';
            hps_0_io_hps_io_gpio_inst_GPIO35  : inout std_logic                     := 'X';
            hps_0_io_hps_io_gpio_inst_GPIO40  : inout std_logic                     := 'X';
            hps_0_io_hps_io_gpio_inst_GPIO53  : inout std_logic                     := 'X';
            hps_0_io_hps_io_gpio_inst_GPIO54  : inout std_logic                     := 'X';
            hps_0_io_hps_io_gpio_inst_GPIO61  : inout std_logic                     := 'X'
        );
    end component soc_system;
	  
	 signal clkout : std_logic;
	 
	 signal vga_r1, vga_b1, vga_g1 : std_logic_vector(7 downto 0);
	 signal vga_hsync1, vga_vsync1 : std_logic;
	 
	 signal xclk10, xclk20, xclk40, xclk50 : std_logic;
	 
	 signal fifo_empty, fifo_full, fifo_half : std_logic;
	 signal avalon_waitreq, avalon_readvalid : std_logic;
	 
	 signal state : std_logic_vector(2 downto 0);
begin
	
	 clkout <= FPGA_CLK1_50;
	 
	 GPIO_0_VGA_VIDEO_R <= vga_r1;								  
	 GPIO_0_VGA_VIDEO_G <= vga_g1;								  
	 GPIO_0_VGA_VIDEO_B <= vga_b1;	 
	 GPIO_0_VGA_VIDEO_HSYNC <= vga_hsync1;										  
	 GPIO_0_VGA_VIDEO_VSYNC <= vga_vsync1;
	 
	 GPIO_1_D5M_XCLKIN <= xclk10 when SW(1 downto 0) = "00" else
								 xclk20 when SW(1 downto 0) = "01" else
								 xclk40 when SW(1 downto 0) = "11" else
								 xclk50;
	 
	 LED(0) <= fifo_empty;
	 LED(1) <= fifo_full;
	 LED(2) <= fifo_half;
	 
	 LED(3) <= avalon_waitreq;
	 LED(4) <= avalon_readvalid;
	 
	 LED(7 downto 5) <= state;
	 
	 
    u0 : component soc_system
       port map(
            clk_clk                           => clkout,
            reset_reset_n                     => '1',
				pll_0_outclk1_clk                 => GPIO_0_VGA_VIDEO_CLK,
				-- VGA
				
				vga_controller_0_conduit_vga_board_id    => GPIO_0_VGA_BOARD_ID,
				vga_controller_0_conduit_vga_vga_scl     => GPIO_0_VGA_CAM_PAL_VGA_SCL,
				vga_controller_0_conduit_vga_vga_sda     => GPIO_0_VGA_CAM_PAL_VGA_SDA,
				vga_controller_0_conduit_vga_vga_video_b => vga_b1,
				vga_controller_0_conduit_vga_vga_clk     => open,
				vga_controller_0_conduit_vga_vga_video_g => vga_g1,
				vga_controller_0_conduit_vga_vga_hsync   => vga_hsync1,
				vga_controller_0_conduit_vga_vga_video_r => vga_r1,
				vga_controller_0_conduit_vga_vga_vsync   => vga_vsync1,
				
				vga_controller_0_conduit_debug_fifo_empty => fifo_empty, -- vga_controller_0_conduit_debug.fifo_empty
				vga_controller_0_conduit_debug_fifo_full  => fifo_full,  --                               .fifo_full
				vga_controller_0_conduit_debug_fifo_half  => fifo_half,  --                               .fifo_half
				vga_controller_0_conduit_debug_waitreq    => avalon_waitreq,    --                               .waitreq
				vga_controller_0_conduit_debug_readvalid  => avalon_readvalid,  --                               .readvalid
				vga_controller_0_conduit_debug_disp_com   => open,   --                               .disp_com
				vga_controller_0_conduit_debug_disp_stat  => open,  --                               .disp_stat
				vga_controller_0_conduit_debug_burst_count => open, --                               .burst_count
				vga_controller_0_conduit_debug_read        => open,        --                               .read
				vga_controller_0_conduit_debug_state       => state,        --                               .state
			
				--VGA test
				
	--			vga_sync_test_0_conduit_end_vga_r        => vga_r2,        --  vga_sync_test_0_conduit_end.vga_r
	--			vga_sync_test_0_conduit_end_vga_g        => vga_g2,        --                             .vga_g
	--			vga_sync_test_0_conduit_end_vga_b        => vga_b2,        --                             .vga_b
	--			vga_sync_test_0_conduit_end_vga_hsync    => vga_hsync2,    --                             .vga_hsync
	--			vga_sync_test_0_conduit_end_vga_vsync    => vga_vsync2,    --                             .vga_vsync
	--			vga_sync_test_0_conduit_end_vga_clk      => open,      --                             .vga_clk
	--			vga_sync_test_0_conduit_end_vga_scl      => open,      --                             .vga_scl
	--			vga_sync_test_0_conduit_end_vga_sda      => open,      --                             .vga_sda
	--			vga_sync_test_0_conduit_end_vga_id       => open,        --                             .vga_id
				
				-- VGA fifo test
	--			vga_fifo_test_0_conduit_end_vga_r        => vga_r3,        --  vga_fifo_test_0_conduit_end.vga_r
	--			vga_fifo_test_0_conduit_end_vga_g        => vga_g3,        --                             .vga_g
	--			vga_fifo_test_0_conduit_end_vga_b        => vga_b3,        --                             .vga_b
	--			vga_fifo_test_0_conduit_end_vga_hsync    => vga_hsync3,    --                             .vga_hsync
	--			vga_fifo_test_0_conduit_end_vga_vsync    => vga_vsync3,    --                             .vga_vsync
	--			vga_fifo_test_0_conduit_end_vga_clk      => open,      --                             .vga_clk
	--			vga_fifo_test_0_conduit_end_vga_scl      => open,      --                             .vga_scl
	--			vga_fifo_test_0_conduit_end_vga_sda      => open,      --                             .vga_sda
	--			vga_fifo_test_0_conduit_end_vga_board_id => open, --                             .vga_board_id
				
				-- VGA top test
	--			vga_top_test_0_conduit_end_vga_r         => vga_r4,         --   vga_top_test_0_conduit_end.vga_r
	--			vga_top_test_0_conduit_end_vga_g         => vga_g4,         --                             .vga_g
	--			vga_top_test_0_conduit_end_vga_b         => vga_b4,         --                             .vga_b
	--			vga_top_test_0_conduit_end_vga_hsync     => vga_hsync4,     --                             .vga_hsync
	--			vga_top_test_0_conduit_end_vga_vsync     => vga_vsync4,     --                             .vga_vsync
	--			vga_top_test_0_conduit_end_vga_clk       => open,       --                             .vga_clk
	--			vga_top_test_0_conduit_end_vga_scl       => open,       --                             .vga_scl
	--			vga_top_test_0_conduit_end_vga_sda       => open,       --                             .vga_sda
	--			vga_top_test_0_conduit_end_vga_board_id  => open,   --                             .vga_board_id
				
				-- VGA cont test
	--			vga_cont_test_0_conduit_end_vga_r        => vga_r5,        --  vga_cont_test_0_conduit_end.vga_r
	--			vga_cont_test_0_conduit_end_vga_g        => vga_g5,        --                             .vga_g
	--			vga_cont_test_0_conduit_end_vga_b        => vga_b5,        --                             .vga_b
	--			vga_cont_test_0_conduit_end_vga_hsync    => vga_hsync5,    --                             .vga_hsync
	--			vga_cont_test_0_conduit_end_vga_vsync    => vga_vsync5,    --                             .vga_vsync
	--			vga_cont_test_0_conduit_end_vga_clk      => open,      --                             .vga_clk
	--			vga_cont_test_0_conduit_end_vga_scl      => open,      --                             .vga_scl
	--			vga_cont_test_0_conduit_end_vga_sda      => open,      --                             .vga_sda
	--			vga_cont_test_0_conduit_end_vga_board_id => open, --                             .vga_board_id
				
				-- Camera controller
				camera_controller_0_conduit_camera_pixclk      => GPIO_1_D5M_PIXCLK,      -- camera_controller_0_conduit_camera.pixclk
				camera_controller_0_conduit_camera_frame_valid => GPIO_1_D5M_FVAL, --                                   .frame_valid
				camera_controller_0_conduit_camera_line_valid  => GPIO_1_D5M_LVAL,  --                                   .line_valid
				camera_controller_0_conduit_camera_cam_reset   => GPIO_1_D5M_RESET_N,   --                                   .cam_reset
				camera_controller_0_conduit_camera_data_in     => GPIO_1_D5M_D,      --  
				pll_0_cam_clk_clk                              => xclk10,                              --                      pll_0_cam_clk.clk                                 .data_in
				pll_0_cam2_clk_clk                              => xclk20,
				pll_0_cam3_clk_clk                              => xclk40,
				pll_0_cam4_clk_clk                              => xclk50,
				
				-- I2C
				i2c_0_i2c_scl                                  => GPIO_1_D5M_SCLK,                                  --                          i2c_0_i2c.scl
				i2c_0_i2c_sda                                  => GPIO_1_D5M_SDATA,                                   --                                   .sda
				
				-- HPS
            hps_0_ddr_mem_a                   => HPS_DDR3_ADDR,
            hps_0_ddr_mem_ba                  => HPS_DDR3_BA,
            hps_0_ddr_mem_ck                  => HPS_DDR3_CK_P,
            hps_0_ddr_mem_ck_n                => HPS_DDR3_CK_N,
            hps_0_ddr_mem_cke                 => HPS_DDR3_CKE,
            hps_0_ddr_mem_cs_n                => HPS_DDR3_CS_N,
            hps_0_ddr_mem_ras_n               => HPS_DDR3_RAS_N,
            hps_0_ddr_mem_cas_n               => HPS_DDR3_CAS_N,
            hps_0_ddr_mem_we_n                => HPS_DDR3_WE_N,
            hps_0_ddr_mem_reset_n             => HPS_DDR3_RESET_N,
            hps_0_ddr_mem_dq                  => HPS_DDR3_DQ,
            hps_0_ddr_mem_dqs                 => HPS_DDR3_DQS_P,
            hps_0_ddr_mem_dqs_n               => HPS_DDR3_DQS_N,
            hps_0_ddr_mem_odt                 => HPS_DDR3_ODT,
            hps_0_ddr_mem_dm                  => HPS_DDR3_DM,
            hps_0_ddr_oct_rzqin               => HPS_DDR3_RZQ,
            hps_0_io_hps_io_emac1_inst_TX_CLK => HPS_ENET_GTX_CLK,
            hps_0_io_hps_io_emac1_inst_TX_CTL => HPS_ENET_TX_EN,
            hps_0_io_hps_io_emac1_inst_TXD0   => HPS_ENET_TX_DATA(0),
            hps_0_io_hps_io_emac1_inst_TXD1   => HPS_ENET_TX_DATA(1),
            hps_0_io_hps_io_emac1_inst_TXD2   => HPS_ENET_TX_DATA(2),
            hps_0_io_hps_io_emac1_inst_TXD3   => HPS_ENET_TX_DATA(3),
            hps_0_io_hps_io_emac1_inst_RX_CLK => HPS_ENET_RX_CLK,
            hps_0_io_hps_io_emac1_inst_RX_CTL => HPS_ENET_RX_DV,
            hps_0_io_hps_io_emac1_inst_RXD0   => HPS_ENET_RX_DATA(0),
            hps_0_io_hps_io_emac1_inst_RXD1   => HPS_ENET_RX_DATA(1),
            hps_0_io_hps_io_emac1_inst_RXD2   => HPS_ENET_RX_DATA(2),
            hps_0_io_hps_io_emac1_inst_RXD3   => HPS_ENET_RX_DATA(3),
            hps_0_io_hps_io_emac1_inst_MDIO   => HPS_ENET_MDIO,
            hps_0_io_hps_io_emac1_inst_MDC    => HPS_ENET_MDC,
            hps_0_io_hps_io_sdio_inst_CLK     => HPS_SD_CLK,
            hps_0_io_hps_io_sdio_inst_CMD     => HPS_SD_CMD,
            hps_0_io_hps_io_sdio_inst_D0      => HPS_SD_DATA(0),
            hps_0_io_hps_io_sdio_inst_D1      => HPS_SD_DATA(1),
            hps_0_io_hps_io_sdio_inst_D2      => HPS_SD_DATA(2),
            hps_0_io_hps_io_sdio_inst_D3      => HPS_SD_DATA(3),
            hps_0_io_hps_io_usb1_inst_CLK     => HPS_USB_CLKOUT,
            hps_0_io_hps_io_usb1_inst_STP     => HPS_USB_STP,
            hps_0_io_hps_io_usb1_inst_DIR     => HPS_USB_DIR,
            hps_0_io_hps_io_usb1_inst_NXT     => HPS_USB_NXT,
            hps_0_io_hps_io_usb1_inst_D0      => HPS_USB_DATA(0),
            hps_0_io_hps_io_usb1_inst_D1      => HPS_USB_DATA(1),
            hps_0_io_hps_io_usb1_inst_D2      => HPS_USB_DATA(2),
            hps_0_io_hps_io_usb1_inst_D3      => HPS_USB_DATA(3),
            hps_0_io_hps_io_usb1_inst_D4      => HPS_USB_DATA(4),
            hps_0_io_hps_io_usb1_inst_D5      => HPS_USB_DATA(5),
            hps_0_io_hps_io_usb1_inst_D6      => HPS_USB_DATA(6),
            hps_0_io_hps_io_usb1_inst_D7      => HPS_USB_DATA(7),
            hps_0_io_hps_io_spim1_inst_CLK    => HPS_SPIM_CLK,
            hps_0_io_hps_io_spim1_inst_MOSI   => HPS_SPIM_MOSI,
            hps_0_io_hps_io_spim1_inst_MISO   => HPS_SPIM_MISO,
            hps_0_io_hps_io_spim1_inst_SS0    => HPS_SPIM_SS,
            hps_0_io_hps_io_uart0_inst_RX     => HPS_UART_RX,
            hps_0_io_hps_io_uart0_inst_TX     => HPS_UART_TX,
            hps_0_io_hps_io_i2c0_inst_SDA     => HPS_I2C0_SDAT,
            hps_0_io_hps_io_i2c0_inst_SCL     => HPS_I2C0_SCLK,
            hps_0_io_hps_io_i2c1_inst_SDA     => HPS_I2C1_SDAT,
            hps_0_io_hps_io_i2c1_inst_SCL     => HPS_I2C1_SCLK,
            hps_0_io_hps_io_gpio_inst_GPIO09  => HPS_CONV_USB_N,
            hps_0_io_hps_io_gpio_inst_GPIO35  => HPS_ENET_INT_N,
            hps_0_io_hps_io_gpio_inst_GPIO40  => HPS_LTC_GPIO,
            hps_0_io_hps_io_gpio_inst_GPIO53  => HPS_LED,
            hps_0_io_hps_io_gpio_inst_GPIO54  => HPS_KEY_N,
            hps_0_io_hps_io_gpio_inst_GPIO61  => HPS_GSENSOR_INT
        );

end;
