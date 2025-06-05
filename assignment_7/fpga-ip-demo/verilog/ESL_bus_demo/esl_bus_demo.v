module esl_bus_demo (
    input wire clk_clk,                // Clock input
    input wire reset_reset_n,         // Active-low reset

    input wire encoder_a,             // Channel A (e.g., KEY0)
    input wire encoder_b,             // Channel B (e.g., KEY1)
    output wire [31:0] encoder_count  // Output to LEDs or monitor
);

    wire [31:0] counter_wire;

    // Instantiate the Platform Designer (Qsys) system
    esl_bus_demo_example u0 (
        .clk_clk(clk_clk),
        .reset_reset_n(reset_reset_n),
        .encoder_a_export(encoder_a),
        .encoder_b_export(encoder_b),
        .encoder_counter_export(counter_wire)
    );

    assign encoder_count = counter_wire;

endmodule

