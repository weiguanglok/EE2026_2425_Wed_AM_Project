`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2024 11:42:25
// Design Name: 
// Module Name: end_screen
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


module victory_screen_main(
    input clk,
    input turned_on,
    input [15:0] led,
    output [0:6] seg,
    output [3:0] an,
    output reg dp = 1'b1
    );
    
    wire [0:6] seg_bot, seg_player;
    wire [3:0] an_bot, an_player;
    
    player_disp player (.clk(clk),.turned_on(turned_on),.seg(seg_player),.an(an_player));
    bot_disp bot (.clk(clk),.turned_on(turned_on),.seg(seg_bot),.an(an_bot));
    
    seven_seg_mux(.clk(clk),.led(led),.turned_on(turned_on),.seg_player(seg_player),.seg_bot(seg_bot),.an_player(an_player),.an_bot(an_bot),.seg(seg),.an(an));

    
endmodule

module player_disp(
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
    parameter LETTERg = 7'b0100001,LETTERy = 7'b1000100,LETTERi = 7'b1001111;
    parameter LETTERl = 7'b1110001, DIGIT2 = 7'b0010010;
    
    flexi_clk clk_200hz (.clk(clk),.m_const(249_999),.my_clk(time_200hz));
    flexi_clk clk_3p75hz (.clk(clk),.m_const(13_333_332),.my_clk(time_3p75hz));
    
    always @(posedge time_3p75hz or posedge turned_on) begin
        if (~turned_on) begin
            scroll <= 4'b0000;
        end
        else if (scroll == 4'b1100) begin
            scroll <= 4'b0000;
        end
        else begin
            scroll <= scroll + 4'b0001;
        end
    end
    
    always @(posedge time_3p75hz) begin
        case (scroll)
            0: begin
                FIRST <= LETTERp;
                SECOND <= LETTERl;
                THIRD <= LETTERa;
                FOURTH <= LETTERy;
            end
            1: begin
                FIRST <= LETTERl;
                SECOND <= LETTERa;
                THIRD <= LETTERy;
                FOURTH <= LETTERe;
            end
            2: begin
                FIRST <= LETTERa;
                SECOND <= LETTERy;
                THIRD <= LETTERe;
                FOURTH <= LETTERr;
            end
            3: begin
                FIRST <= LETTERy;
                SECOND <= LETTERe;
                THIRD <= LETTERr;
                FOURTH <= BLANK;
            end
            4: begin
                FIRST <= LETTERe;
                SECOND <= LETTERr;
                THIRD <= BLANK;
                FOURTH <= LETTERw;
            end
            5: begin
                FIRST <= LETTERr;
                SECOND <= BLANK;
                THIRD <= LETTERw;
                FOURTH <= LETTERi;
            end
            6: begin
                FIRST <= BLANK;
                SECOND <= LETTERw;
                THIRD <= LETTERi;
                FOURTH <= LETTERn;
            end
            7: begin
                FIRST <= LETTERw;
                SECOND <= LETTERi;
                THIRD <= LETTERn;
                FOURTH <= LETTERs;
            end
            8: begin
                FIRST <= LETTERi;
                SECOND <= LETTERn;
                THIRD <= LETTERs;
                FOURTH <= BLANK;
            end
            9: begin
                FIRST <= LETTERn;
                SECOND <= LETTERs;
                THIRD <= BLANK;
                FOURTH <= BLANK;
            end
            10: begin
                FIRST <= LETTERs;
                SECOND <= BLANK;
                THIRD <= BLANK;
                FOURTH <= LETTERp;
            end
            11: begin
                FIRST <= BLANK;
                SECOND <= BLANK;
                THIRD <= LETTERp;
                FOURTH <= LETTERl;
            end
            12: begin
                FIRST <= BLANK;
                SECOND <= LETTERp;
                THIRD <= LETTERl;
                FOURTH <= LETTERa;
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

module bot_disp(
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
    parameter LETTERg = 7'b0100001,LETTERy = 7'b1000100,LETTERi = 7'b1001111;
    parameter LETTERl = 7'b1110001, LETTERt = 7'b1110000;
    
    flexi_clk clk_200hz (.clk(clk),.m_const(249_999),.my_clk(time_200hz));
    flexi_clk clk_3p75hz (.clk(clk),.m_const(13_333_332),.my_clk(time_3p75hz));
    
    always @(posedge time_3p75hz or posedge turned_on) begin
        if (~turned_on) begin
            scroll <= 4'b0000;
        end
        else if (scroll == 4'b1001) begin
            scroll <= 4'b0000;
        end
        else begin
            scroll <= scroll + 4'b0001;
        end
    end
    
    always @(posedge time_3p75hz) begin
        case (scroll)
            0: begin
                FIRST <= LETTERb;
                SECOND <= LETTERo;
                THIRD <= LETTERt;
                FOURTH <= BLANK;
            end
            1: begin
                FIRST <= LETTERo;
                SECOND <= LETTERt;
                THIRD <= BLANK;
                FOURTH <= LETTERw;
            end
            2: begin
                FIRST <= LETTERt;
                SECOND <= BLANK;
                THIRD <= LETTERw;
                FOURTH <= LETTERi;
            end
            3: begin
                FIRST <= BLANK;
                SECOND <= LETTERw;
                THIRD <= LETTERi;
                FOURTH <= LETTERn;
            end
            4: begin
                FIRST <= LETTERw;
                SECOND <= LETTERi;
                THIRD <= LETTERn;
                FOURTH <= LETTERs;
            end
            5: begin
                FIRST <= LETTERi;
                SECOND <= LETTERn;
                THIRD <= LETTERs;
                FOURTH <= BLANK;
            end
            6: begin
                FIRST <= LETTERn;
                SECOND <= LETTERs;
                THIRD <= BLANK;
                FOURTH <= BLANK;
            end
            7: begin
                FIRST <= LETTERs;
                SECOND <= BLANK;
                THIRD <= BLANK;
                FOURTH <= LETTERb;
            end
            8: begin
                FIRST <= BLANK;
                SECOND <= BLANK;
                THIRD <= LETTERb;
                FOURTH <= LETTERo;
            end
            9: begin
                FIRST <= BLANK;
                SECOND <= LETTERb;
                THIRD <= LETTERo;
                FOURTH <= LETTERt;
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

module seven_seg_mux(
    input clk,
    input [15:0] led,
    input turned_on,
    input [0:6] seg_player,seg_bot,
    input [3:0] an_player, an_bot,
    output reg [0:6] seg = 7'b1111111,
    output reg [3:0] an = 4'b1111
    );
    
    always @(posedge clk) begin
        if (~turned_on) begin
            seg <= 7'b1111111;
            an <= 4'b1111;
        end
        else begin
            if (led[15]) begin
                seg <= seg_player;
                an <= an_player;
            end
            else if (led[0]) begin
                seg <= seg_bot;
                an <= an_bot;
            end
            else begin
                seg <= 7'b1111111;
                an <= 4'b1111;
            end
        end
    end
    
endmodule

