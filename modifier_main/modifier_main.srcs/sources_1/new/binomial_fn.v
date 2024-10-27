`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.10.2024 09:22:59
// Design Name: 
// Module Name: binomial_fn
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module binomial_fn(
    input clk,            // Clock signal
    input turned_on,          // Reset signal
    input ai_turned_on,     // Check if vs computer
    input [15:0] p,       // Probability of success in Q16 fixed-point format (0 to 1 represented as 16-bit fraction), p_fixed = p_float * 65536
    output reg success = 1'b0    // Output: 1 for success, 0 for failure
);

    reg [31:0] random_value = 32'd3; // To hold the random number

    // Random number generation (simple linear feedback shift register)
    always @(posedge clk) begin
        if (turned_on && ai_turned_on) begin
            // Linear Feedback Shift Register (LFSR) for pseudo-random numbers
            random_value <= {random_value[29:0], random_value[5] ^ random_value[21], random_value[3] ^ random_value[28]};
        end else begin
            random_value <= 32'd3; // Initialize random value
        end
    end

    // Compare random value with probability to determine success or failure
    always @(posedge clk or posedge turned_on) begin
        if (turned_on && ai_turned_on) begin
            // Compare the lower 16 bits of the random number to the probability
            if (random_value[15:0] < p) begin
                success <= 1; // Success (high)
            end else begin
                success <= 0; // Failure (low)
            end
        end else begin
            success <= 0; // Initialize output
        end
    end

endmodule
