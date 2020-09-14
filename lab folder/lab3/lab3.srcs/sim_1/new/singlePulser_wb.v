`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2020 12:37:19 PM
// Design Name: 
// Module Name: singlePulser_wb
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


module singlePulser_wb(

    );
    
    wire q;
    reg d, clock;
    
    singlePulser sp(q, d, clock);
    
    initial begin
        #0
        clock = 0;
        d = 0;
        #13
        d = 1;
        #30
        d = 0;
        #45
        d = 1;
        #25
        $finish;
    end
    
    always begin
    #5
    clock = ~clock; 
    end
    
endmodule
