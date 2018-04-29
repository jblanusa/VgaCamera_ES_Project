	component soc_system is
		port (
			camera_controller_0_conduit_camera_pixclk      : in    std_logic                     := 'X';             -- pixclk
			camera_controller_0_conduit_camera_frame_valid : in    std_logic                     := 'X';             -- frame_valid
			camera_controller_0_conduit_camera_line_valid  : in    std_logic                     := 'X';             -- line_valid
			camera_controller_0_conduit_camera_cam_reset   : out   std_logic;                                        -- cam_reset
			camera_controller_0_conduit_camera_data_in     : in    std_logic_vector(11 downto 0) := (others => 'X'); -- data_in
			clk_clk                                        : in    std_logic                     := 'X';             -- clk
			hps_0_ddr_mem_a                                : out   std_logic_vector(14 downto 0);                    -- mem_a
			hps_0_ddr_mem_ba                               : out   std_logic_vector(2 downto 0);                     -- mem_ba
			hps_0_ddr_mem_ck                               : out   std_logic;                                        -- mem_ck
			hps_0_ddr_mem_ck_n                             : out   std_logic;                                        -- mem_ck_n
			hps_0_ddr_mem_cke                              : out   std_logic;                                        -- mem_cke
			hps_0_ddr_mem_cs_n                             : out   std_logic;                                        -- mem_cs_n
			hps_0_ddr_mem_ras_n                            : out   std_logic;                                        -- mem_ras_n
			hps_0_ddr_mem_cas_n                            : out   std_logic;                                        -- mem_cas_n
			hps_0_ddr_mem_we_n                             : out   std_logic;                                        -- mem_we_n
			hps_0_ddr_mem_reset_n                          : out   std_logic;                                        -- mem_reset_n
			hps_0_ddr_mem_dq                               : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			hps_0_ddr_mem_dqs                              : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			hps_0_ddr_mem_dqs_n                            : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			hps_0_ddr_mem_odt                              : out   std_logic;                                        -- mem_odt
			hps_0_ddr_mem_dm                               : out   std_logic_vector(3 downto 0);                     -- mem_dm
			hps_0_ddr_oct_rzqin                            : in    std_logic                     := 'X';             -- oct_rzqin
			hps_0_io_hps_io_emac1_inst_TX_CLK              : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
			hps_0_io_hps_io_emac1_inst_TXD0                : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
			hps_0_io_hps_io_emac1_inst_TXD1                : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
			hps_0_io_hps_io_emac1_inst_TXD2                : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
			hps_0_io_hps_io_emac1_inst_TXD3                : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
			hps_0_io_hps_io_emac1_inst_RXD0                : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
			hps_0_io_hps_io_emac1_inst_MDIO                : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
			hps_0_io_hps_io_emac1_inst_MDC                 : out   std_logic;                                        -- hps_io_emac1_inst_MDC
			hps_0_io_hps_io_emac1_inst_RX_CTL              : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
			hps_0_io_hps_io_emac1_inst_TX_CTL              : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
			hps_0_io_hps_io_emac1_inst_RX_CLK              : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
			hps_0_io_hps_io_emac1_inst_RXD1                : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
			hps_0_io_hps_io_emac1_inst_RXD2                : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
			hps_0_io_hps_io_emac1_inst_RXD3                : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
			hps_0_io_hps_io_sdio_inst_CMD                  : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
			hps_0_io_hps_io_sdio_inst_D0                   : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
			hps_0_io_hps_io_sdio_inst_D1                   : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
			hps_0_io_hps_io_sdio_inst_CLK                  : out   std_logic;                                        -- hps_io_sdio_inst_CLK
			hps_0_io_hps_io_sdio_inst_D2                   : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
			hps_0_io_hps_io_sdio_inst_D3                   : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
			hps_0_io_hps_io_usb1_inst_D0                   : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
			hps_0_io_hps_io_usb1_inst_D1                   : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
			hps_0_io_hps_io_usb1_inst_D2                   : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
			hps_0_io_hps_io_usb1_inst_D3                   : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
			hps_0_io_hps_io_usb1_inst_D4                   : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
			hps_0_io_hps_io_usb1_inst_D5                   : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
			hps_0_io_hps_io_usb1_inst_D6                   : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
			hps_0_io_hps_io_usb1_inst_D7                   : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
			hps_0_io_hps_io_usb1_inst_CLK                  : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
			hps_0_io_hps_io_usb1_inst_STP                  : out   std_logic;                                        -- hps_io_usb1_inst_STP
			hps_0_io_hps_io_usb1_inst_DIR                  : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
			hps_0_io_hps_io_usb1_inst_NXT                  : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
			hps_0_io_hps_io_spim1_inst_CLK                 : out   std_logic;                                        -- hps_io_spim1_inst_CLK
			hps_0_io_hps_io_spim1_inst_MOSI                : out   std_logic;                                        -- hps_io_spim1_inst_MOSI
			hps_0_io_hps_io_spim1_inst_MISO                : in    std_logic                     := 'X';             -- hps_io_spim1_inst_MISO
			hps_0_io_hps_io_spim1_inst_SS0                 : out   std_logic;                                        -- hps_io_spim1_inst_SS0
			hps_0_io_hps_io_uart0_inst_RX                  : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
			hps_0_io_hps_io_uart0_inst_TX                  : out   std_logic;                                        -- hps_io_uart0_inst_TX
			hps_0_io_hps_io_i2c0_inst_SDA                  : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SDA
			hps_0_io_hps_io_i2c0_inst_SCL                  : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SCL
			hps_0_io_hps_io_i2c1_inst_SDA                  : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SDA
			hps_0_io_hps_io_i2c1_inst_SCL                  : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SCL
			hps_0_io_hps_io_gpio_inst_GPIO09               : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO09
			hps_0_io_hps_io_gpio_inst_GPIO35               : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO35
			hps_0_io_hps_io_gpio_inst_GPIO40               : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO40
			hps_0_io_hps_io_gpio_inst_GPIO53               : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO53
			hps_0_io_hps_io_gpio_inst_GPIO54               : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO54
			hps_0_io_hps_io_gpio_inst_GPIO61               : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO61
			i2c_0_i2c_scl                                  : inout std_logic                     := 'X';             -- scl
			i2c_0_i2c_sda                                  : inout std_logic                     := 'X';             -- sda
			pll_0_cam2_clk_clk                             : out   std_logic;                                        -- clk
			pll_0_cam3_clk_clk                             : out   std_logic;                                        -- clk
			pll_0_cam_clk_clk                              : out   std_logic;                                        -- clk
			pll_0_outclk1_clk                              : out   std_logic;                                        -- clk
			reset_reset_n                                  : in    std_logic                     := 'X';             -- reset_n
			vga_controller_0_conduit_debug_fifo_empty      : out   std_logic;                                        -- fifo_empty
			vga_controller_0_conduit_debug_fifo_full       : out   std_logic;                                        -- fifo_full
			vga_controller_0_conduit_debug_fifo_half       : out   std_logic;                                        -- fifo_half
			vga_controller_0_conduit_debug_waitreq         : out   std_logic;                                        -- waitreq
			vga_controller_0_conduit_debug_readvalid       : out   std_logic;                                        -- readvalid
			vga_controller_0_conduit_debug_disp_com        : out   std_logic;                                        -- disp_com
			vga_controller_0_conduit_debug_disp_stat       : out   std_logic;                                        -- disp_stat
			vga_controller_0_conduit_debug_burst_count     : out   std_logic_vector(5 downto 0);                     -- burst_count
			vga_controller_0_conduit_debug_read            : out   std_logic;                                        -- read
			vga_controller_0_conduit_debug_state           : out   std_logic_vector(2 downto 0);                     -- state
			vga_controller_0_conduit_vga_board_id          : inout std_logic                     := 'X';             -- board_id
			vga_controller_0_conduit_vga_vga_scl           : out   std_logic;                                        -- vga_scl
			vga_controller_0_conduit_vga_vga_sda           : inout std_logic                     := 'X';             -- vga_sda
			vga_controller_0_conduit_vga_vga_video_b       : out   std_logic_vector(7 downto 0);                     -- vga_video_b
			vga_controller_0_conduit_vga_vga_clk           : out   std_logic;                                        -- vga_clk
			vga_controller_0_conduit_vga_vga_video_g       : out   std_logic_vector(7 downto 0);                     -- vga_video_g
			vga_controller_0_conduit_vga_vga_hsync         : out   std_logic;                                        -- vga_hsync
			vga_controller_0_conduit_vga_vga_video_r       : out   std_logic_vector(7 downto 0);                     -- vga_video_r
			vga_controller_0_conduit_vga_vga_vsync         : out   std_logic;                                        -- vga_vsync
			pll_0_cam4_clk_clk                             : out   std_logic                                         -- clk
		);
	end component soc_system;

	u0 : component soc_system
		port map (
			camera_controller_0_conduit_camera_pixclk      => CONNECTED_TO_camera_controller_0_conduit_camera_pixclk,      -- camera_controller_0_conduit_camera.pixclk
			camera_controller_0_conduit_camera_frame_valid => CONNECTED_TO_camera_controller_0_conduit_camera_frame_valid, --                                   .frame_valid
			camera_controller_0_conduit_camera_line_valid  => CONNECTED_TO_camera_controller_0_conduit_camera_line_valid,  --                                   .line_valid
			camera_controller_0_conduit_camera_cam_reset   => CONNECTED_TO_camera_controller_0_conduit_camera_cam_reset,   --                                   .cam_reset
			camera_controller_0_conduit_camera_data_in     => CONNECTED_TO_camera_controller_0_conduit_camera_data_in,     --                                   .data_in
			clk_clk                                        => CONNECTED_TO_clk_clk,                                        --                                clk.clk
			hps_0_ddr_mem_a                                => CONNECTED_TO_hps_0_ddr_mem_a,                                --                          hps_0_ddr.mem_a
			hps_0_ddr_mem_ba                               => CONNECTED_TO_hps_0_ddr_mem_ba,                               --                                   .mem_ba
			hps_0_ddr_mem_ck                               => CONNECTED_TO_hps_0_ddr_mem_ck,                               --                                   .mem_ck
			hps_0_ddr_mem_ck_n                             => CONNECTED_TO_hps_0_ddr_mem_ck_n,                             --                                   .mem_ck_n
			hps_0_ddr_mem_cke                              => CONNECTED_TO_hps_0_ddr_mem_cke,                              --                                   .mem_cke
			hps_0_ddr_mem_cs_n                             => CONNECTED_TO_hps_0_ddr_mem_cs_n,                             --                                   .mem_cs_n
			hps_0_ddr_mem_ras_n                            => CONNECTED_TO_hps_0_ddr_mem_ras_n,                            --                                   .mem_ras_n
			hps_0_ddr_mem_cas_n                            => CONNECTED_TO_hps_0_ddr_mem_cas_n,                            --                                   .mem_cas_n
			hps_0_ddr_mem_we_n                             => CONNECTED_TO_hps_0_ddr_mem_we_n,                             --                                   .mem_we_n
			hps_0_ddr_mem_reset_n                          => CONNECTED_TO_hps_0_ddr_mem_reset_n,                          --                                   .mem_reset_n
			hps_0_ddr_mem_dq                               => CONNECTED_TO_hps_0_ddr_mem_dq,                               --                                   .mem_dq
			hps_0_ddr_mem_dqs                              => CONNECTED_TO_hps_0_ddr_mem_dqs,                              --                                   .mem_dqs
			hps_0_ddr_mem_dqs_n                            => CONNECTED_TO_hps_0_ddr_mem_dqs_n,                            --                                   .mem_dqs_n
			hps_0_ddr_mem_odt                              => CONNECTED_TO_hps_0_ddr_mem_odt,                              --                                   .mem_odt
			hps_0_ddr_mem_dm                               => CONNECTED_TO_hps_0_ddr_mem_dm,                               --                                   .mem_dm
			hps_0_ddr_oct_rzqin                            => CONNECTED_TO_hps_0_ddr_oct_rzqin,                            --                                   .oct_rzqin
			hps_0_io_hps_io_emac1_inst_TX_CLK              => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_TX_CLK,              --                           hps_0_io.hps_io_emac1_inst_TX_CLK
			hps_0_io_hps_io_emac1_inst_TXD0                => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_TXD0,                --                                   .hps_io_emac1_inst_TXD0
			hps_0_io_hps_io_emac1_inst_TXD1                => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_TXD1,                --                                   .hps_io_emac1_inst_TXD1
			hps_0_io_hps_io_emac1_inst_TXD2                => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_TXD2,                --                                   .hps_io_emac1_inst_TXD2
			hps_0_io_hps_io_emac1_inst_TXD3                => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_TXD3,                --                                   .hps_io_emac1_inst_TXD3
			hps_0_io_hps_io_emac1_inst_RXD0                => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_RXD0,                --                                   .hps_io_emac1_inst_RXD0
			hps_0_io_hps_io_emac1_inst_MDIO                => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_MDIO,                --                                   .hps_io_emac1_inst_MDIO
			hps_0_io_hps_io_emac1_inst_MDC                 => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_MDC,                 --                                   .hps_io_emac1_inst_MDC
			hps_0_io_hps_io_emac1_inst_RX_CTL              => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_RX_CTL,              --                                   .hps_io_emac1_inst_RX_CTL
			hps_0_io_hps_io_emac1_inst_TX_CTL              => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_TX_CTL,              --                                   .hps_io_emac1_inst_TX_CTL
			hps_0_io_hps_io_emac1_inst_RX_CLK              => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_RX_CLK,              --                                   .hps_io_emac1_inst_RX_CLK
			hps_0_io_hps_io_emac1_inst_RXD1                => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_RXD1,                --                                   .hps_io_emac1_inst_RXD1
			hps_0_io_hps_io_emac1_inst_RXD2                => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_RXD2,                --                                   .hps_io_emac1_inst_RXD2
			hps_0_io_hps_io_emac1_inst_RXD3                => CONNECTED_TO_hps_0_io_hps_io_emac1_inst_RXD3,                --                                   .hps_io_emac1_inst_RXD3
			hps_0_io_hps_io_sdio_inst_CMD                  => CONNECTED_TO_hps_0_io_hps_io_sdio_inst_CMD,                  --                                   .hps_io_sdio_inst_CMD
			hps_0_io_hps_io_sdio_inst_D0                   => CONNECTED_TO_hps_0_io_hps_io_sdio_inst_D0,                   --                                   .hps_io_sdio_inst_D0
			hps_0_io_hps_io_sdio_inst_D1                   => CONNECTED_TO_hps_0_io_hps_io_sdio_inst_D1,                   --                                   .hps_io_sdio_inst_D1
			hps_0_io_hps_io_sdio_inst_CLK                  => CONNECTED_TO_hps_0_io_hps_io_sdio_inst_CLK,                  --                                   .hps_io_sdio_inst_CLK
			hps_0_io_hps_io_sdio_inst_D2                   => CONNECTED_TO_hps_0_io_hps_io_sdio_inst_D2,                   --                                   .hps_io_sdio_inst_D2
			hps_0_io_hps_io_sdio_inst_D3                   => CONNECTED_TO_hps_0_io_hps_io_sdio_inst_D3,                   --                                   .hps_io_sdio_inst_D3
			hps_0_io_hps_io_usb1_inst_D0                   => CONNECTED_TO_hps_0_io_hps_io_usb1_inst_D0,                   --                                   .hps_io_usb1_inst_D0
			hps_0_io_hps_io_usb1_inst_D1                   => CONNECTED_TO_hps_0_io_hps_io_usb1_inst_D1,                   --                                   .hps_io_usb1_inst_D1
			hps_0_io_hps_io_usb1_inst_D2                   => CONNECTED_TO_hps_0_io_hps_io_usb1_inst_D2,                   --                                   .hps_io_usb1_inst_D2
			hps_0_io_hps_io_usb1_inst_D3                   => CONNECTED_TO_hps_0_io_hps_io_usb1_inst_D3,                   --                                   .hps_io_usb1_inst_D3
			hps_0_io_hps_io_usb1_inst_D4                   => CONNECTED_TO_hps_0_io_hps_io_usb1_inst_D4,                   --                                   .hps_io_usb1_inst_D4
			hps_0_io_hps_io_usb1_inst_D5                   => CONNECTED_TO_hps_0_io_hps_io_usb1_inst_D5,                   --                                   .hps_io_usb1_inst_D5
			hps_0_io_hps_io_usb1_inst_D6                   => CONNECTED_TO_hps_0_io_hps_io_usb1_inst_D6,                   --                                   .hps_io_usb1_inst_D6
			hps_0_io_hps_io_usb1_inst_D7                   => CONNECTED_TO_hps_0_io_hps_io_usb1_inst_D7,                   --                                   .hps_io_usb1_inst_D7
			hps_0_io_hps_io_usb1_inst_CLK                  => CONNECTED_TO_hps_0_io_hps_io_usb1_inst_CLK,                  --                                   .hps_io_usb1_inst_CLK
			hps_0_io_hps_io_usb1_inst_STP                  => CONNECTED_TO_hps_0_io_hps_io_usb1_inst_STP,                  --                                   .hps_io_usb1_inst_STP
			hps_0_io_hps_io_usb1_inst_DIR                  => CONNECTED_TO_hps_0_io_hps_io_usb1_inst_DIR,                  --                                   .hps_io_usb1_inst_DIR
			hps_0_io_hps_io_usb1_inst_NXT                  => CONNECTED_TO_hps_0_io_hps_io_usb1_inst_NXT,                  --                                   .hps_io_usb1_inst_NXT
			hps_0_io_hps_io_spim1_inst_CLK                 => CONNECTED_TO_hps_0_io_hps_io_spim1_inst_CLK,                 --                                   .hps_io_spim1_inst_CLK
			hps_0_io_hps_io_spim1_inst_MOSI                => CONNECTED_TO_hps_0_io_hps_io_spim1_inst_MOSI,                --                                   .hps_io_spim1_inst_MOSI
			hps_0_io_hps_io_spim1_inst_MISO                => CONNECTED_TO_hps_0_io_hps_io_spim1_inst_MISO,                --                                   .hps_io_spim1_inst_MISO
			hps_0_io_hps_io_spim1_inst_SS0                 => CONNECTED_TO_hps_0_io_hps_io_spim1_inst_SS0,                 --                                   .hps_io_spim1_inst_SS0
			hps_0_io_hps_io_uart0_inst_RX                  => CONNECTED_TO_hps_0_io_hps_io_uart0_inst_RX,                  --                                   .hps_io_uart0_inst_RX
			hps_0_io_hps_io_uart0_inst_TX                  => CONNECTED_TO_hps_0_io_hps_io_uart0_inst_TX,                  --                                   .hps_io_uart0_inst_TX
			hps_0_io_hps_io_i2c0_inst_SDA                  => CONNECTED_TO_hps_0_io_hps_io_i2c0_inst_SDA,                  --                                   .hps_io_i2c0_inst_SDA
			hps_0_io_hps_io_i2c0_inst_SCL                  => CONNECTED_TO_hps_0_io_hps_io_i2c0_inst_SCL,                  --                                   .hps_io_i2c0_inst_SCL
			hps_0_io_hps_io_i2c1_inst_SDA                  => CONNECTED_TO_hps_0_io_hps_io_i2c1_inst_SDA,                  --                                   .hps_io_i2c1_inst_SDA
			hps_0_io_hps_io_i2c1_inst_SCL                  => CONNECTED_TO_hps_0_io_hps_io_i2c1_inst_SCL,                  --                                   .hps_io_i2c1_inst_SCL
			hps_0_io_hps_io_gpio_inst_GPIO09               => CONNECTED_TO_hps_0_io_hps_io_gpio_inst_GPIO09,               --                                   .hps_io_gpio_inst_GPIO09
			hps_0_io_hps_io_gpio_inst_GPIO35               => CONNECTED_TO_hps_0_io_hps_io_gpio_inst_GPIO35,               --                                   .hps_io_gpio_inst_GPIO35
			hps_0_io_hps_io_gpio_inst_GPIO40               => CONNECTED_TO_hps_0_io_hps_io_gpio_inst_GPIO40,               --                                   .hps_io_gpio_inst_GPIO40
			hps_0_io_hps_io_gpio_inst_GPIO53               => CONNECTED_TO_hps_0_io_hps_io_gpio_inst_GPIO53,               --                                   .hps_io_gpio_inst_GPIO53
			hps_0_io_hps_io_gpio_inst_GPIO54               => CONNECTED_TO_hps_0_io_hps_io_gpio_inst_GPIO54,               --                                   .hps_io_gpio_inst_GPIO54
			hps_0_io_hps_io_gpio_inst_GPIO61               => CONNECTED_TO_hps_0_io_hps_io_gpio_inst_GPIO61,               --                                   .hps_io_gpio_inst_GPIO61
			i2c_0_i2c_scl                                  => CONNECTED_TO_i2c_0_i2c_scl,                                  --                          i2c_0_i2c.scl
			i2c_0_i2c_sda                                  => CONNECTED_TO_i2c_0_i2c_sda,                                  --                                   .sda
			pll_0_cam2_clk_clk                             => CONNECTED_TO_pll_0_cam2_clk_clk,                             --                     pll_0_cam2_clk.clk
			pll_0_cam3_clk_clk                             => CONNECTED_TO_pll_0_cam3_clk_clk,                             --                     pll_0_cam3_clk.clk
			pll_0_cam_clk_clk                              => CONNECTED_TO_pll_0_cam_clk_clk,                              --                      pll_0_cam_clk.clk
			pll_0_outclk1_clk                              => CONNECTED_TO_pll_0_outclk1_clk,                              --                      pll_0_outclk1.clk
			reset_reset_n                                  => CONNECTED_TO_reset_reset_n,                                  --                              reset.reset_n
			vga_controller_0_conduit_debug_fifo_empty      => CONNECTED_TO_vga_controller_0_conduit_debug_fifo_empty,      --     vga_controller_0_conduit_debug.fifo_empty
			vga_controller_0_conduit_debug_fifo_full       => CONNECTED_TO_vga_controller_0_conduit_debug_fifo_full,       --                                   .fifo_full
			vga_controller_0_conduit_debug_fifo_half       => CONNECTED_TO_vga_controller_0_conduit_debug_fifo_half,       --                                   .fifo_half
			vga_controller_0_conduit_debug_waitreq         => CONNECTED_TO_vga_controller_0_conduit_debug_waitreq,         --                                   .waitreq
			vga_controller_0_conduit_debug_readvalid       => CONNECTED_TO_vga_controller_0_conduit_debug_readvalid,       --                                   .readvalid
			vga_controller_0_conduit_debug_disp_com        => CONNECTED_TO_vga_controller_0_conduit_debug_disp_com,        --                                   .disp_com
			vga_controller_0_conduit_debug_disp_stat       => CONNECTED_TO_vga_controller_0_conduit_debug_disp_stat,       --                                   .disp_stat
			vga_controller_0_conduit_debug_burst_count     => CONNECTED_TO_vga_controller_0_conduit_debug_burst_count,     --                                   .burst_count
			vga_controller_0_conduit_debug_read            => CONNECTED_TO_vga_controller_0_conduit_debug_read,            --                                   .read
			vga_controller_0_conduit_debug_state           => CONNECTED_TO_vga_controller_0_conduit_debug_state,           --                                   .state
			vga_controller_0_conduit_vga_board_id          => CONNECTED_TO_vga_controller_0_conduit_vga_board_id,          --       vga_controller_0_conduit_vga.board_id
			vga_controller_0_conduit_vga_vga_scl           => CONNECTED_TO_vga_controller_0_conduit_vga_vga_scl,           --                                   .vga_scl
			vga_controller_0_conduit_vga_vga_sda           => CONNECTED_TO_vga_controller_0_conduit_vga_vga_sda,           --                                   .vga_sda
			vga_controller_0_conduit_vga_vga_video_b       => CONNECTED_TO_vga_controller_0_conduit_vga_vga_video_b,       --                                   .vga_video_b
			vga_controller_0_conduit_vga_vga_clk           => CONNECTED_TO_vga_controller_0_conduit_vga_vga_clk,           --                                   .vga_clk
			vga_controller_0_conduit_vga_vga_video_g       => CONNECTED_TO_vga_controller_0_conduit_vga_vga_video_g,       --                                   .vga_video_g
			vga_controller_0_conduit_vga_vga_hsync         => CONNECTED_TO_vga_controller_0_conduit_vga_vga_hsync,         --                                   .vga_hsync
			vga_controller_0_conduit_vga_vga_video_r       => CONNECTED_TO_vga_controller_0_conduit_vga_vga_video_r,       --                                   .vga_video_r
			vga_controller_0_conduit_vga_vga_vsync         => CONNECTED_TO_vga_controller_0_conduit_vga_vga_vsync,         --                                   .vga_vsync
			pll_0_cam4_clk_clk                             => CONNECTED_TO_pll_0_cam4_clk_clk                              --                     pll_0_cam4_clk.clk
		);

