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
    input [4:0] state,
    input clk,
    input sw14,sw1,
    input winner,
    input [1:0] parry_result,
    output reg [15:0] led = 16'b0000_0001_1000_0000,//to be changed
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
    initial begin
    
    end
    always @(posedge clk) begin
        if (state == STATE_START) begin
            led <= 16'b0000_0001_1000_0000;
        end
        else if ((state == STATE_IDLE) && sw14)begin
            led <= 16'b0110_0000_0000_0000;
        end
        else if ((state == STATE_IDLE) && sw1)begin
            led <= 16'b0000_0000_0000_0110;        
        end
        else begin
            if (parry_result==2'b01&&(state == STATE_DMG_MODIFIER_n_RESOLUTE)) begin
            end
            else if (winner &&(state == STATE_DMG_MODIFIER_n_RESOLUTE)) begin
                led <= led << 1;
            end
            else if (~winner &&(state == STATE_DMG_MODIFIER_n_RESOLUTE)) begin
                led <= led >> 1;
            end
            else begin
            end
        end
//        else begin
//            led <= 16'b0000_0001_1000_0000; //changed
//        end
    end
    
endmodule
