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
    input [15:0] led,
    input turned_on,
    input [0:6] seg_player,seg_bot,
    input [3:0] an_player, an_bot,
    output reg [0:6] seg = 7'b1111111,
    output reg [3:0] an = 4'b1111
    );
    
    always @(posedge clk) begin
        if (~turned_on) begin
            seg <= 7'b1111111;
            an <= 4'b1111;
        end
        else begin
            if (led[15]) begin
                seg <= seg_player;
                an <= an_player;
            end
            else if (led[0]) begin
                seg <= seg_bot;
                an <= an_bot;
            end
            else begin
                seg <= 7'b1111111;
                an <= 4'b1111;
            end
        end
    end
    
endmodule
