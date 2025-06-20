	component soc_system is
		port (
			clk_clk                 : in    std_logic                     := 'X';             -- clk
			hps_0_h2f_reset_reset_n : out   std_logic;                                        -- reset_n
			memory_mem_a            : out   std_logic_vector(14 downto 0);                    -- mem_a
			memory_mem_ba           : out   std_logic_vector(2 downto 0);                     -- mem_ba
			memory_mem_ck           : out   std_logic;                                        -- mem_ck
			memory_mem_ck_n         : out   std_logic;                                        -- mem_ck_n
			memory_mem_cke          : out   std_logic;                                        -- mem_cke
			memory_mem_cs_n         : out   std_logic;                                        -- mem_cs_n
			memory_mem_ras_n        : out   std_logic;                                        -- mem_ras_n
			memory_mem_cas_n        : out   std_logic;                                        -- mem_cas_n
			memory_mem_we_n         : out   std_logic;                                        -- mem_we_n
			memory_mem_reset_n      : out   std_logic;                                        -- mem_reset_n
			memory_mem_dq           : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			memory_mem_dqs          : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			memory_mem_dqs_n        : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			memory_mem_odt          : out   std_logic;                                        -- mem_odt
			memory_mem_dm           : out   std_logic_vector(3 downto 0);                     -- mem_dm
			memory_oct_rzqin        : in    std_logic                     := 'X';             -- oct_rzqin
			reset_reset_n           : in    std_logic                     := 'X';             -- reset_n
			pwm_bus_demo_pwm_out    : out   std_logic;                                        -- pwm_out
			pwm_bus_demo_channel_A  : out   std_logic;                                        -- channel_A
			pwm_bus_demo_channel_B  : out   std_logic                                         -- channel_B
		);
	end component soc_system;

	u0 : component soc_system
		port map (
			clk_clk                 => CONNECTED_TO_clk_clk,                 --             clk.clk
			hps_0_h2f_reset_reset_n => CONNECTED_TO_hps_0_h2f_reset_reset_n, -- hps_0_h2f_reset.reset_n
			memory_mem_a            => CONNECTED_TO_memory_mem_a,            --          memory.mem_a
			memory_mem_ba           => CONNECTED_TO_memory_mem_ba,           --                .mem_ba
			memory_mem_ck           => CONNECTED_TO_memory_mem_ck,           --                .mem_ck
			memory_mem_ck_n         => CONNECTED_TO_memory_mem_ck_n,         --                .mem_ck_n
			memory_mem_cke          => CONNECTED_TO_memory_mem_cke,          --                .mem_cke
			memory_mem_cs_n         => CONNECTED_TO_memory_mem_cs_n,         --                .mem_cs_n
			memory_mem_ras_n        => CONNECTED_TO_memory_mem_ras_n,        --                .mem_ras_n
			memory_mem_cas_n        => CONNECTED_TO_memory_mem_cas_n,        --                .mem_cas_n
			memory_mem_we_n         => CONNECTED_TO_memory_mem_we_n,         --                .mem_we_n
			memory_mem_reset_n      => CONNECTED_TO_memory_mem_reset_n,      --                .mem_reset_n
			memory_mem_dq           => CONNECTED_TO_memory_mem_dq,           --                .mem_dq
			memory_mem_dqs          => CONNECTED_TO_memory_mem_dqs,          --                .mem_dqs
			memory_mem_dqs_n        => CONNECTED_TO_memory_mem_dqs_n,        --                .mem_dqs_n
			memory_mem_odt          => CONNECTED_TO_memory_mem_odt,          --                .mem_odt
			memory_mem_dm           => CONNECTED_TO_memory_mem_dm,           --                .mem_dm
			memory_oct_rzqin        => CONNECTED_TO_memory_oct_rzqin,        --                .oct_rzqin
			reset_reset_n           => CONNECTED_TO_reset_reset_n,           --           reset.reset_n
			pwm_bus_demo_pwm_out    => CONNECTED_TO_pwm_bus_demo_pwm_out,    --    pwm_bus_demo.pwm_out
			pwm_bus_demo_channel_A  => CONNECTED_TO_pwm_bus_demo_channel_A,  --                .channel_A
			pwm_bus_demo_channel_B  => CONNECTED_TO_pwm_bus_demo_channel_B   --                .channel_B
		);

