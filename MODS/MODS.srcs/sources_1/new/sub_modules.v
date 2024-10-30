`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2024 06:38:51 PM
// Design Name: 
// Module Name: sub_modules
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

//flexible clock module for m-size clock
module flexi_clk(input clk, [31:0]m_const, output reg my_clk = 0);
    reg [31:0] count = 0;
    always @ (posedge clk)  
    begin
        count <= (count == m_const)? 0 : count+1;
        my_clk <= (count == 0)? ~my_clk:my_clk;
    end
endmodule

//convert posindex to xy coordinates

module ind_to_coor(input [12:0]pixel_index, output [6:0]x, [5:0]y);
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
endmodule

module debounce (
    input clk,            // Main system clock
    input button_in,      // Raw button signal
    output reg button_out // Cleaned button signal
);

    reg [15:0] shift_reg; // Shift register to store consecutive button samples

    always @(posedge clk) begin
        shift_reg <= {shift_reg[14:0], button_in}; // Shift in the new button state

        // If all bits in the shift register are 1s or all are 0s, set the button_out accordingly
        if (shift_reg == 16'hFFFF)
            button_out <= 1;
        else if (shift_reg == 16'h0000)
            button_out <= 0;
    end
endmodule
module button_sync(
    input clk,             // Main system clock
    input button_in,       // Debounced button input
    output reg button_sync // Synchronized button output
);

    reg button_ff1, button_ff2;

    always @(posedge clk) begin
        button_ff1 <= button_in;      // First stage of synchronization
        button_ff2 <= button_ff1;     // Second stage of synchronization
        button_sync <= button_ff2;    // Output the synchronized button signal
    end
endmodule
//input wire clk, wire button_in, output reg button_out);

//    parameter DEBOUNCE_TIME = 100; 

//    reg [24:0] counter;         
//    reg button_state;           
//    reg button_prev;           
//    reg button_press;    

//    initial begin
//        button_state = 1'b0;
//        button_prev = 1'b0;
//        button_press = 1'b0;
//        counter = 0;
//        button_out = 1'b0;
//    end

//    always @(posedge clk) begin
//        button_prev <= button_in; 
        
//        if (button_in && !button_prev && !button_press) begin
//            button_press <= 1'b1;
//            button_out <= 1'b1; 
//        end 
//        else begin
//            button_out <= 1'b0;
//        end

//        if (button_press) begin
//            if (counter < DEBOUNCE_TIME - 1) begin
//                counter <= counter + 1; 
//            end 
//            else begin
//                counter <= 0;           
//                button_press <= 1'b0;    
//            end
//        end
//    end
//endmodule