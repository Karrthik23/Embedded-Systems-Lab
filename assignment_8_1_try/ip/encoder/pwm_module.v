module pwm_module #(
    parameter PWM_RES = 2500
)(
    input wire clk,                      // 50 MHz system clock
    input wire reset,                    // Active-high synchronous reset
    input wire enable,                   // Enable signal for PWM
    input wire signed [8:0] pwm_input,   // -255 to +255 input controls direction and duty

    output reg ChannelA,                 // Direction control: CW/CCW
    output reg ChannelB,                 // Direction control: CW/CCW
    output reg PWM_out                   // PWM signal output
);

    // Parameters
                // For 20 kHz PWM at 50 MHz clock

    // Internal registers
    reg [11:0] counter = 0;              // 12-bit counter for PWM period (0 to 2499)
    reg [11:0] duty_cycle = 0;           // Scaled duty cycle value (0 to 2500)
    reg direction = 0;                   // 0 = Clockwise, 1 = Counter-Clockwise

    // --- Duty Cycle and Direction Logic ---
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            duty_cycle <= 0;
            direction <= 0;
        end else if (enable) begin
            if (pwm_input > 0) begin
                duty_cycle <= (pwm_input * PWM_RES) / 255;
                direction <= 0;  // Clockwise
            end else if (pwm_input < 0) begin
                duty_cycle <= ((-pwm_input) * PWM_RES) / 255;
                direction <= 1;  // Counter-Clockwise
            end else begin
                duty_cycle <= 0;
                direction <= 0;  // No motion
            end
        end else begin
            duty_cycle <= 0;
            direction <= 0;
        end
    end

    // --- Counter Logic ---
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
        end else if (enable) begin
            if (counter >= PWM_RES - 1)
                counter <= 0;
            else
                counter <= counter + 1;
        end else begin
            counter <= 0;
        end
    end

    // --- PWM Output Logic ---
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PWM_out <= 0;
        end else if (enable) begin
            PWM_out <= (counter < duty_cycle) ? 1'b1 : 1'b0;
        end else begin
            PWM_out <= 0;
        end
    end

    // --- Direction Signal Logic for ChannelA and ChannelB ---
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ChannelA <= 0;
            ChannelB <= 0;
        end else if (enable) begin
            if (direction == 0) begin
                ChannelA <= 1;  // Clockwise
                ChannelB <= 0;
            end else begin
                ChannelA <= 0;  // Counter-Clockwise
                ChannelB <= 1;
            end
        end else begin
            ChannelA <= 0;
            ChannelB <= 0;
        end
    end

endmodule
