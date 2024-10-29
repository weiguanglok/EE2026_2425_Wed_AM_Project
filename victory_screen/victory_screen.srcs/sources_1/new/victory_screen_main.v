`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2024 20:29:11
// Design Name: 
// Module Name: victory_screen_main
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


module victory_screen_main(
    input clk,
    input [15:0] sw,
    output [15:0] led,
    output [0:6] seg,
    output [3:0] an,
    output reg dp = 1'b1
    );
    
    wire [0:6] seg_bot, seg_player;
    wire [3:0] an_bot, an_player;
    
    player_disp player (.clk(clk),.turned_on(sw[3]),.seg(seg_player),.an(an_player));
    bot_disp bot (.clk(clk),.turned_on(sw[3]),.seg(seg_bot),.an(an_bot));
    
    seven_seg_mux(.clk(clk),.led(led),.turned_on(sw[3]),.seg_player(seg_player),.seg_bot(seg_bot),.an_player(an_player),.an_bot(an_bot),.seg(seg),.an(an));
    
    assign led[15] = sw[15];
    assign led[0] = sw[0];
    
endmodule
