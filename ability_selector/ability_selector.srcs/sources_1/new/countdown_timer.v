`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2024 10:55:10
// Design Name: 
// Module Name: countdown_timer_flexi
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


module countdown_timer_flexi(
    input clk,
    input trigger,
    input btnC,
    output reg done = 1'b0,
    output reg [0:6] seg = 7'b1111111,
    output reg [3:0] an = 4'b1111,
    output reg dp = 1'b1
    );
    
    wire time_1hz,time_200hz;
    
    reg [3:0] state;
    reg pressed = 1'b0;
    reg [1:0] count;
    reg [6:0] FIRST = 7'b1111111, SECOND = 7'b1111111, THIRD = 7'b1111111, FOURTH = 7'b1111111;
    
    parameter DIGIT1 = 7'b1001111, DIGIT2 = 7'b0010010, DIGIT3 = 7'b0000110;
    parameter DIGIT4 = 7'b1001100, DIGIT5 = 7'b0100100, DIGIT6 = 7'b0100000;
    parameter DIGIT7 = 7'b0001111,DIGIT8 = 7'b0000000, DIGIT9 = 7'b0001100;
    parameter DIGIT0 = 7'b0000001, BLANK = 7'b1111111;
   
    
    always @(posedge clk) begin
        if (~trigger) begin
            pressed <= 1'b0;
        end
        else if (btnC) begin
            pressed <= 1'b1;
        end
    end
    
    
    flexi_clock clk_1hz (.clk(clk),.m_const(49_999_999),.my_clk(time_1hz));
    flexi_clock clk_200hz (.clk(clk),.m_const(249_999),.my_clk(time_200hz));
    
    always @(posedge time_1hz) begin
        if (~trigger) begin
            state <= 32'd10;
            done <= 1'b0;
        end
        else if (state == 32'd0 | pressed) begin
            done <= 1'b1;
            state <= state;
        end
        else begin
            if (state > 32'd0) begin
                state <= state - 1;
            end
        end
    end
    
    always @(posedge time_200hz or posedge trigger) begin
        if (~trigger) begin
            count <= 2'b0;
            dp <= 1'b1;
        end
        else begin
            count <= count + 2'b1;
        end
        
        case (count)
            2'b00: begin
                seg <= FIRST;
                an <= 4'b0111;
                dp <= 1'b1;
            end
            2'b01: begin
                seg <= SECOND;
                an <= 4'b1011;
                dp <= 1'b1; //to change if implementing decimal places
            end
            2'b10: begin
                seg <= THIRD;
                an <= 4'b1101;
                dp <= 1'b1;
            end
            2'b11: begin
                seg <= FOURTH;
                an <= 4'b1110;
                dp <= 1'b1;
            end
        endcase
    end
    
    always @(posedge clk) begin
        case (state)
            10: begin
                FIRST <= (~trigger) ? BLANK : DIGIT1;
                SECOND <= DIGIT0;
            end
            9: begin
                FIRST <= DIGIT0;
                SECOND <= DIGIT9;
            end
            8: begin
                FIRST <= DIGIT0;
                SECOND <= DIGIT8;
            end
            7: begin
                FIRST <= DIGIT0;
                SECOND <= DIGIT7;
            end
            6: begin
                FIRST <= DIGIT0;
                SECOND <= DIGIT6;
            end
            5: begin
                FIRST <= DIGIT0;
                SECOND <= DIGIT5;
            end
            4: begin
                FIRST <= DIGIT0;
                SECOND <= DIGIT4;
            end
            3: begin
                FIRST <= DIGIT0;
                SECOND <= DIGIT3;
            end
            2: begin
                FIRST <= DIGIT0;
                SECOND <= DIGIT2;
            end
            1: begin
                FIRST <= DIGIT0;
                SECOND <= DIGIT1;
            end
            0: begin
                FIRST <= DIGIT0;
                SECOND <= DIGIT0;
            end
        endcase
    end
    
endmodule
