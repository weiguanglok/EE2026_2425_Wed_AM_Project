`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2024 01:38:29 AM
// Design Name: 
// Module Name: mainscreen_page
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

module mainscreen_page_render(
    input clk6p25m,
    input btnU, btnD,   // Buttons to change states
    input [12:0] pixel_index,  // Pixel index (passed from top-level)
    output reg [15:0] oled_colour
);

    wire [15:0] oled_colour_bg_layer1;
    wire [15:0] oled_colour_bg_layer2;
    wire [15:0] oled_colour_bg_layer3;
    wire [15:0] oled_colour_bg_layerFinal;
    
    wire [15:0] oled_selector_menu;
    wire [15:0] oled_colour_title;
    wire [15:0] oled_selector_arrow;
    reg [15:0] blended_sprite;
    reg [5:0] sel_arrow_coor_x;
    reg [5:0] sel_arrow_coor_y;
    reg state_mainscreen;        // State register
    
    // States for the page
    parameter STATE_MS_START = 0;
    parameter STATE_MS_GUIDE = 1;
    
    parameter STATE_MS_START_LOC_X = 22;
    parameter STATE_MS_START_LOC_Y = 42; 
    
    parameter STATE_MS_GUIDE_LOC_X = 25;
    parameter STATE_MS_GUIDE_LOC_Y = 53; 


    // Background render
    mainscreen_background mainscreen(
        .clk(clk6p25m),
        .pixel_index(pixel_index),
        .oled_colour(oled_colour_bg_layer1)   // Output background color
    );
    
    // Title render
    homepage_title title(
        .clk(clk6p25m),               
        .pixel_index(pixel_index), 
        .sprite_x(0),                 // X coordinate for the title
        .sprite_y(4),                 // Y coordinate for the title
        .background_pixel(oled_colour_bg_layer1), 
        .oled_colour(oled_colour_bg_layer2)  // Output title color
    );

    // Selector menu render
    main_screen_selector selector_render(
        .clk(clk6p25m), 
        .pixel_index(pixel_index), 
        .sprite_x(30),     
        .sprite_y(42),     
        .background_pixel(oled_colour_bg_layer2), 
        .oled_colour(oled_colour_bg_layer3)  
    );
    
    // Selector arrow render
    main_screen_selector_arrow selector_arrow_render(
        .clk(clk6p25m),                
        .pixel_index(pixel_index),
        .sprite_x(sel_arrow_coor_x),   
        .sprite_y(sel_arrow_coor_y), 
        .background_pixel(oled_colour_bg_layer3), 
        .oled_colour(oled_colour_bg_layerFinal)
    );


    // Initialize state
    initial begin
        state_mainscreen <= STATE_MS_START;
        sel_arrow_coor_x <= STATE_MS_START_LOC_X;
        sel_arrow_coor_y <= STATE_MS_START_LOC_Y;
    end
    wire btnU_synced;
    wire btnD_synced;
    button_sync run_button_sync_U(
        .clk(clk6p25m),             
        .button_in(btnU),       // Debounced button input
        .button_sync(btnU_synced));
    button_sync run_button_sync_D(
        .clk(clk6p25m),             
        .button_in(btnD),       // Debounced button input
        .button_sync(btnD_synced));
    // Update state based on button inputs
    always @ (posedge clk6p25m) begin
        if (btnU_synced && state_mainscreen != STATE_MS_START) begin
            state_mainscreen <= STATE_MS_START;
        end
        else if (btnD_synced && state_mainscreen != STATE_MS_GUIDE) begin
            state_mainscreen <= STATE_MS_GUIDE;
        end
    end
    
    // Update arrow coordinates based on the state
    always @ (*) begin
        case(state_mainscreen)
            STATE_MS_START: begin
                sel_arrow_coor_x <= STATE_MS_START_LOC_X;
                sel_arrow_coor_y <= STATE_MS_START_LOC_Y;         
            end
            STATE_MS_GUIDE: begin
                sel_arrow_coor_x <= STATE_MS_GUIDE_LOC_X;
                sel_arrow_coor_y <= STATE_MS_GUIDE_LOC_Y;               
            end            
        endcase
    end
    always @ (*)begin
        oled_colour <= oled_colour_bg_layerFinal;
    end
endmodule