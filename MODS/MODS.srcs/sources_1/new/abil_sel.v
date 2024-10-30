`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2024 10:03:10
// Design Name: 
// Module Name: main
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


module abil_sel(
    input clk,
    input turned_on,
    input btnC,btnL,btnR,
    output [3:0] led,
    output [0:6] seg,
    output [3:0] an,
    output dp,
    output [7:0]JC
    );
    
    wire AI_SEL;
    wire AI_STABLE;

    wire selected;
    
    //edited
    reg ai_turned_on = 1'b1;

    
    // abilities of player 1 and bot (player 2), convert to output if you need
    wire [1:0] P1_selection;
    wire [1:0] P2_selection;
    
    wire [12:0]pixel_index;
    wire [15:0]oled_colour;

    wire clk6p25m;
    
    flexi_clk clk6p25m_instantiate(
        .clk(clk),
        .m_const(32'd7),
        .my_clk(clk6p25m)
    );


    // extract the state from ability_select_screen to be used for oled display
    // led is used for debugging purposes, remove where necessary
    ability_select_main dut (.clk(clk),.turned_on(turned_on),.ai_turned_on(ai_turned_on),.pixel_index(pixel_index),.oled_colour(oled_colour),.btnC(btnC),.btnL(btnL),.btnR(btnR),.led(led),.seg(seg),.an(an),.dp(dp),.P1_SEL(P1_selection),.P2_SEL(P2_selection));
        Oled_Display oled_display_instance(
        .clk(clk6p25m),
        .reset(1'b0),
        .frame_begin(),
        .sending_pixels(),
        .sample_pixel(),
        .pixel_index(pixel_index),
        .pixel_data(oled_colour),
        .cs(JC[0]),
        .sdin(JC[1]),
        .sclk(JC[3]),
        .d_cn(JC[4]),
        .resn(JC[5]),
        .vccen(JC[6]),
        .pmoden(JC[7])
    );
    
    
    
endmodule
