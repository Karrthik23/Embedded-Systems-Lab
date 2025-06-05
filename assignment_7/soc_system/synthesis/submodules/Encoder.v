module Encoder #(
   parameter DATA_WIDTH = 16
)(
    input clk,
    input reset,
    input ChannelA,
    input ChannelB,
    output reg [15:0] Counter
);

    // Store current and previous state of ChannelA and ChannelB
    reg [1:0] currentState, prevState;

    always @(posedge clk) begin
        if (reset) begin
            Counter <= 16'd0;
            prevState <= 2'b00;
        end else begin
            // Read new state
            currentState <= {ChannelA, ChannelB};

            // Use CASE to check the previous state
            case (prevState)
                2'b00: begin
                    if (currentState == 2'b01)
                        Counter <= Counter + 1;  // CW
                    else if (currentState == 2'b10)
                        Counter <= Counter - 1;  // CCW
                end

                2'b01: begin
                    if (currentState == 2'b11)
                        Counter <= Counter + 1;  // CW
                    else if (currentState == 2'b00)
                        Counter <= Counter - 1;  // CCW
                end

                2'b11: begin
                    if (currentState == 2'b10)
                        Counter <= Counter + 1;  // CW
                    else if (currentState == 2'b01)
                        Counter <= Counter - 1;  // CCW
                end

                2'b10: begin
                    if (currentState == 2'b00)
                        Counter <= Counter + 1;  // CW
                    else if (currentState == 2'b11)
                        Counter <= Counter - 1;  // CCW
                end
            endcase

            // Update previous state
            prevState <= currentState;
        end
    end

endmodule
