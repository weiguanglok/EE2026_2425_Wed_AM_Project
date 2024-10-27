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


module main(
    input clk,
    input turned_on,
    input ai_turned_on,
    input btnC,btnU,btnD,
    output [3:0] led,
    output [0:6] seg,
    output [3:0] an,
    output dp
    );
    
    wire AI_SEL;
    wire AI_STABLE;

    wire selected;
    
    wire btnC_STABLE;
    wire timer_up;
    
    // abilities of player 1 and bot (player 2), convert to output if you need
    wire [1:0] P1_selection;
    wire [1:0] P2_selection;

    // extract the state from ability_select_screen to be used for oled display
    // led is used for debugging purposes, remove where necessary
    ability_select_main dut (.clk(clk),.turned_on(turned_on),.ai_turned_on(ai_turned_on),.btnC(btnC),.btnU(btnU),.btnD(btnD),.led(led),.seg(seg),.an(an),.dp(dp),.P1_SEL(P1_selection),.P2_SEL(P2_selection));
    
endmodule
