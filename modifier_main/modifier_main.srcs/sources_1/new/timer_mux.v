`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2024 22:44:50
// Design Name: 
// Module Name: timer_mux
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


module timer_mux(
    input clk,
    input [15:0] led,
    input [1:0] modifier_sel,
    output reg TIMER = 1'b0
    );
    
    parameter TEN_SEC = 1_000_000_000;
    parameter FIVE_SEC = 500_000_000;
    parameter TWO_SEC = 200_000_000;
    
    wire ten_sec_done,five_sec_done,two_sec_done;  
    
    reg trigger_10s = 1'b0,trigger_5s = 1'b0,trigger_2s = 1'b0;
    
    timer_master TENS(.clk(clk),.TIMER(TEN_SEC),.TRIGGER(trigger_10s),.DONE(ten_sec_done));
    timer_master FIVES(.clk(clk),.TIMER(FIVE_SEC),.TRIGGER(trigger_5s),.DONE(five_sec_done));
    timer_master TWOS(.clk(clk),.TIMER(TWO_SEC),.TRIGGER(trigger_2s),.DONE(two_sec_done));
    
    
    always @(posedge clk) begin
        if (modifier_sel) begin
            if (led[15]|led[14]|led[1]|led[0]) begin
                trigger_10s <= 1'b0;
                trigger_5s <= 1'b0;
                trigger_2s <= 1'b1;
                TIMER = two_sec_done;
            end
            else if (led[13]|led[12]|led[11]|led[10]|led[6]|led[5]|led[4]|led[3]) begin
                trigger_10s <= 1'b0;
                trigger_5s <= 1'b1;
                trigger_2s <= 1'b0;
                TIMER = five_sec_done;
            end
            else begin
                trigger_10s <= 1'b1;
                trigger_5s <= 1'b0;
                trigger_2s <= 1'b0;
                TIMER = ten_sec_done;
            end
        end
        else begin
                trigger_10s <= 1'b0;
                trigger_5s <= 1'b0;
                trigger_2s <= 1'b0;
                TIMER = 1'b0;
        end
    end
    
endmodule
