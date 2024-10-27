`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.10.2024 22:19:24
// Design Name: 
// Module Name: debounce
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



module debounce (input wire clk, wire button_in, output reg button_out);

    parameter DEBOUNCE_TIME = 20_000_000; 

    reg [24:0] counter;         
    reg button_state;           
    reg button_prev;           
    reg button_press;    

    initial begin
        button_state = 1'b0;
        button_prev = 1'b0;
        button_press = 1'b0;
        counter = 0;
        button_out = 1'b0;
    end

    always @(posedge clk) begin
        button_prev <= button_in; 
        
        if (button_in && !button_prev && !button_press) begin
            button_press <= 1'b1;
            button_out <= 1'b1; 
        end 
        else begin
            button_out <= 1'b0;
        end

        if (button_press) begin
            if (counter < DEBOUNCE_TIME - 1) begin
                counter <= counter + 1; 
            end 
            else begin
                counter <= 0;           
                button_press <= 1'b0;    
            end
        end
    end
endmodule
