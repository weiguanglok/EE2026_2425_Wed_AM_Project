`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2024 22:15:41
// Design Name: 
// Module Name: sim_main
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


module sim_main();

    reg clk = 1'b0;
    reg turned_on = 1'b1;
    reg btnC = 1'b0;
    
    wire [0:6] seg;
    wire [3:0] an;
    wire dp;

    main dut (.clk(clk),.turned_on(turned_on),.btnC(btnC),.seg(seg),.an(an),.dp(dp));
    
    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        #5000 btnC = 1'b1;
        #10 btnC = 1'b0;
    end

endmodule
