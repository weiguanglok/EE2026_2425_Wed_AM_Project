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
    output reg [0:6]seg = 7'b1111111,
    output reg [3:0]an = 4'b1111,
    output reg dp = 1'b1,          // OLED display interfacedefinerLED later
    output [15:0] led
    );
    
    
    //Clock wires & regs for oled_display
    wire clk6p25m;
        flexi_clk clk6p25m_instantiate(
            .clk(clk),
            .m_const(32'd7),
            .my_clk(clk6p25m)
        );
    reg [15:0] oled_colour_R;
    reg [15:0] oled_colour_L;
    wire [12:0]pixel_index_R;
    wire [12:0]pixel_index_L;
    
    // oled ouputs for FSM
    wire [15:0] oled_colour_start;
    wire [15:0] oled_colour_ai;
    wire [15:0] oled_colour_player;
    wire [15:0] oled_colour_ability_select;
    wire [15:0] oled_colour_parry;
    
    // FSM STATE REGISTERS
    reg [3:0]state = 4'd0;
    parameter STATE_START = 0;
    wire is_start;
    parameter STATE_IDLE = 1;
    parameter STATE_SELECT = 2;
    parameter STATE_WHO_WIN = 3;
    parameter STATE_RESOLVE_W =4;
    parameter STATE_RESOLVE_P = 5;
    parameter STATE_RESOLVE_P_L = 6;
    parameter STATE_RESOLVE_P_W = 7;
    parameter STATE_DMG_MODIFIER_n_RESOLUTE = 8;
    parameter STATE_END = 9;
    
    
    //for battle animation
    reg [2:0]attack_state = 3'b000;
    wire [1:0] P1_SEL,P2_SEL;
    wire winner,bot_selected;
    wire [1:0] parry_result;
    wire endgame;
    
    //Seven seg
    wire [0:7] seg_abil,seg_end,seg_parry;
    wire [3:0] an_abil,an_end,an_parry;
    
    
    // Debounce all buttons
    wire btnR_stable, btnL_stable, btnC_stable, btnU_stable, btnD_stable;
    debounce debounce_btnR (.clk(clk), .button_in(btnR), .button_out(btnR_stable));
    debounce debounce_btnL (.clk(clk), .button_in(btnL), .button_out(btnL_stable));
    debounce debounce_btnC (.clk(clk), .button_in(btnC), .button_out(btnC_stable));
    debounce debounce_btnD (.clk(clk), .button_in(btnD), .button_out(btnD_stable));
    debounce debounce_btnU (.clk(clk), .button_in(btnU), .button_out(btnU_stable));
    // delay mechanism
    reg [31:0]count_delay=32'd0;
    
    initial begin
        state = STATE_START;
    end
    
    wire btnU_synced;
    button_sync button_Up(
        .clk(clk),             
        .button_in(btnU_stable),       // Debounced button input
        .button_sync(btnU_synced) // Synchronized button output
    );
 
    //Oled, fsm control
    always @(posedge clk) begin
        casez (state)
            STATE_START: begin
                oled_colour_R <= oled_colour_start;
                oled_colour_L <= 16'd0;
                state <= (is_start)? STATE_IDLE:STATE_START;
                seg <= 7'b1111111;
                an <= 4'b1111;
            end
            STATE_IDLE: begin 
                state <= (btnU_synced)? STATE_SELECT:STATE_IDLE;
                oled_colour_L <= oled_colour_ai;
                oled_colour_R <= oled_colour_player;
            end
            STATE_SELECT: begin 
                count_delay <= ((count_delay>=200_000_000)&& bot_selected)? 0 : count_delay+1; //added
                oled_colour_L <= oled_colour_ai;
                oled_colour_R <=oled_colour_ability_select;
                state  <= (bot_selected && (count_delay==200_000_000))?STATE_WHO_WIN : STATE_SELECT; //modified
                seg <= seg_abil;
                an <= an_abil;
            end 
            STATE_WHO_WIN: begin
                count_delay <= (count_delay>=200_000_000)? 0 : count_delay+1;
                oled_colour_L <= oled_colour_ai;
                oled_colour_R <= oled_colour_player;
                seg <= 7'b1111111;
                an <= 4'b1111;
                if (winner && (count_delay==200_000_000))state  <= STATE_RESOLVE_W; //create a timer with bol_selected as a trigger
                else if(~winner && (count_delay==200_000_000))   state  <=  STATE_RESOLVE_P;
                else  state <= STATE_WHO_WIN;
            end
            STATE_RESOLVE_W: begin
                count_delay <= (count_delay>=300_000_000)? 0 : count_delay+1;
                oled_colour_L <= oled_colour_ai;
                oled_colour_R <= oled_colour_player;
                state  <= (count_delay>=300_000_000)? STATE_DMG_MODIFIER_n_RESOLUTE:STATE_RESOLVE_W;
            end
            STATE_RESOLVE_P: begin 
                oled_colour_L <= oled_colour_ai;
                oled_colour_R <= oled_colour_parry;
                seg <= seg_parry;
                an <= an_parry;
                if (parry_result == 2'b01) begin
                    state <= STATE_RESOLVE_P_W;
                end
                else if(parry_result == 2'b10)
                    state <=  STATE_RESOLVE_P_L; //parry fail, dmg taken animation
            end
            STATE_RESOLVE_P_W: begin 
                count_delay <= (count_delay>=300_000_000)? 0 : count_delay+1;
                oled_colour_L <= oled_colour_ai;
                oled_colour_R <= oled_colour_player;
                seg <= 7'b1111111;
                an <= 4'b1111;
                state  <= (count_delay>=300_000_000)? STATE_DMG_MODIFIER_n_RESOLUTE:STATE_RESOLVE_P_W;
            end // if else statement needed
            STATE_RESOLVE_P_L: begin 
                count_delay <= (count_delay>=300_000_000)? 0 : count_delay+1;
                state  <= (count_delay>=300_000_000)? STATE_DMG_MODIFIER_n_RESOLUTE:STATE_RESOLVE_P_L; //create a timer with finish==0 as a trigger
                oled_colour_L <= oled_colour_ai;
                oled_colour_R <= oled_colour_player;
                seg <= 7'b1111111;
                an <= 4'b1111;
            end // if else statement needed
           STATE_DMG_MODIFIER_n_RESOLUTE: begin //add on later on 
//                count_delay <= (count_delay>=300_000_000)? 0 : count_delay+1;
               oled_colour_L <= oled_colour_ai;
               oled_colour_R <= oled_colour_player;
               if ((led[1]&&winner)||((led[14])&&(parry_result==2'b10))) begin //changed
                state <= STATE_END;
               end
               else begin
                state  <= STATE_IDLE; //changed
               end
           end
           STATE_END: begin
                oled_colour_L <= 16'd0;
                oled_colour_R <= 16'b11111_111111_11111;
                state <= (btnU_stable)?STATE_START:STATE_END;
                seg <= seg_end;
                an <= an_end;
           end
//            STATE_DMG_RESOLVED: state <= (if_ded)? STATE_END: STATE_IDLE;
            default : state <= STATE_IDLE;
        endcase 
    end
    //instantiate all odules required
    Top_Home_Screen top_screen_render(
        .pixel_index(pixel_index_R),
        .clk(clk),
        .btnR(btnR_stable), .btnL(btnL_stable), .btnC(btnC_stable), .btnD(btnD_stable), .btnU(btnU_stable),
        .STATE(state),
        .oled_colour(oled_colour_start),
        .is_start(is_start)         
    );
    ability_select_main run_ability_select_main(
        .clk(clk),
        .turned_on(state>=STATE_SELECT),
        .ai_turned_on(1'b1),.btnC(btnC_stable),
        .btnL(btnL_stable),.btnR(btnR_stable),
        .pixel_index(pixel_index_R),
        .seg(seg_abil),.an(an_abil), //removed the dp
        .P1_SEL(P1_SEL),.P2_SEL(P2_SEL),
        .winner(winner),.oled_colour(oled_colour_ability_select),
        .selected(bot_selected));   
    battle_animation animation_instantiate(
        .clk(clk),
        .reset(1'b0),
        .state(state),
        .winner(winner),
        .P1_SEL(P1_SEL),.P2_SEL(P2_SEL),
        .pixel_index(pixel_index_R),  // Pixel index (passed from top-level)
        .oled_colour_ai(oled_colour_ai),
        .oled_colour_player(oled_colour_player));
     ddr_parry parry(
        .basys_clock(clk),
        .reset(state<STATE_RESOLVE_P),
        .btnL(btnL), .btnD(btnD), .btnU(btnU), 
        .btnR(btnR), .pixel_index(pixel_index_R),
        .led_colour(oled_colour_parry), 
        .parry_status(parry_result), 
        .lfsr_input({~P1_SEL,P2_SEL}),
        .seg(seg_parry),
        .an(an_parry));    
    
    
        
        
        
        
    // Oled Display module - drive the OLED with pixel data
    Oled_Display oled_display_instance_R(
        .clk(clk6p25m),
        .reset(),
        .frame_begin(),
        .sending_pixels(),
        .sample_pixel(),
        .pixel_index(pixel_index_R),//ouput pixel data at 6.25MHz
        .pixel_data(oled_colour_R),//input oled colour data at 6.25MHz
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
        .pixel_index(pixel_index_L),//ouput pixel data at 6.25MHz
        .pixel_data(oled_colour_L),//input oled colour data at 6.25MHz
        .cs(JX[0]),
        .sdin(JX[1]),
        .sclk(JX[3]),
        .d_cn(JX[4]),
        .resn(JX[5]),
        .vccen(JX[6]),
        .pmoden(JX[7])
    );

    led_resolute(.state(state),
   .clk(clk),
    .winner(winner),
    .parry_result(parry_result),
    .led(led),
    .endgame(endgame)
    );
    
    victory_screen_main victory(
        .clk(clk),
        .turned_on(state>=STATE_END),
        .led(led),
        .seg(seg_end),
        .an(an_end)
        );
    
endmodule
