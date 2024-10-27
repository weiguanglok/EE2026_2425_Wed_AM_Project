`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2024 10:51:16
// Design Name: 
// Module Name: rps_select_screen
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


module ability_select_screen(
    input clk,
    input btnU,
    input btnD,
    input btnC,
    input turned_on,
    input timer_up,
    output reg [1:0] done = 2'b00,
    output reg [3:0] led = 4'b0000,
    output reg ai_turn = 1'b0
    );
    
    reg [1:0] state = 2'b00;
    parameter ZERO = 2'b00, ONE = 2'b01, TWO = 2'b10;
    wire btnU_STABLE, btnD_STABLE, btnC_STABLE;
    
    debounce btnu (.clk(clk),.button_in(btnU),.button_out(btnU_STABLE));
    debounce btnd (.clk(clk),.button_in(btnD),.button_out(btnD_STABLE));
    debounce btnc (.clk(clk),.button_in(btnC),.button_out(btnC_STABLE));
    
    always @(posedge clk) begin
        if (turned_on) begin
            case (state)
                ZERO: begin
                    led = 4'b0001;
                    if (done) begin
                        state <= state;
                    end
                    else if (btnC_STABLE | timer_up) begin
                        state <= ZERO;
                        done <= ZERO;
                        ai_turn <= 1'b1;
                    end
                    else if (btnU_STABLE) begin
                        state <= TWO;
                    end
                    else if (btnD_STABLE) begin
                        state <= ONE;
                    end
                    else begin
                        state <= ZERO;
                    end
                end
                ONE: begin
                    led = 4'b0010;
                    if (done) begin
                        state <= state;
                    end
                    else if (btnC_STABLE | timer_up) begin
                        state <= ONE;
                        done <= ONE;
                        ai_turn <= 1'b1;
                    end
                    else if (btnU_STABLE) begin
                        state <= ZERO;
                    end
                    else if (btnD_STABLE) begin
                        state <= TWO;
                    end
                    else begin
                        state <= ONE;
                    end
                end
                TWO: begin
                    led = 4'b0100;
                    if (done) begin
                        state <= state;
                    end
                    else if (btnC_STABLE | timer_up) begin
                        state <= TWO;
                        done <= TWO;
                        ai_turn <= 1'b1;
                    end
                    else if (btnU_STABLE) begin
                        state <= ONE;
                    end
                    else if (btnD_STABLE) begin
                        state <= ZERO;
                    end
                    else begin
                        state <= TWO;
                    end
                end
            endcase
        end
        else begin
            state <= ZERO;
            led = 4'b0000;
            done <= 2'b00;
            ai_turn <= 1'b0;
        end
    end
    
endmodule
