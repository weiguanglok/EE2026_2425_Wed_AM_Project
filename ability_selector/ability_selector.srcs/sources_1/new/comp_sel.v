`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2024 20:04:24
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
    input ai_turned_on,     // Check if vs computer
    output success    // Output: 1 for success, 0 for failure
);

    reg [15:0] ai_prob = 16'd22937; // 35% chance of pressing
    
    wire time_20hz;
    
    binomial_fn ai_sel (.clk(time_20hz),.turned_on(turned_on),.ai_turned_on(ai_turned_on),.p(ai_prob),.success(success));
    
    flexi_clock clk_20hz (.clk(clk),.m_const(1_999_999),.my_clk(time_20hz));
    
endmodule
