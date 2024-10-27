`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2024 23:06:18
// Design Name: 
// Module Name: clk_mux
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


module clk_mux(
    input clk,
    input [15:0] led,
    output reg TIME = 1'b0
    );
    
    wire time_20hz,time_10hz,time_50hz;
    
    flexi_clock clk_10hz (.clk(clk),.m_const(4_999_999),.my_clk(time_10hz));
    flexi_clock clk_20hz (.clk(clk),.m_const(2_499_999),.my_clk(time_20hz));
    flexi_clock clk_50hz (.clk(clk),.m_const(999_999),.my_clk(time_50hz));
    
    always @(posedge clk) begin
        if (led[15]|led[14]|led[1]|led[0]) begin
            TIME = time_50hz;
        end
        else if (led[13]|led[12]|led[11]|led[10]|led[6]|led[5]|led[4]|led[3]) begin
            TIME = time_20hz;
        end
        else begin
            TIME = time_10hz;
        end
    end
    
endmodule
