`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2024 10:18:09
// Design Name: 
// Module Name: test
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


module test();

    reg clk = 1'b0,turned_on = 1'b1, ai_turned_on = 1'b1,btnC = 1'b0,btnU = 1'b0,btnL = 1'b0,btnR = 1'b0,btnD = 1'b0;
    wire [3:0] led;
    wire seg;
    wire [3:0] an;
    wire dp;

    main dut (.clk(clk),.turned_on(turned_on),.ai_turned_on(ai_turned_on),.btnC(btnC),.btnU(btnU),.btnD(btnD),.led(led),.seg(seg),.an(an),.dp(dp));

    always begin
        #5 clk <= ~clk;
    end
    
    initial begin
        #50000 ai_turned_on = 1'b1;
        #5 btnD = 1'b1;
        #10 btnD = 1'b0;
        #50000 btnC = 1'b1;
        #5 btnC = 1'b0;
        #500 btnU = 1'b1;
        #5 btnU = 1'b0;
        #500 btnD = 1'b1;
        #5 btnD = 1'b0;
        #50000 btnC = 1'b1;
        #5 btnC = 1'b0;
        #500_000 btnD = 1'b1;
        #5 btnD = 1'b0;
        #500_000 btnD = 1'b1;
        #5 btnD = 1'b0;
        #500_000 btnD = 1'b1;
        #5 btnD = 1'b0;
    end
    
endmodule
