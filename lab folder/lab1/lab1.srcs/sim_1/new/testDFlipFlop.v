`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2020 03:06:22 PM
// Design Name: 
// Module Name: testDFlipFlop
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


module testDFlipFlop(
    
    );
    
    reg clock, nreset ,d;
    DFlipFlop D1(q,clock,nreset,d);
    always
        #10 clock = ~clock;
    initial
    begin
        #0 d=0;
        clock=0;
        nreset=0;
        #30 nreset = 1;
        #72 nreset = 0;
        #53 nreset = 1;
        #200 $finish;
    end
    always
        #8 d=~d;
        
endmodule
