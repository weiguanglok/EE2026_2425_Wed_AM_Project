`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2024 22:01:28
// Design Name: 
// Module Name: comp_sel
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


module comp_sel(
    input clk,            // Clock signal
    input turned_on,          // Reset signal
    output success    // Output: 1 for success, 0 for failure
);
    reg ai_turned_on = 1'b1;
    reg [15:0] ai_prob = 16'd13107; // 20% chance of pressing
    
    wire time_10hz;
    
    binomial_fn ai_sel (.clk(time_10hz),.turned_on(turned_on),.ai_turned_on(ai_turned_on),.p(ai_prob),.success(success));
    
    flexi_clock clk_10hz (.clk(clk),.m_const(2_499_999),.my_clk(time_10hz));
    
endmodule
