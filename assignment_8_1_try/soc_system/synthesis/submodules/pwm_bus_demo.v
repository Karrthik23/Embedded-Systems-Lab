
module pwm_bus_demo #(
		parameter pwm_WIDTH = 16,
        parameter DATA_WIDTH = 16
	) (
		input  wire [7:0]  slave_address,     //      avs_s0.address
		input  wire        slave_read,        //            .read
		output reg  [DATA_WIDTH-1:0] slave_readdata,    //            .readdata
		input  wire        slave_write,       //            .write
		input  wire [DATA_WIDTH-1:0] slave_writedata,   //            .writedata
		input  wire        clk,          //       clock.clk
		input  wire        reset,        //       reset.reset
        input  wire [(DATA_WIDTH/8)-1:0] slave_byteenable,
        output wire channel_A,  // Channel A
        output wire channel_B,  // Channel b
        output wire pwm_out
	);

    // Internal memory for the system and a subset for the IP
    reg [31:0] mem;
    wire enable = 1'b1;

    reg signed [8:0] pwmInput;

    // Definition of the counter
    
    pwm_module my_ip(
    .clk(clk),                      // 50 MHz system clock
    .reset(reset),                    // Active-high synchronous reset
    .enable(enable),                   // Enable signal for PWM
    .pwm_input(pwmInput),   // -255 to +255 input controls direction and duty

    .ChannelA(channel_A),                 // Direction control: CW/CCW
    .ChannelB(channel_B),                 // Direction control: CW/CCW
    .PWM_out(pwm_out)                 // PWM signal output
);

    


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem <= 32'b0;
        end else begin
            if (slave_read) begin
                slave_readdata <= mem;
            end
            if (slave_write) begin
                mem <= slave_writedata;
                pwmInput <= slave_writedata[8:0]; 
            end;
        end;
    end



endmodule
