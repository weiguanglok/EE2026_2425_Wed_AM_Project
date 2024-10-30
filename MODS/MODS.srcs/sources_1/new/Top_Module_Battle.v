`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2024 11:54:29
// Design Name: 
// Module Name: Top_Module_Battle
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

module top_module_battle(
    input clk,
    input reset,
    input  btnC,btnL,btnR,
    output [0:6]seg,
    output [3:0]an,
    output dp,
    input [12:0] pixel_index,
    output reg [15:0] oled_colour_L,
    output reg [15:0] oled_colour_R
);
    
    reg [2:0]state = 3'b000;
    parameter STATE_IDLE = 3'b000;
    parameter STATE_SELECT = 3'b001;
    parameter STATE_RESOLVE = 3'b010;
    parameter STATE_RESOLVE_W = 3'b011;
    parameter STATE_RESOLVE_L = 3'b100;
    parameter STATE_DMG_RESOLVED =3'b101;
    parameter STATE_END =3'b110;
    
    reg [2:0]attack_state = 3'b000;
    
    wire [1:0] P1_SEL,P2_SEL;
    wire winner,bot_selected;
    wire finish=0;
    
    wire [15:0]oled_colour_ai;
    wire [15:0] oled_colour_player;
    wire [15:0] oled_colour_ability_select;
    //instantiate all required modules 
    battle_animation animation_instantiate(
        .clk(clk),
        .reset(1'b0),
        .state(state),
        .P1_SEL(P1_SEL),.P2_SEL(P2_SEL),
        .pixel_index(pixel_index),  // Pixel index (passed from top-level)
        .oled_colour_ai(oled_colour_ai),
        .oled_colour_player(oled_colour_player),
        .finish(finish));
    
    ability_select_main run_ability_select_main(
        .clk(clk),
        .turned_on(state==STATE_SELECT),
        .ai_turned_on(1'b1),.btnC(btnC),
        .btnL(btnL),.btnR(btnR),
        .pixel_index(pixel_index),
        .seg(seg),.an(an),.dp(dp),
        .P1_SEL(P1_SEL),.P2_SEL(P2_SEL),
        .winner(winner),.oled_colour(oled_colour_ability_select),
        .selected(bot_selected));
    always @(posedge clk) begin
        casez (state)
            STATE_IDLE: begin 
                state <= (btnR)? STATE_SELECT:STATE_IDLE;
                oled_colour_L <= oled_colour_ai;
                oled_colour_R <= oled_colour_player;
            end
            STATE_SELECT: begin 
                oled_colour_L <= oled_colour_ai;
                oled_colour_R <=oled_colour_ability_select;
                if ((winner==1) && bot_selected)state  <= STATE_RESOLVE_W;
                else if((winner==0) && bot_selected)   state  <=  STATE_RESOLVE_L;
                else state <=STATE_SELECT;
            end 
            STATE_RESOLVE_W: begin
                state <= (finish==0)? STATE_DMG_RESOLVED:STATE_RESOLVE_W; 
                oled_colour_L <= oled_colour_ai;
                oled_colour_R <= oled_colour_player;
            end
            STATE_RESOLVE_L: begin 
                state <= (finish==0)?STATE_DMG_RESOLVED:STATE_RESOLVE_L;
                oled_colour_L <= oled_colour_ai;
                oled_colour_R <= oled_colour_player;
            end // if else statement needed
//            STATE_DMG_RESOLVED: state <= (if_ded)? STATE_END: STATE_IDLE;
            default : state <= STATE_IDLE;
        endcase 
    end
endmodule