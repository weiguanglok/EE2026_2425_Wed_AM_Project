`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////

module Top_Home_Screen(
    input clk,
    input [12:0]pixel_index,
    input [3:0]STATE,
    input btnR, btnL, btnC, btnD, btnU,   // Buttons for navigation and selection 
    output reg[15:0]oled_colour, 
    output reg is_start 
);
    
    // States for top-level state machine
    parameter STATE_MAINSCREEN = 2'b00;
    parameter STATE_STARTPAGE = 2'b01;
    parameter STATE_GUIDEPAGE = 2'b10;
    parameter STATE_DEFAULT = 2'b11;
    parameter STATE_END = 9;
    
    reg [1:0] state;  // Register to store the current state
    wire clk6p25m;
    wire [15:0] oled_colour_main;
    wire [15:0] oled_colour_default;
    wire [15:0] oled_colour_guide;
    
    reg active_guidepage;
    reg active_mainscreenpage;
    
    // Clock instance for 6.25 MHz
    flexi_clk clk6p25m_instantiate(
        .clk(clk),
        .m_const(32'd7),
        .my_clk(clk6p25m)
    );
    
    // Instantiate the mainscreen_page_render module
    mainscreen_page_render mainscreen(
        .clk6p25m(clk6p25m),
        .btnU(btnU),
        .btnD(btnD),
        .pixel_index(pixel_index),
        .oled_colour(oled_colour_main)
    );
    
    guide_page_render guidepage(
        .clk6p25m(clk6p25m),
        .btnR(btnR),
        .btnL(btnL),
        .pixel_index(pixel_index),
        .oled_colour(oled_colour_guide)
    );
    
    blue_screen tmp_startpage(
        .pixel_index(pixel_index),   // Pixel index for 96x64 resolution
        .oled_colour(oled_colour_default)
    );

    initial begin
        state = STATE_MAINSCREEN;
    end
    always @ (posedge clk) begin
        if (STATE ==STATE_END) is_start <= 0; 
        if(btnC)begin
            case (state)
                STATE_MAINSCREEN: begin
                    if (mainscreen.state_mainscreen == mainscreen.STATE_MS_START) begin
                        state <= STATE_STARTPAGE;  // Transition to start page when START is selected
                        is_start <= 1;
                    end
                    else if (mainscreen.state_mainscreen == mainscreen.STATE_MS_GUIDE)begin
                        state <= STATE_GUIDEPAGE;
                    end
                end
                STATE_GUIDEPAGE: begin
                    state <= STATE_MAINSCREEN;
                end
                default: begin                    
                    state <= STATE_DEFAULT;
                end
            endcase
        end
    end

    // Set the OLED colour based on the current state
    always @ (*) begin
        case (state)
            STATE_MAINSCREEN: oled_colour <= oled_colour_main;
            STATE_STARTPAGE: oled_colour <= oled_colour_default;
            STATE_GUIDEPAGE: oled_colour <= oled_colour_guide;
            STATE_DEFAULT: oled_colour <= oled_colour_default;
        endcase
    end


endmodule
