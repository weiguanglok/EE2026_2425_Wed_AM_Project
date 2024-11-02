`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2024 11:07:02
// Design Name: 
// Module Name: led_resolute
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


module led_resolute(
    input turned_on,
    input clk,
    input winner,
    output reg [15:0] led = 16'b0000_0001_1000_0000
    );
    
    always @(posedge clk) begin
        if (turned_on) begin
            if (winner) begin
                led = led << 1;
            end
            else begin
                led = led >> 1;
            end
        end
    end
    
endmodule
