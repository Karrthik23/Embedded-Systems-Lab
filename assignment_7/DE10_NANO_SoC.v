module DE10_NANO_SoC(

    //////////// CLOCK //////////
    input               FPGA_CLK1_50,
    input               FPGA_CLK2_50,
    input               FPGA_CLK3_50,

    //////////// HPS //////////
    inout               HPS_CONV_USB_N,
    output   [14: 0]    HPS_DDR3_ADDR,
    output   [ 2: 0]    HPS_DDR3_BA,
    output              HPS_DDR3_CAS_N,
    output              HPS_DDR3_CK_N,
    output              HPS_DDR3_CK_P,
    output              HPS_DDR3_CKE,
    output              HPS_DDR3_CS_N,
    output   [ 3: 0]    HPS_DDR3_DM,
    inout    [31: 0]    HPS_DDR3_DQ,
    inout    [ 3: 0]    HPS_DDR3_DQS_N,
    inout    [ 3: 0]    HPS_DDR3_DQS_P,
    output              HPS_DDR3_ODT,
    output              HPS_DDR3_RAS_N,
    output              HPS_DDR3_RESET_N,
    input               HPS_DDR3_RZQ,
    output              HPS_DDR3_WE_N,
    output              HPS_ENET_GTX_CLK,
    inout               HPS_ENET_INT_N,
    output              HPS_ENET_MDC,
    inout               HPS_ENET_MDIO,
    input               HPS_ENET_RX_CLK,
    input    [ 3: 0]    HPS_ENET_RX_DATA,
    input               HPS_ENET_RX_DV,
    output   [ 3: 0]    HPS_ENET_TX_DATA,
    output              HPS_ENET_TX_EN,
    inout               HPS_GSENSOR_INT,
    inout               HPS_I2C0_SCLK,
    inout               HPS_I2C0_SDAT,
    inout               HPS_I2C1_SCLK,
    inout               HPS_I2C1_SDAT,
    inout               HPS_KEY,
    inout               HPS_LED,
    inout               HPS_LTC_GPIO,
    output              HPS_SD_CLK,
    inout               HPS_SD_CMD,
    inout    [ 3: 0]    HPS_SD_DATA,
    output              HPS_SPIM_CLK,
    input               HPS_SPIM_MISO,
    output              HPS_SPIM_MOSI,
    inout               HPS_SPIM_SS,
    input               HPS_UART_RX,
    output              HPS_UART_TX,
    input               HPS_USB_CLKOUT,
    inout    [ 7: 0]    HPS_USB_DATA,
    input               HPS_USB_DIR,
    input               HPS_USB_NXT,
    output              HPS_USB_STP,

    //////////// KEY //////////
    input    [ 1: 0]    KEY,

    //////////// LED //////////
    output   [ 7: 0]    LED,

    //////////// SW //////////
    input    [ 3: 0]    SW,
	 ///////////Encoder Channels//////
	 input PITCH_ENC_A,
	 input PITCH_ENC_B,
	 input YAW_ENC_A,
	 input YAW_ENC_B,
	 //////////PWM Dir Channels//////////////
	output PITCH_DIRA,
	output PITCH_DIRB,
	output YAW_DIRA,
	output YAW_DIRB,
	////////PWM Val Channels//////////
	inout PITCH_PWM_VAL,
	inout YAW_PWM_VAL

);



//=======================================================
//  REG/WIRE declarations
//=======================================================
wire hps_fpga_reset_n;
// wire     [1: 0]     fpga_debounced_buttons;
wire     [2: 0]     hps_reset_req;
wire                hps_cold_reset;
wire                hps_warm_reset;
wire                hps_debug_reset;
// wire     [27: 0]    stm_hw_events;
wire                fpga_clk_50;
// connection of internal logics
assign fpga_clk_50 = FPGA_CLK1_50;
//assign  stm_hw_events = {{15{1'b0}}, SW, fpga_led_internal, fpga_debounced_buttons};
reg [15: 0] counter_1;


//=======================================================
//  Structural coding
//=======================================================
soc_system u0(
               //Clock&Reset
               .clk_clk(FPGA_CLK1_50),                                      //                            clk.clk
               .reset_reset_n(hps_fpga_reset_n),                            //                          reset.reset_n
               //HPS ddr3
               .memory_mem_a(HPS_DDR3_ADDR),                                //                         memory.mem_a
               .memory_mem_ba(HPS_DDR3_BA),                                 //                               .mem_ba
               .memory_mem_ck(HPS_DDR3_CK_P),                               //                               .mem_ck
               .memory_mem_ck_n(HPS_DDR3_CK_N),                             //                               .mem_ck_n
               .memory_mem_cke(HPS_DDR3_CKE),                               //                               .mem_cke
               .memory_mem_cs_n(HPS_DDR3_CS_N),                             //                               .mem_cs_n
               .memory_mem_ras_n(HPS_DDR3_RAS_N),                           //                               .mem_ras_n
               .memory_mem_cas_n(HPS_DDR3_CAS_N),                           //                               .mem_cas_n
               .memory_mem_we_n(HPS_DDR3_WE_N),                             //                               .mem_we_n
               .memory_mem_reset_n(HPS_DDR3_RESET_N),                       //                               .mem_reset_n
               .memory_mem_dq(HPS_DDR3_DQ),                                 //                               .mem_dq
               .memory_mem_dqs(HPS_DDR3_DQS_P),                             //                               .mem_dqs
               .memory_mem_dqs_n(HPS_DDR3_DQS_N),                           //                               .mem_dqs_n
               .memory_mem_odt(HPS_DDR3_ODT),                               //                               .mem_odt
               .memory_mem_dm(HPS_DDR3_DM),                                 //                               .mem_dm
               .memory_oct_rzqin(HPS_DDR3_RZQ),                             //                               .oct_rzqin
               //FPGA IO
               //NOTE: This probalby will have a different name
               //.esl_demo_export(LED),                                       //    led_pio_external_connection.export
               .hps_0_h2f_reset_reset_n(hps_fpga_reset_n),                   //                hps_0_h2f_reset.reset_n
					.encoder_bus_demo_enc_a(YAW_ENC_A),
					.encoder_bus_demo_enc_b(YAW_ENC_B),
					.encoder_bus_demo_counter(counter_1)
           );



reg [25: 0] counter;
reg [7:0] led;

assign LED = led;
always @(posedge fpga_clk_50) begin
 
 led[0] <= counter_1[0];
 led[1] <= counter_1[1];
 led[2] <= counter_1[2];
 led[3] <= counter_1[3];
 led[4] <= counter_1[4];
 led[5] <= counter_1[5];
 led[6] <= counter_1[6];
 led[7] <= counter_1[7];
end
endmodule
