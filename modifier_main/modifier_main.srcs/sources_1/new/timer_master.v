`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.10.2024 19:56:46
// Design Name: 
// Module Name: timer_master
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


module timer_master(
    input clk,
    input [31:0] TIMER,
    input TRIGGER, //(TIMING IN SECONDS) DIVIDED BY 10 ns - 1
    output reg DONE
    );
    
    wire [31:0] COUNTER;
    
    counter counter_timer (.clk(clk),.TRIGGER(TRIGGER),.TIMER(TIMER),.COUNTER(COUNTER));
    
    always @(posedge clk) begin
        case (COUNTER)
            TIMER: begin
                DONE <= 1'b1;
            end
            default: begin
                DONE <= 1'b0;
            end
        endcase
    end
    
endmodule
