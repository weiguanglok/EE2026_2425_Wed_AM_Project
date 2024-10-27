`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2024 21:13:52
// Design Name: 
// Module Name: main
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


module main(
    input clk,
    input turned_on,
    input btnC,
    output [0:6] seg,
    output [3:0] an,
    output reg dp = 1'b1
    );
    
    wire start;
    
//    wire btnC_STABLE;
    wire AI_SEL, AI_STABLE;
    
    wire [0:6] seg_start, seg_modif;
    wire [3:0] an_start, an_modif;
    
    wire [1:0] modifier_sel;
    
    wire two_sec_done;
    
    // to be converted as output
    wire double_damage,half_damage,double_speed,half_speed;
    
    //debugging purpose
    reg [15:0] led = 16'b0000_0001_0000_0000;
    
    modifier_start modif_start(.clk(clk),.turned_on(turned_on),.btnC(btnC),.seg(seg_start),.an(an_start),.start(start));
    abc_modifier abc_modif(.clk(clk),.ai_sel(AI_SEL),.turned_on(turned_on),.start(start),.led(led),.seg(seg_modif),.an(an_modif),.modifier_sel(modifier_sel));
    
    seven_seg_mux mux (.clk(clk),.start(start),.seg_start(seg_start),.seg_modif(seg_modif),.an_start(an_start),.an_modif(an_modif),.seg(seg),.an(an));
    
//    debounce debounce (.clk(clk),.button_in(btnC),.button_out(btnC_STABLE));
    
    comp_sel ai_sel (.clk(clk),.turned_on(turned_on),.success(AI_SEL));
    debounce debounce_ai (.clk(clk),.button_in(AI_SEL),.button_out(AI_STABLE));
    
    modifier_effects effects(.clk(clk),.modifier_sel(modifier_sel),.double_damage(double_damage),.half_damage(half_damage),.double_speed(double_speed),.half_speed(half_speed));
    
endmodule
