`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.10.2024 14:12:52
// Design Name: 
// Module Name: scrolling_text
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


module modifier_start(
    input clk,
    input turned_on,
    input btnC,
    output reg [0:6] seg = 7'b1111111,
    output reg [3:0] an = 4'b1111,
    output reg start = 1'b0
    );
    
    wire time_200hz, time_4hz;
    reg [3:0] scroll = 5'b00000;
    reg [1:0] count = 2'b00;
    reg [6:0] FIRST = 7'b1111111, SECOND = 7'b1111111, THIRD = 7'b1111111, FOURTH = 7'b1111111;
    
    parameter BLANK = 7'b1111111;
    parameter LETTERc = 7'b0110001,LETTERh = 7'b1001000,LETTERo = 7'b0000001,LETTERs = 7'b0100100,LETTERe = 7'b0110000;
    parameter LETTERm = 7'b0101011,LETTERd = 7'b1000010,LETTERf = 7'b0111000,LETTERr = 7'b1111010;
    parameter LETTERa = 7'b0001000, LETTERp = 7'b0011000, LETTERw = 7'b1010101;
    parameter LETTERn = 7'b1101010;
    parameter LETTERi = 7'b1001111, DIGIT2 = 7'b0010010;
    
    flexi_clock clk_200hz (.clk(clk),.m_const(249_999),.my_clk(time_200hz));
    flexi_clock clk_4hz (.clk(clk),.m_const(12_499_999),.my_clk(time_4hz));
    
    always @(posedge time_4hz or posedge turned_on) begin
        if (~turned_on) begin
            scroll <= 5'b00000;
        end
        else if (scroll == 5'b10000) begin
            scroll <= 5'b00000;
        end
        else begin
            scroll <= scroll + 5'b00001;
        end
    end
    
    always @(posedge time_4hz) begin
        case (scroll)
            0: begin
                FIRST <= LETTERc;
                SECOND <= LETTERh;
                THIRD <= LETTERo;
                FOURTH <= LETTERo;
            end
            1: begin
                FIRST <= LETTERh;
                SECOND <= LETTERo;
                THIRD <= LETTERo;
                FOURTH <= LETTERs;
            end
            2: begin
                FIRST <= LETTERo;
                SECOND <= LETTERo;
                THIRD <= LETTERs;
                FOURTH <= LETTERe;
            end
            3: begin
                FIRST <= LETTERo;
                SECOND <= LETTERs;
                THIRD <= LETTERe;
                FOURTH <= BLANK;
            end
            4: begin
                FIRST <= LETTERs;
                SECOND <= LETTERe;
                THIRD <= BLANK;
                FOURTH <= LETTERm;
            end
            5: begin
                FIRST <= LETTERe;
                SECOND <= BLANK;
                THIRD <= LETTERm;
                FOURTH <= LETTERo;
            end
            6: begin
                FIRST <= BLANK;
                SECOND <= LETTERm;
                THIRD <= LETTERo;
                FOURTH <= LETTERd;
            end
            7: begin
                FIRST <= LETTERm;
                SECOND <= LETTERo;
                THIRD <= LETTERd;
                FOURTH <= LETTERi;
            end
            8: begin
                FIRST <= LETTERo;
                SECOND <= LETTERd;
                THIRD <= LETTERi;
                FOURTH <= LETTERf;
            end
            9: begin
                FIRST <= LETTERd;
                SECOND <= LETTERi;
                THIRD <= LETTERf;
                FOURTH <= LETTERi;
            end
            10: begin
                FIRST <= LETTERi;
                SECOND <= LETTERf;
                THIRD <= LETTERi;
                FOURTH <= LETTERe;
            end
            11: begin
                FIRST <= LETTERf;
                SECOND <= LETTERi;
                THIRD <= LETTERe;
                FOURTH <= LETTERr;
            end
            11: begin
                FIRST <= LETTERi;
                SECOND <= LETTERe;
                THIRD <= LETTERr;
                FOURTH <= LETTERs;
            end
            12: begin
                FIRST <= LETTERe;
                SECOND <= LETTERr;
                THIRD <= LETTERs;
                FOURTH <= BLANK;
            end
            13: begin
                FIRST <= LETTERr;
                SECOND <= LETTERs;
                THIRD <= BLANK;
                FOURTH <= BLANK;
            end
            14: begin
                FIRST <= LETTERs;
                SECOND <= BLANK;
                THIRD <= BLANK;
                FOURTH <= LETTERc;
            end
            15: begin
                FIRST <= BLANK;
                SECOND <= BLANK;
                THIRD <= LETTERc;
                FOURTH <= LETTERh;
            end
            16: begin
                FIRST <= BLANK;
                SECOND <= LETTERc;
                THIRD <= LETTERh;
                FOURTH <= LETTERo;
            end
        endcase
    end
    
    always @(posedge time_200hz or posedge turned_on) begin
        if (~turned_on) begin
            count <= 2'b0;
        end
        else begin
            count <= count + 2'b1;
        end
        
        case (count)
            2'b00: begin
                seg <= (~turned_on) ? BLANK : FIRST;
                an <= 4'b0111;
            end
            2'b01: begin
                seg <= SECOND;
                an <= 4'b1011;
            end
            2'b10: begin
                seg <= THIRD;
                an <= 4'b1101;
            end
            2'b11: begin
                seg <= FOURTH;
                an <= 4'b1110;
            end
        endcase
    end
    
    always @(posedge clk) begin
        if (turned_on) begin
            if (btnC) begin
                start <= 1'b1;
            end
        end
        else begin
            start <= 1'b0;
        end
    end
    
endmodule
