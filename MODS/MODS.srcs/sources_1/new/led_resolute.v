`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2024 11:07:02
// Design Name: 
// Module Name: led_resolute
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


module led_resolute(
    input turned_on,
    input clk,
    input winner,
    input [1:0] parry_result,
    output reg [15:0] led = 16'b0100_0001_1000_0000,
    output reg endgame = 1'b0
    );
    
    parameter STATE_START = 0;
    parameter STATE_IDLE = 1;
    parameter STATE_SELECT = 2;
    parameter STATE_WHO_WIN = 3;
    parameter STATE_RESOLVE_W =4;
    parameter STATE_RESOLVE_P = 5;
    parameter STATE_RESOLVE_P_L = 6;
    parameter STATE_RESOLVE_P_W = 7;
    parameter STATE_DMG_MODIFIER_n_RESOLUTE = 8;
    
    always @(posedge clk) begin
        if (turned_on) begin
            if (parry_result) begin
            end
            else if ((parry_result == 2'b10)&&(led[14])&~winner) begin
                endgame <= 1'b1;
                led = led << 1;
            end
            else if ((led[1])&& winner) begin
                endgame <= 1'b1;
                led = led >> 1;
            end
            else if (winner) begin
                led = led << 1;
            end
            else begin
                led = led >> 1;
            end
        end
//        else begin
//            led <= 16'b0000_0001_1000_0000; //changed
//        end
    end
    
endmodule
