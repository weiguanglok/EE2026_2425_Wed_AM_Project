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


module abil_sel_ai(
    input clk,            // Clock signal
    input turned_on,          // Reset signal
    input ai_turn,     // Check if vs computer
    output reg [1:0] success = 2'b00,
    output reg selected = 1'b0
);
    parameter TOTAL = 16'd65535;

    reg [15:0] random_value = 16'b1001_0101_0010_1011; // To hold the random number

    // Random number generation (simple linear feedback shift register)
    always @(posedge clk) begin
        if (turned_on) begin
            // Linear Feedback Shift Register (LFSR) for pseudo-random numbers
            random_value <= {random_value[14:0], random_value[8] ^ random_value[3]};
        end else begin
            random_value <= 16'b1001_0101_0010_1011; // Initialize random value
        end
    end

    always @(posedge clk or posedge turned_on) begin
        if (turned_on && ai_turn && ~success) begin
            // Compare the 16 bits of the random number to the max value
            if (random_value < 16'd21845) begin
                success <= 2'b11; // top third
                selected <= 1'b1;
            end 
            else if (random_value < 16'd43690) begin
                success <= 2'b10; // mid third
                selected <= 1'b1;
            end 
            else begin
                success <= 2'b01; // bot third
                selected <= 1'b1;
            end
        end 
        else if (~ai_turn || ~turned_on) begin
            success <= 2'b00; // Reset success when either ai_turn or turned_on is off
            selected <= 1'b0;
        end
    end


endmodule

