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


module testShifter(
    
    );
    
    reg clock,d;
    shitfB a(q,clock,d);
    always
        #10 clock=!clock;
        
    initial
    begin
        #0;
        clock=0;
        d=0;
        #100 $finish;
    end
    
    always
        #20 d=!d;
        
endmodule
