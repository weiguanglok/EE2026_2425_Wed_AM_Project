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
    
    // to be converted as output
    wire double_damage,half_damage,double_speed,half_speed;
    wire [0:6] seg_double_speed,seg_half_speed,seg_no_change;
    wire [3:0] an_double_speed,an_half_speed,an_no_change;
    
    //debugging purpose
    reg [15:0] led = 16'b0000_0001_0000_0000;
    
    modifier_start modif_start(.clk(clk),.turned_on(turned_on),.btnC(btnC),.seg(seg_start),.an(an_start),.start(start));
    
    abc_modifier abc_modif(.clk(clk),.ai_sel(AI_SEL),.turned_on(turned_on),.start(start),.led(led),.seg(seg_modif),.an(an_modif),.modifier_sel(modifier_sel));
    
    // to test
    seven_seg_mux mux (.clk(clk),.start(start),.modifier_sel(modifier_sel),.seg_start(seg_start),.seg_modif(seg_modif),.seg_double_speed(seg_double_speed),.seg_half_speed(seg_half_speed)
    ,.seg_no_change(seg_no_change),.an_start(an_start),.an_modif(an_modif),.an_double_speed(an_double_speed),.an_half_speed(an_half_speed),.an_no_change(an_no_change)
    ,.seg(seg),.an(an));
    
//    debounce debounce (.clk(clk),.button_in(btnC),.button_out(btnC_STABLE));
    
    comp_sel ai_sel (.clk(clk),.turned_on(turned_on),.success(AI_SEL));
    debounce debounce_ai (.clk(clk),.button_in(AI_SEL),.button_out(AI_STABLE));
    
    modifier_effects effects(.clk(clk),.modifier_sel(modifier_sel),.double_damage(double_damage),.half_damage(half_damage),.double_speed(double_speed),.half_speed(half_speed));
    //to test
    double_speed_disp double (.clk(clk),.turned_on(turned_on),.seg(seg_double_speed),.an(an_double_speed));
    half_speed_disp half (.clk(clk),.turned_on(turned_on),.seg(seg_half_speed),.an(an_half_speed));
    no_change_disp no_change(.clk(clk),.turned_on(turned_on),.seg(seg_no_change),.an(an_no_change));
    
endmodule
