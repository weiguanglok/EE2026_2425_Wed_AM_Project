`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2024 07:20:31 PM
// Design Name: 
// Module Name: guide_page_render
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

module guide_page_render(
    input clk6p25m,
    input btnR, btnL,
    input [12:0] pixel_index, 
    output reg [15:0]oled_colour
);
    
    wire [15:0] oled_colour_bg;
    wire [15:0] oled_colour_page_one;
    wire [15:0] oled_colour_page_two;
    
    reg state_guide;
    
    parameter STATE_PAGE_ONE = 1'b0;
    parameter STATE_PAGE_TWO = 1'b1;

    
    // Background render
    mainscreen_background mainscreen(
        .clk(clk6p25m),
        .pixel_index(pixel_index),
        .oled_colour(oled_colour_bg)   // Output background color
    );
    
    // Page 1 rendering (first page content)
    guide_page_one guide_page_one_render(
        .clk(clk6p25m),                
        .pixel_index(pixel_index),
        .sprite_x(4),   
        .sprite_y(4), 
        .background_pixel(oled_colour_bg), 
        .oled_colour(oled_colour_page_one)
    );
    
    // Page 2 rendering (second page content)
    guide_page_two guide_page_two_render(
        .clk(clk6p25m),                
        .pixel_index(pixel_index),
        .sprite_x(4),   
        .sprite_y(4), 
        .background_pixel(oled_colour_bg), 
        .oled_colour(oled_colour_page_two)
    );
    
    // Initialize the state to the first page
    initial begin
        state_guide <= STATE_PAGE_ONE; 
    end
    wire btnL_synced;
    wire btnR_synced;
    button_sync run_button_sync_L(
        .clk(clk6p25m),             
        .button_in(btnL),       // Debounced button input
        .button_sync(btnL_synced));
    button_sync run_button_sync_R(
        .clk(clk6p25m),             
        .button_in(btnR),       // Debounced button input
        .button_sync(btnR_synced));
    always @ (posedge clk6p25m) begin
        if (btnL_synced && state_guide != STATE_PAGE_ONE) begin
            state_guide <= STATE_PAGE_ONE;
        end
        if (btnR_synced && state_guide != STATE_PAGE_TWO) begin
            state_guide <= STATE_PAGE_TWO;
        end
    end

    // Display the appropriate page content
    always @ (*) begin
        case (state_guide)
            STATE_PAGE_ONE: oled_colour = oled_colour_page_one;
            STATE_PAGE_TWO: oled_colour = oled_colour_page_two;
        endcase    
    end
    
endmodule
