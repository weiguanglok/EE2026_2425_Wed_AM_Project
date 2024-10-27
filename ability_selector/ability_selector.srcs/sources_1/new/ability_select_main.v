`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2024 19:00:16
// Design Name: 
// Module Name: ability_select_main
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


module ability_select_main(
    input clk,
    input turned_on,
    input ai_turned_on,
    input btnC,btnU,btnD,
    output [3:0] led,
    output [0:6] seg,
    output [3:0] an,
    output dp,
    output [1:0] P1_SEL,
    output [1:0] P2_SEL
    );
    
    wire AI_SEL;
    wire AI_STABLE;

    wire selected;
    
    wire btnC_STABLE;
    wire timer_up;
    
    comp_sel ai_sel (.clk(clk),.turned_on(turned_on),.ai_turned_on(ai_turned_on),.success(AI_SEL));
    debounce debounce (.clk(clk),.button_in(AI_SEL),.button_out(AI_STABLE));
    
    ability_select_screen person_sel(.clk(clk),.turned_on(turned_on),.timer_up(timer_up),.btnU(btnU),.btnD(btnD),.btnC(btnC),.done(P1_SEL),.led(led),.ai_turn(AI_SEL));
    abil_sel_ai ai_immediate_selection (.clk(clk),.turned_on(turned_on),.ai_turn(AI_SEL),.success(P2_SEL),.selected(selected));
    
    countdown_timer_flexi countdown(.clk(clk),.trigger(turned_on),.btnC(btnC_STABLE),.done(timer_up),.seg(seg),.an(an),.dp(dp));
    debounce btnc (.clk(clk),.button_in(btnC),.button_out(btnC_STABLE));
    
endmodule
