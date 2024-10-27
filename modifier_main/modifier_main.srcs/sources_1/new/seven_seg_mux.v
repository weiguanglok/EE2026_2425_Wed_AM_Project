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
    input [0:6] seg_start, seg_modif,
    input [3:0] an_start, an_modif,
    output reg [0:6] seg = 7'b1111111,
    output reg [3:0] an = 4'b1111
    );
    
    always @(posedge clk) begin
        if (start) begin
            seg <= seg_modif;
            an <= an_modif;
        end
        else begin
            seg <= seg_start;
            an <= an_start;
        end
    end
    
endmodule
