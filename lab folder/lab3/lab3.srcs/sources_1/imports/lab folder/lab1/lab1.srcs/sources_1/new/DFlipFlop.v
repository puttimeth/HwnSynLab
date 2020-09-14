`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2020 02:54:52 PM
// Design Name: 
// Module Name: DFlipFlop
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


module DFlipFlop(
    output q,
    input clock,
    input nreset,
    input d
    );
    
    reg q;
    always @(posedge clock)
    begin
        if(nreset == 1)
            q=d;
        else
            q=0;
    end
    
    always @(negedge nreset)
    begin
        q=0;
    end
    
endmodule
