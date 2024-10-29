`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2024 22:06:37
// Design Name: 
// Module Name: seven_seg_mux
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


module seven_seg_mux(
    input clk,
    input start,
    input [1:0] modifier_sel,
    input [0:6] seg_start,seg_modif,seg_double_speed,seg_half_speed,seg_no_change,
    input [3:0] an_start, an_modif,an_double_speed,an_half_speed,an_no_change,
    output reg [0:6] seg = 7'b1111111,
    output reg [3:0] an = 4'b1111
    );
    
    always @(posedge clk) begin
        if (modifier_sel == 2'b01) begin
            seg <= seg_double_speed;
            an <= an_double_speed;
        end
        else if (modifier_sel == 2'b11) begin
            seg <= seg_no_change;
            an <= an_no_change;
        end 
        else if (modifier_sel == 2'b10) begin
            seg <= seg_half_speed;
            an <= an_half_speed;
        end 
        else if (start) begin
            seg <= seg_modif;
            an <= an_modif;
        end
        else begin
            seg <= seg_start;
            an <= an_start;
        end
    end
    
endmodule
