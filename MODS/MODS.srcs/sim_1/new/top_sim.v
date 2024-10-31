`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2024 09:52:54
// Design Name: 
// Module Name: top_sim
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


module top_sim();

    reg clk = 1'b0,btnR= 1'b0,btnL = 1'b0,btnC = 1'b0,btnD = 1'b0,btnU = 1'b0;
    wire [7:0]JC,JX;
    wire [0:6] seg;
    wire [3:0] 
    wire btnC_stable;

//    Top_Module dut(.clk(clk),.btnR(btnR),.btnL(btnL),.btnC(btnC),.btnD(btnD),.btnU(btnD),.JC(JC));
    
//    debounce dut (.clk(clk),.button_in(btnC),.button_out(btnC_stable));
    
    Top_Module(.clk(clk),.btnR(btnR),.btnL(btnL),.btnC(btnC),.btnD(btnD),.btnU(btnD),.JC(JC),.JX(JX),.seg(seg),.an(an),.dp(dp));
    
    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 1'b0;
//        #100 btnD = 1'b1;
//        #10 btnD = 1'b0;
        #100 btnC = 1'b1;
        #200_000_100 btnC = 1'b0;
//        #50 btnR = 1'b1;
//        #10 btnR = 1'b0;
//        #100 btnL = 1'b1;
//        #10 btnL = 1'b0;
    end

endmodule
