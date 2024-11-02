`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2024 12:16:17
// Design Name: 
// Module Name: parry
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


module ddr_parry(
    input basys_clock,         
    input reset,                       
    input btnL, btnD, btnU, btnR,
    input [3:0] lfsr_input,
    input [12:0] pixel_index,  
    output reg [15:0] led_colour,
    output reg [1:0] parry_status = 2'b0,
    output reg [9:0]led,
    output reg [0:6]seg = 7'b1111111,
    output reg [3:0]an = 4'b1111
);

    // Convert pixel index to (x, y) coordinates
    wire [6:0] x, y;
    reg [6:0] arrow_y = 51; 
    reg [2:0] active_arrow; 
    reg [3:0] parry_count = 0;
    reg [3:0] arrow_count = 0;
    reg miss = 1; 
    reg checked = 0;
    reg [31:0] time_count = 0;
    wire three_secs;
    
    
    wire p_btnL, p_btnR, pbtnU, pbtnD;
    wire [15:0] parry_bg;
    wire [15:0] main_bg;
    wire [15:0] parry_colour;
    wire [15:0] miss_colour;

    // Parry zone fixed y position 
    parameter PARRY_ZONE_Y = 7'd20;
    
    // fixed x positions for each arrow
    parameter LEFT_X = 7'd23;
    parameter DOWN_X = 7'd58;
    parameter UP_X = 7'd39;
    parameter RIGHT_X = 7'd75;

    // Colors
    parameter ARROW_COLOR = 16'b1111100000000000; // RED
    
    parameter TIME_BUTTON = 32'd249_999;
      
    parameter DIGIT1 = 7'b1001111, DIGIT2 = 7'b0010010, DIGIT3 = 7'b0000110;
    parameter DIGIT4 = 7'b1001100, DIGIT5 = 7'b0100100, DIGIT6 = 7'b0100000;
    parameter DIGIT7 = 7'b0001111,DIGIT8 = 7'b0000000, DIGIT9 = 7'b0001100;
    parameter DIGIT0 = 7'b0000001, BLANK = 7'b1111111;

    // Clock divider for arrow speed
    wire clk_arrow;
    wire clk_led;
    flexi_clk arrow_clock(.clk(basys_clock), .m_const(32'd999999), .my_clk(clk_arrow)); //50hz
    flexi_clk led_clock(.clk(basys_clock), .m_const(32'd7), .my_clk(clk_led));
    delay_counter run_delay_counter(.clk(clk_arrow), .reset(reset), .done(three_secs));

    // Convert pixel index to (x, y) coordinates
    ind_to_coor xy_index(.pixel_index(pixel_index), .x(x), .y(y));
    //pdebounce btnL_debounced(.clk(clk_arrow), .button_in(btnL),.button_out(p_btnL));
    //pdebounce btnD_debounced(.clk(clk_arrow), .button_in(btnD),.button_out(p_btnD));
    //pdebounce btnU_debounced(.clk(clk_arrow), .button_in(btnU),.button_out(p_btnU));
    //pdebounce btnR_debounced(.clk(clk_arrow), .button_in(btnR),.button_out(p_btnR));

    // Background instantiations
    battlescreen_background mainscreen_background(
        .clk(basys_clock),
        .flip(0),
        .pixel_index(pixel_index),
        .oled_colour(main_bg)
    );
    
    parry_background parry_background_inst (
        .clk(basys_clock),
        .pixel_index(pixel_index),
        .sprite_x(7'd12), 
        .sprite_y(7'd3),
        .flip(0),
        .oled_colour(parry_bg),
        .background_pixel(main_bg));
        
    parry_colour parry_colour_inst (
        .clk(basys_clock),
        .pixel_index(pixel_index),
        .sprite_x(7'd22), 
        .sprite_y(7'd5),
        .flip(0),
        .oled_colour(parry_colour),
        .background_pixel(parry_bg));
        
    miss_colour miss_colour_inst (
        .clk(basys_clock),
        .pixel_index(pixel_index),
        .sprite_x(7'd27), 
        .sprite_y(7'd5),
        .flip(0),
        .oled_colour(miss_colour),
        .background_pixel(parry_bg));

    // LFSR for Pseudo-Random Arrow Selection
    reg [3:0] lfsr = 4'b0001; 
    always @(posedge clk_arrow) begin
        if (reset) begin
            lfsr <= lfsr_input; 
        end else begin
            lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};
        end
    end

    // Arrow Movement and Random Arrow Selection
    always @(posedge clk_arrow) begin
        if (reset) begin
            arrow_y <= 6'd51;
            arrow_count <= 0;
        end else if (!reset && arrow_count < 11 && three_secs) begin
            if (arrow_y > 6'd11) begin
                arrow_y <= arrow_y - 1;
            end else begin
                arrow_y <= 51;
                active_arrow <= {1'b0,lfsr[2:1]};
                arrow_count <= arrow_count + 1;
            end
        end
            else if (!three_secs) begin
                active_arrow <= 3'b100;
            end
    end

    // oled display rendering
    always @(posedge clk_led) begin
        led_colour <= parry_bg; // default parry screen background color
        if (reset) begin
            miss <= 1;
            checked <= 0;
            parry_status <= 2'b0;
            parry_count <= 4'b0;   
            time_count <= 0;            
        end
        
        if (arrow_y == 12) begin
            if (miss == 0 && checked == 0) begin                    
                parry_count <= parry_count + 1;
                checked <= 1;
            end
        end
        
        if (arrow_y == 11) begin
            miss <= 1;
            checked <= 0;
            time_count <= 0;
        
        end

        // Set led colour for successful or missed parries
        if ((btnL && active_arrow == 2'b00 || btnU && active_arrow == 2'b01 ||
             btnD && active_arrow == 2'b10 || btnR && active_arrow == 2'b11) &&
             time_count <= TIME_BUTTON) begin
            time_count<= time_count +1;
            
            if((arrow_y >= PARRY_ZONE_Y && arrow_y <= PARRY_ZONE_Y + 10 || miss == 0)) begin
                led_colour <= parry_colour;
                miss <= 0;
            end
            else begin
                led_colour <= miss_colour;
                miss <= 1;
            end
        end 
        else if (arrow_y < PARRY_ZONE_Y && arrow_y > 11 && miss == 1) begin
            led_colour <= miss_colour;
        end 
        else
            led_colour <= parry_bg;

        // Display active arrow based on active_arrow value if game is still active
        if (arrow_count < 10) begin
            case (active_arrow)
                3'b000: if ((x == LEFT_X  && y >= arrow_y - 4 && y <= arrow_y + 4) ||
                           (x == LEFT_X - 1  && y >= arrow_y - 4 && y <= arrow_y + 4) ||
                           (x == LEFT_X - 2  && y >= arrow_y - 3 && y <= arrow_y + 3) ||
                           (x == LEFT_X - 3 && y >= arrow_y - 2 && y <= arrow_y + 2) ||
                           (x == LEFT_X - 4 && y >= arrow_y - 1 && y <= arrow_y + 1) ||
                           (x == LEFT_X - 5 && y == arrow_y)) led_colour <= ARROW_COLOR;
                3'b001: if ((y == arrow_y - 3 && x == UP_X) ||
                           (y == arrow_y - 2 && x >= UP_X - 1 && x <= UP_X + 1) ||
                           (y == arrow_y - 1 && x >= UP_X - 2 && x <= UP_X + 2) ||
                           (y == arrow_y && x >= UP_X - 3 && x <= UP_X + 3) ||
                           (y == arrow_y + 1 && x >= UP_X - 4 && x <= UP_X + 4) ||
                           (y == arrow_y + 2 && x >= UP_X - 4 && x <= UP_X + 4)) led_colour <= ARROW_COLOR;
                3'b010: if ((y == arrow_y - 3 && x >= DOWN_X - 4 && x <= DOWN_X + 4) ||
                           (y == arrow_y - 2 && x >= DOWN_X - 4 && x <= DOWN_X + 4) ||
                           (y == arrow_y - 1 && x >= DOWN_X - 3 && x <= DOWN_X + 3) ||
                           (y == arrow_y && x >= DOWN_X - 2 && x <= DOWN_X + 2) ||
                           (y == arrow_y + 1 && x >= DOWN_X - 1 && x <= DOWN_X + 1) ||
                           (y == arrow_y + 2 && x == DOWN_X)) led_colour <= ARROW_COLOR;
                3'b011: if ((x == RIGHT_X  && y >= arrow_y - 4 && y <= arrow_y + 4) ||
                           (x == RIGHT_X + 1 && y >= arrow_y - 4 && y <= arrow_y + 4) ||
                           (x == RIGHT_X + 2 && y >= arrow_y - 3 && y <= arrow_y + 3) ||
                           (x == RIGHT_X + 3 && y >= arrow_y - 2 && y <= arrow_y + 2) ||
                           (x == RIGHT_X + 4 && y >= arrow_y - 1 && y <= arrow_y + 1) ||
                           (x == RIGHT_X + 5 && y == arrow_y)) led_colour <= ARROW_COLOR;
                default: led_colour <= parry_bg ;
            endcase
            case (parry_count)
                4'd1 : begin
                    seg <= DIGIT1;
                    an <= 4'b0111;
                end
                4'd2 : begin
                    seg <= DIGIT2;
                    an <= 4'b0111;
                end
                4'd3 : begin
                    seg <= DIGIT3;
                    an <= 4'b0111;
                end
                4'd4 : begin
                    seg <= DIGIT4;
                    an <= 4'b0111;
                end
                4'd5 : begin
                    seg <= DIGIT5;
                    an <= 4'b0111;
                end
                4'd6 : begin
                    seg <= DIGIT6;
                    an <= 4'b0111;
                end
                4'd7 : begin
                    seg <= DIGIT7;
                    an <= 4'b0111;
                end
                4'd8 : begin
                    seg <= DIGIT8;
                    an <= 4'b0111;
                end
                4'd9 : begin
                    seg <= DIGIT9;
                    an <= 4'b0111;
                end
                default : begin
                    seg <= DIGIT0;
                    an <= 4'b0111;
                end
            endcase
        end
        if (arrow_count == 10) begin
            if (parry_count >= 8)
                parry_status <= 2'b01; 
            else
                parry_status <= 2'b10;
        end
    end
endmodule
