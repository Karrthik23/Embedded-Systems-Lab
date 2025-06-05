
module encoder_bus_demo #(
		parameter ENCODER_WIDTH = 16,
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
        input wire enc_a,  // ENC A
        input wire enc_b,  // ENC B
        output wire [15:0] counter
	);

    // Internal memory for the system and a subset for the IP
    reg [31:0] mem;
    wire enable;

    // Definition of the counter
    Encoder #(
        .DATA_WIDTH(ENCODER_WIDTH)
    ) my_ip (
        .clk(clk),
        .reset(reset),
        .ChannelA(enc_a),
        .ChannelB(enc_b),
        .Counter(counter)
    );

    

    
    assign enable = mem[31];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem <= 32'b0;
        end else begin
            if (slave_read) begin
                slave_readdata <=  {16'b0, counter};
            end
            if (slave_write) begin
                mem <= slave_writedata;
            end;
        end;
    end



endmodule
