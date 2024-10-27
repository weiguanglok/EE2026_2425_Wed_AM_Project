`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.10.2024 19:54:54
// Design Name: 
// Module Name: counter
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


module counter(
    input clk,
    input TRIGGER,
    input [31:0] TIMER,
    output reg [31:0] COUNTER = 32'd0
);

    always @(posedge clk or posedge TRIGGER) begin
        if (~TRIGGER) begin
            COUNTER <= 32'd0;
        end
        else begin
            if (COUNTER < TIMER) begin
                COUNTER <= COUNTER + 1;
            end
        end
    end

endmodule
