`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2024 22:55:06
// Design Name: 
// Module Name: modifier_effects
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


module modifier_effects(
    input clk,
    input [1:0] modifier_sel,
    output reg double_damage = 1'b0,
    output reg half_damage = 1'b0,
    output reg double_speed = 1'b0,
    output reg half_speed = 1'b0
    );
    
    always @(posedge clk) begin
        if (modifier_sel) begin
            case (modifier_sel)
                2'b01: begin
                    double_damage <= 1'b1;
                    half_damage <= 1'b0;
                    double_speed <= 1'b1;
                    half_speed <= 1'b0;
                end
                2'b10: begin
                    double_damage <= 1'b0;
                    half_damage <= 1'b1;
                    double_speed <= 1'b0;
                    half_speed <= 1'b1;
                end
                2'b11: begin
                    double_damage <= 1'b0;
                    half_damage <= 1'b0;
                    double_speed <= 1'b0;
                    half_speed <= 1'b0;
                end
            endcase
        end
        else begin
            double_damage <= 1'b0;
            half_damage <= 1'b0;
            double_speed <= 1'b0;
            half_speed <= 1'b0;
        end
    end
    
endmodule
