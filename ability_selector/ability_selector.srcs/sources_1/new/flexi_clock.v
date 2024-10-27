`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.10.2024 10:53:12
// Design Name: 
// Module Name: flexi_clock
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


module flexi_clock(
    input clk, [31:0]m_const, output reg my_clk = 0);
    reg [31:0] count = 0;
    always @ (posedge clk)  
    begin
        count <= (count == m_const)? 0 : count+1;
        my_clk <= (count == 0)? ~my_clk:my_clk;
    end
endmodule
