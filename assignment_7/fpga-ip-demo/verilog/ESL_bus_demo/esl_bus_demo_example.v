module esl_bus_demo_example (
    input  wire        clk_clk,
    input  wire        reset_reset_n,
    input  wire        encoder_a_export,
    input  wire        encoder_b_export,
    output wire [31:0] encoder_counter_export
);

    wire clk = clk_clk;
    wire reset = ~reset_reset_n;

    Encoder encoder_inst (
        .clk(clk),
        .reset(reset),
        .ChannelA(encoder_a_export),
        .ChannelB(encoder_b_export),
        .Counter(encoder_counter_export)
    );

endmodule

