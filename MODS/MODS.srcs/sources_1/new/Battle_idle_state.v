`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2024 12:29:43
// Design Name: 
// Module Name: Battle_idle_state
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


module battle_animation(input clk,
    input reset,
    input flip, //who wins, ai is 1, player is 0
    input [3:0] state, //state tells me who is winner or in idle
    input [1:0] P1_SEL,
    input [1:0] P2_SEL, 
    input winner,
    input bot_selected,
    input [12:0] pixel_index,  // Pixel index (passed from top-level)
    output reg [15:0] oled_colour_ai,
    output reg [15:0] oled_colour_player);
       parameter STATE_IDLE = 1;
       parameter STATE_SELECT = 2;
       parameter STATE_WHO_WIN = 3;
       parameter STATE_RESOLVE_W =4;
       parameter STATE_RESOLVE_P = 5;
       parameter STATE_RESOLVE_P_L = 6;
       parameter STATE_RESOLVE_P_W = 7;
       parameter STATE_DMG_MODIFIER_n_RESOLUTE = 8;
         wire clk6p25;
        flexi_clk clk6p25m(.clk(clk), .m_const(7), .my_clk(clk6p25));
        
        parameter [6:0]bob_x = 7'd68; 
        parameter [5:0]bob_y=6'd7;
        parameter [6:0]biche_x = 7'd64; 
        parameter [5:0]biche_y=6'd8;
        parameter [6:0]pause_x = 7'd3; 
        parameter [5:0]pause_y = 6'd5;
        
        
        reg [6:0]rock_x = 7'd36;
        reg [5:0]rock_y = 6'd16;
        reg [6:0]paper_clip_x = 7'd34;
        reg [5:0]paper_clip_y = 6'd2;
        reg [6:0]paper_tack_x = 7'd25;
        reg [5:0]paper_tack_y = 6'd24;
        reg [6:0]paper_plane_x = 7'd40;
        reg [5:0]paper_plane_y = 6'd44;
        reg [6:0]scissor_x = 7'd39;
        reg [5:0]scissor_y = 6'd17;
        reg [6:0]parry_x = 7'd34;
        reg [5:0]parry_y = 6'd19;
        
        wire [15:0] oled_colour_battlescreen_layer1;
        wire [15:0] oled_colour_battlescreen_layer2;
        wire [15:0] oled_colour_ai_chose_R;
        wire [15:0] oled_colour_ai_chose_P;
        wire [15:0] oled_colour_ai_chose_S;
//        wire [15:0] oled_pause;
        wire [15:0] oled_dmg_taken;
        wire [15:0] oled_bob_head_n_body;
        wire [15:0] oled_bob_arm;
        wire [15:0] oled_bob_arm_attack;
        wire [15:0] oled_biche_head_n_body;
        wire [15:0] oled_biche_arm;
        wire [15:0] oled_biche_arm_attack;
        reg [15:0] oled_charac_arm;
        reg [15:0] oled_charac_arm_attack;
        reg [15:0] oled_charac_arm_2;
        
        // create states for arm movements 
        reg [2:0]atk;
//        reg atk_syncR, atk_syncP, atk_syncS, parry_sync, pause_sync; 
        
        wire fourfps;
        flexi_clk run_fourfps(.clk(clk), .m_const(12499999), .my_clk(fourfps));
        reg [1:0] count_2_four= 2'b00;
        reg [5:0] phase;
        
        always @ (posedge fourfps) begin
            case(count_2_four)
                2'b00: begin 
                    count_2_four<=2'b01;
                    phase <= 6'd37; 
                    scissor_x <=39;
                end
                2'b01: begin 
                    count_2_four<=2'b10;
                    phase <= 6'd36; 
                    scissor_x <=17;
                end
                2'b10: begin 
                    count_2_four<=2'b11;
                    phase <= 6'd37; 
                    scissor_x <=39;
                end
                2'b11: begin 
                    count_2_four<=2'b00;
                    phase <= 6'd38; 
                    scissor_x <=17;
                end
            endcase
            if (winner && (state >=STATE_RESOLVE_W)) atk <= {1'b1,P1_SEL};
            else if (~winner && (state >=STATE_RESOLVE_P)) atk <= {1'b0,P2_SEL}; // logic for attack animation
        end
        // rock attack 
        wire [15:0] oled_rock_attack;
        wire clk30fps;
        reg [1:0]rotation_state;
        flexi_clk run_clk30fps(.clk(clk), .m_const(1666666), .my_clk(clk30fps));
        //rock attack
        always @ (posedge clk30fps) begin
            if (rock_x==0) rock_x <=36;
            else if (rock_x>0 && (atk[1:0]==2'b00)&&(state >=STATE_WHO_WIN)) begin
                rock_x <=rock_x-1;
                rotation_state <= (rotation_state==2'b11)? 0:rotation_state+1;
            end
        end
        ///paper attack
        wire [15:0] oled_paper_clip_attack;
        wire [15:0] oled_paper_tack_attack;
        wire clk25fps;
        flexi_clk run_clk25fps(.clk(clk), .m_const(1999999), .my_clk(clk25fps));
        wire [15:0]oled_paper_plane_attack;
        wire clk35fps;
        flexi_clk run_clk35fps(.clk(clk), .m_const(1428570), .my_clk(clk35fps));
        always @ (posedge clk30fps) begin
            if ((atk[1:0]==2'b01)&&(state >=STATE_WHO_WIN)) begin
                if (paper_clip_x==0) paper_clip_x <= 34; 
                else paper_clip_x <= paper_clip_x-1;
            end
        end
        always @ (posedge clk25fps) begin
            if ((atk[1:0]==2'b01)&&(state >=STATE_WHO_WIN)) begin
                if (paper_tack_x==0) paper_tack_x <= 25; 
                else paper_tack_x <= paper_tack_x-1;
            end
        end
        always @ (posedge clk35fps) begin
            if ((atk[1:0]==2'b01)&&(state >=STATE_WHO_WIN)) begin
                if (paper_plane_x==0) paper_plane_x <= 40; 
                else paper_plane_x <= paper_plane_x-1;
            end
        end
        //Scissors atk
        wire [15:0] oled_scissor_open_attack;
        wire [15:0] oled_scissor_close_attack;
        //parry def
        wire [15:0] oled_parry;
        
        battlescreen_background battlescreen1(// left screen
            .clk(clk6p25),
            .flip(1),
            .pixel_index(pixel_index),
            .oled_colour(oled_colour_battlescreen_layer1));
        battlescreen_background battlescreen2(//right screen 
            .clk(clk6p25),
            .flip(0),
            .pixel_index(pixel_index),
            .oled_colour(oled_colour_battlescreen_layer2));

            
            
        biche_head_n_body run_biche_head_n_body(.clk(clk6p25),               
            .pixel_index(pixel_index), 
            .flip(1),
            .sprite_x(biche_x),                 
            .sprite_y(biche_y),                 
            .background_pixel(oled_colour_battlescreen_layer1),
            .oled_colour(oled_biche_head_n_body));
        biche_arm run_biche_arm(.clk(clk6p25),               
            .pixel_index(pixel_index), 
            .flip(1),
            .sprite_x(biche_x),                 
            .sprite_y(phase-4),                 
            .background_pixel(oled_biche_head_n_body),                 
            .oled_colour(oled_biche_arm)); 
        biche_arm_attack run_biche_arm_attack(.clk(clk6p25),               
            .pixel_index(pixel_index), 
            .flip(1),
            .sprite_x(biche_x),                 
            .sprite_y(biche_y+21),                 
            .background_pixel(oled_biche_head_n_body),                 
            .oled_colour(oled_biche_arm_attack)); 
            
            
        bob_head_n_body run_bob_head_n_body(.clk(clk6p25),               
            .pixel_index(pixel_index), 
            .flip(0),
            .sprite_x(bob_x),                 
            .sprite_y(bob_y),                 
            .background_pixel(oled_colour_battlescreen_layer2),
            .oled_colour(oled_bob_head_n_body));
        bob_arm run_bob_arm(.clk(clk6p25),               
            .pixel_index(pixel_index), 
            .flip(0),
            .sprite_x(bob_x+5),                 
            .sprite_y(phase),                 
            .background_pixel(oled_bob_head_n_body),                 
            .oled_colour(oled_bob_arm)); 
        bob_arm_attack run_bob_arm_attack(.clk(clk6p25),               
            .pixel_index(pixel_index), 
            .flip(0),
            .sprite_x(bob_x-2),                 
            .sprite_y(bob_y+21),                 
            .background_pixel(oled_bob_head_n_body),                 
            .oled_colour(oled_bob_arm_attack));
            
        skillscreen_icon_rock icon_rock_render(
            .clk(clk6p25),
            .pixel_index(pixel_index),
            .sprite_x(37),.sprite_y(16),
            .background_pixel(oled_biche_arm_attack),
            .oled_colour(oled_colour_ai_chose_R));
        skillscreen_icon_paper icon_paper_render(
            .clk(clk6p25),
            .pixel_index(pixel_index),
            .sprite_x(37),.sprite_y(16),
            .background_pixel(oled_biche_arm_attack),
            .oled_colour(oled_colour_ai_chose_P));
        skillscreen_icon_scissors icon_scissors_render(
            .clk(clk6p25),
            .pixel_index(pixel_index),
            .sprite_x(37),.sprite_y(16),
            .background_pixel(oled_biche_arm_attack),
            .oled_colour(oled_colour_ai_chose_S));
        
        
            
        rock_attack run_rock_attack(.clk(clk6p25),               
            .pixel_index(pixel_index), 
            .sprite_x(rock_x),
            .rotation(rotation_state),                 // X coordinate for the title
            .sprite_y(rock_y),                 // Y coordinate for the title
            .background_pixel(oled_charac_arm_attack),                 
            .oled_colour(oled_rock_attack));   
        paper_airplane_attack run_paper_airplane_attack(.clk(clk6p25),               
            .pixel_index(pixel_index),
            .flip(~atk[2]), 
            .sprite_x(paper_plane_x),                
            .sprite_y(paper_plane_y),                
            .background_pixel(oled_charac_arm_attack),                 
            .oled_colour(oled_paper_plane_attack));
        paper_clip_attack run_paper_clip_attack(.clk(clk6p25),               
            .pixel_index(pixel_index), 
            .sprite_x(paper_clip_x),                
            .sprite_y(paper_clip_y),  
            .flip(~atk[2]),              
            .background_pixel(oled_paper_plane_attack),                 
            .oled_colour(oled_paper_clip_attack));
        paper_tack_attack run_paper_tack_attack(.clk(clk6p25),               
            .pixel_index(pixel_index), 
            .sprite_x(paper_tack_x),                
            .sprite_y(paper_tack_y),      
            .flip(~atk[2]),          
            .background_pixel(oled_paper_clip_attack),                 
            .oled_colour(oled_paper_tack_attack));
        scissor_close_attack run_scissor_close_attack(.clk(clk6p25),               
            .pixel_index(pixel_index), 
            .sprite_x(scissor_x),                
            .sprite_y(scissor_y),                
            .background_pixel(oled_charac_arm_attack),                 
            .oled_colour(oled_scissor_close_attack));
        scissor_open_attack run_scissor_open_attack(.clk(clk6p25),               
            .pixel_index(pixel_index), 
            .sprite_x(scissor_x),                
            .sprite_y(scissor_y),                
            .background_pixel(oled_charac_arm_attack),                 
            .oled_colour(oled_scissor_open_attack));  
        parry_shield run_parry_shield(.clk(clk6p25),               
            .pixel_index(pixel_index), 
            .sprite_x(parry_x),                
            .sprite_y(parry_y),                
            .background_pixel(oled_charac_arm_2),                 
            .oled_colour(oled_parry));
//        pause_menu run_pause_menu(.clk(clk6p25),               
//            .pixel_index(pixel_index), 
//            .sprite_x(pause_x),                
//            .sprite_y(pause_y), 
//            .flip(~atk[2]),               
//            .background_pixel(oled_colour_battlescreen_layer1),                 
//            .oled_colour(oled_pause));
        dmg_taken run_dmg_taken(.clk(clk6p25),               
            .pixel_index(pixel_index), 
            .sprite_x(48),                
            .sprite_y(12), 
            .flip(~atk[2]),               
            .background_pixel(oled_charac_arm_2),                 
            .oled_colour(oled_dmg_taken));
           
            
        always @(posedge clk6p25) begin
             case(state)
             STATE_IDLE: begin
                oled_colour_player <= oled_bob_arm;
                oled_colour_ai <=oled_biche_arm;
             end
             STATE_SELECT: begin
                 oled_colour_player <= 16'd0;
                 oled_colour_ai <=oled_biche_arm;
             end
             STATE_WHO_WIN: begin 
                 oled_colour_player <= oled_bob_arm;
                 casez(P2_SEL)
                    2'b00:oled_colour_ai <=oled_colour_ai_chose_R;
                    2'b01:oled_colour_ai <=oled_colour_ai_chose_P;
                    2'b10:oled_colour_ai <=oled_colour_ai_chose_S;
                 endcase
             end
             STATE_RESOLVE_W: begin
                oled_charac_arm_attack <= oled_bob_arm_attack;
                oled_charac_arm <=oled_bob_arm;
                oled_charac_arm_2 <= oled_biche_arm;
                if (atk[1:0]==2'b00)oled_colour_player <= oled_rock_attack;//rock attack 
                else if (atk[1:0]==2'b01)oled_colour_player <= oled_paper_tack_attack;//rock attack 
                else begin 
                    if (scissor_x ==39)oled_colour_player <=oled_scissor_open_attack;
                    else oled_colour_player <=oled_scissor_close_attack;
                end
                oled_colour_ai <= oled_dmg_taken;
             end
             STATE_RESOLVE_P: begin
                 oled_charac_arm_attack <= oled_biche_arm_attack;
                 oled_charac_arm <=oled_biche_arm;
                 oled_charac_arm_2 <=oled_bob_arm;
                 if (atk[1:0]==2'b00)oled_colour_ai <= oled_rock_attack;//rock attack 
                 else if (atk[1:0]==2'b01)oled_colour_ai <= oled_paper_tack_attack;//rock attack 
                 else begin 
                     if (scissor_x ==39)oled_colour_ai <=oled_scissor_open_attack;
                     else oled_colour_ai <=oled_scissor_close_attack;
                 end
                 oled_colour_player<=16'd0;
              end
             STATE_RESOLVE_P_W: begin
                oled_charac_arm_attack <= oled_biche_arm_attack;
                oled_charac_arm <=oled_biche_arm;
                oled_charac_arm_2 <=oled_bob_arm;
                if (atk[1:0]==2'b00)oled_colour_ai <= oled_rock_attack;//rock attack 
                else if (atk[1:0]==2'b01)oled_colour_ai <= oled_paper_tack_attack;//rock attack 
                else begin 
                    if (scissor_x ==39)oled_colour_ai <=oled_scissor_open_attack;
                    else oled_colour_ai <=oled_scissor_close_attack;
                end
                oled_colour_player<=oled_parry;
             end
             STATE_RESOLVE_P_L: begin 
                oled_charac_arm_attack <= oled_biche_arm_attack;
                oled_charac_arm <=oled_biche_arm;
                oled_charac_arm_2 <=oled_bob_arm;
                if (atk[1:0]==2'b00)oled_colour_ai <= oled_rock_attack;//rock attack 
                else if (atk[1:0]==2'b01)oled_colour_ai <= oled_paper_tack_attack;//rock attack 
                else begin 
                    if (scissor_x ==39)oled_colour_ai <=oled_scissor_open_attack;
                    else oled_colour_ai <=oled_scissor_close_attack;
                end
                oled_colour_player<=oled_dmg_taken;
             end
             STATE_DMG_MODIFIER_n_RESOLUTE: begin
                oled_colour_player <= oled_bob_arm;
                oled_colour_ai <=oled_biche_arm;
             end
             endcase
         end
 
        

endmodule