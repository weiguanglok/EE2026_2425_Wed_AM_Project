`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2024 12:20:10
// Design Name: 
// Module Name: delay_counter
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


module delay_counter(input clk, reset, output reg done

    );
    reg [31:0] counter = 0;
    always @(posedge clk)
        if (reset)
            counter <= 0;
        else if( counter < 32'd100) begin
            counter <= counter + 1;
            done <= 0;
        end
        else begin
            done <= 1;
            counter <= 32'd200;
        end
    
endmodule
