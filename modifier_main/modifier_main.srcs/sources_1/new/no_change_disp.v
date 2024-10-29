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


module no_change_disp(
    input clk,
    input turned_on,
    output reg [0:6] seg = 7'b1111111,
    output reg [3:0] an = 4'b1111
    );
    
    wire time_200hz, time_3p75hz;
    reg [3:0] scroll = 4'b0000;
    reg [1:0] count = 2'b00;
    reg [6:0] FIRST = 7'b1111111, SECOND = 7'b1111111, THIRD = 7'b1111111, FOURTH = 7'b1111111;
    
    parameter BLANK = 7'b1111111;
    parameter LETTERc = 7'b0110001,LETTERh = 7'b1001000,LETTERo = 7'b0000001,LETTERs = 7'b0100100,LETTERe = 7'b0110000;
    parameter LETTERm = 7'b0101011,LETTERd = 7'b1000010,LETTERf = 7'b0111000,LETTERr = 7'b1111010;
    parameter LETTERa = 7'b0001000, LETTERp = 7'b0011000, LETTERw = 7'b1010101;
    parameter LETTERn = 7'b1101010, LETTERb = 7'b1100000, LETTERu = 7'b1100011;
    parameter LETTERg = 7'b0100001;
    parameter LETTERi = 7'b1110001, DIGIT2 = 7'b0010010;
    
    flexi_clock clk_200hz (.clk(clk),.m_const(249_999),.my_clk(time_200hz));
    flexi_clock clk_3p75hz (.clk(clk),.m_const(13_333_332),.my_clk(time_3p75hz));
    
    always @(posedge time_3p75hz or posedge turned_on) begin
        if (~turned_on) begin
            scroll <= 4'b0000;
        end
        else if (scroll == 4'b1010) begin
            scroll <= 4'b0000;
        end
        else begin
            scroll <= scroll + 4'b0001;
        end
    end
    
    always @(posedge time_3p75hz) begin
        case (scroll)
            0: begin
                FIRST <= LETTERn;
                SECOND <= LETTERo;
                THIRD <= BLANK;
                FOURTH <= LETTERc;
            end
            1: begin
                FIRST <= LETTERo;
                SECOND <= BLANK;
                THIRD <= LETTERc;
                FOURTH <= LETTERh;
            end
            2: begin
                FIRST <= BLANK;
                SECOND <= LETTERc;
                THIRD <= LETTERh;
                FOURTH <= LETTERa;
            end
            3: begin
                FIRST <= LETTERc;
                SECOND <= LETTERh;
                THIRD <= LETTERa;
                FOURTH <= LETTERn;
            end
            4: begin
                FIRST <= LETTERh;
                SECOND <= LETTERa;
                THIRD <= LETTERn;
                FOURTH <= LETTERg;
            end
            5: begin
                FIRST <= LETTERa;
                SECOND <= LETTERn;
                THIRD <= LETTERg;
                FOURTH <= LETTERe;
            end
            6: begin
                FIRST <= LETTERn;
                SECOND <= LETTERg;
                THIRD <= LETTERe;
                FOURTH <= BLANK;
            end
            7: begin
                FIRST <= LETTERg;
                SECOND <= LETTERe;
                THIRD <= BLANK;
                FOURTH <= BLANK;
            end
            8: begin
                FIRST <= LETTERe;
                SECOND <= BLANK;
                THIRD <= BLANK;
                FOURTH <= LETTERn;
            end
            9: begin
                FIRST <= BLANK;
                SECOND <= BLANK;
                THIRD <= LETTERn;
                FOURTH <= LETTERo;
            end
            10: begin
                FIRST <= BLANK;
                SECOND <= LETTERn;
                THIRD <= LETTERo;
                FOURTH <= BLANK;
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
    
endmodule
