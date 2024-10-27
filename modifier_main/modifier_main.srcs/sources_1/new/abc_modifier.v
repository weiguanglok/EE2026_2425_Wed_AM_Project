`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2024 21:46:22
// Design Name: 
// Module Name: abc_modifier
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


module abc_modifier(
    input clk,
    input ai_sel,
    input turned_on, 
    input start,
    input [15:0] led,
    output reg [0:6] seg = 7'b1111111,
    output reg [3:0] an = 4'b1111,
    output reg [1:0] modifier_sel = 2'b00
    );
    
    parameter ZERO = 0, ONE = 1, TWO = 2;
    parameter DIGIT1 = 7'b1001111, DIGIT2 = 7'b0010010, DIGIT3 = 7'b0000110;
    parameter FIRST = 4'b0111, SECOND = 4'b1011, THIRD = 4'b1101, FOURTH = 4'b1110;
    
    reg [31:0] state = ZERO;
    
    wire TIME;
    clk_mux mux (.clk(clk),.led(led),.TIME(TIME));
    
    wire TIMER;
    timer_mux time_mux (.clk(clk),.led(led),.modifier_sel(modifier_sel),.TIMER(TIMER));
    
    always @(posedge TIME) begin
        if (turned_on) begin
            if (start) begin
                case (state) 
                    ZERO: begin
                        if (ai_sel | modifier_sel | TIMER) begin
                            state <= ZERO;
                            modifier_sel <= 2'b01;
                        end
                        else begin
                            state <= ONE;
                        end
                        seg <= DIGIT1;
                        an <= FIRST;
                    end
                    ONE: begin
                        if (ai_sel | modifier_sel | TIMER) begin
                            state <= ONE;
                            modifier_sel <= 2'b10;
                        end
                        else begin
                            state <= TWO;
                        end
                        seg <= DIGIT2;
                        an <= SECOND;
                    end
                    TWO: begin
                        if (ai_sel | modifier_sel | TIMER) begin
                            state <= TWO;
                            modifier_sel <= 2'b11;
                        end
                        else begin
                            state <= ZERO;
                        end
                        seg <= DIGIT3;
                        an <= THIRD;
                    end
                endcase
            end
        end
        else begin
            state <= ZERO;
            modifier_sel <= 2'b00;
        end
    end
    
endmodule
