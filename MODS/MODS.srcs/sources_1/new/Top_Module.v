`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2024 13:43:32
// Design Name: 
// Module Name: Top_Module
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

//main module for the code
module Top_Module(
    input clk,  
    input btnR, btnL, btnC, btnD, btnU,   // Buttons for navigation and selection
    output [7:0] JC ,
    output [7:0] JX,
    output [0:6]seg,
    output [3:0]an,
    output dp          // OLED display interface
    );
    
    wire is_start;
    
    reg [1:0]GAME_STATE;
    parameter STATE_START = 0;
    parameter STATE_BATTLE = 1;
    
    reg [15:0] oled_colour_R;
    reg [15:0] oled_colour_L;
    wire [15:0] oled_colour_start;
    wire [15:0] oled_colour_ai;
    wire [15:0] oled_colour_player;

    wire [12:0]pixel_index_R;
    wire [12:0]pixel_index_L;
    wire clk6p25m;
    flexi_clk clk6p25m_instantiate(
        .clk(clk),
        .m_const(32'd7),
        .my_clk(clk6p25m)
    );

    // Debounce all buttons
    wire btnR_stable, btnL_stable, btnC_stable, btnU_stable, btnD_stable;
    debounce debounce_btnR (.clk(clk), .button_in(btnR), .button_out(btnR_stable));
    debounce debounce_btnL (.clk(clk), .button_in(btnL), .button_out(btnL_stable));
    debounce debounce_btnC (.clk(clk), .button_in(btnC), .button_out(btnC_stable));
    debounce debounce_btnD (.clk(clk), .button_in(btnD), .button_out(btnD_stable));
    debounce debounce_btnU (.clk(clk), .button_in(btnU), .button_out(btnU_stable));
    
    //instantiate all modules required
    Top_Home_Screen top_screen_render(
        .pixel_index(pixel_index_R),
        .clk(clk),
        .btnR(btnR_stable), .btnL(btnL_stable), .btnC(btnC_stable), .btnD(btnD_stable), .btnU(btnU_stable),
        .oled_colour(oled_colour_start),
        .is_start(is_start)         
    );   
   top_module_battle run_top_module_battle(
        .clk(clk),
        .reset(),
        .btnR(btnR_stable), .btnL(btnL_stable), .btnC(btnC_stable),
        .seg(seg),
        .an(an),
        .dp(dp),
        .pixel_index(pixel_index_R),
//        .pixel_index_ai(pixel_index_L),
        .oled_colour_L(oled_colour_ai),
        .oled_colour_R(oled_colour_player)
    );
    
    initial begin
        GAME_STATE = STATE_START;
    end
    
    
    always @ (*)begin
        if (is_start) GAME_STATE = STATE_BATTLE;
        case(GAME_STATE)
            STATE_START:begin
                oled_colour_R <= oled_colour_start;
                oled_colour_L <= 16'd0;
            end
            STATE_BATTLE:begin
                oled_colour_R <= oled_colour_player;
                oled_colour_L <= oled_colour_ai;
            end
        endcase
    end
    
    
        
    // Oled Display module - drive the OLED with pixel data
    Oled_Display oled_display_instance_R(
        .clk(clk6p25m),
        .reset(),
        .frame_begin(),
        .sending_pixels(),
        .sample_pixel(),
        .pixel_index(pixel_index_R),
        .pixel_data(oled_colour_R),
        .cs(JC[0]),
        .sdin(JC[1]),
        .sclk(JC[3]),
        .d_cn(JC[4]),
        .resn(JC[5]),
        .vccen(JC[6]),
        .pmoden(JC[7])
    );
    Oled_Display oled_display_instance_L(
        .clk(clk6p25m),
        .reset(),
        .frame_begin(),
        .sending_pixels(),
        .sample_pixel(),
        .pixel_index(pixel_index_L),
        .pixel_data(oled_colour_L),
        .cs(JX[0]),
        .sdin(JX[1]),
        .sclk(JX[3]),
        .d_cn(JX[4]),
        .resn(JX[5]),
        .vccen(JX[6]),
        .pmoden(JX[7])
    );
    
    
endmodule
