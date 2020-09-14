`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2020 11:10:27 AM
// Design Name: 
// Module Name: 1digitBCD
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


module onedigitBCD(
    output [3:0] DCBA,
    output cout,
    output bout,
    input up,
    input down,
    input set9,
    input set0,
    input clock
    );
    
    reg [3:0] DCBA;
    reg cout, bout;
    
    initial
    begin
        DCBA = 0;
        cout=0;
        bout=0;
    end
    always@(posedge clock)
    begin
        if(DCBA==9 && up==1 && down==0)
        begin
            DCBA = 0;
            cout = 1;
        end else if(DCBA==0 && down==1 && up==0)
        begin
            DCBA = 9;
            bout = 1;
        end else begin
            if(down==1)DCBA = DCBA-1;
            else if(up==1)DCBA = DCBA+1;
            bout=0;
            cout=0;
        end
        if(set9==1)DCBA = 9;
        if(set0==1)DCBA =0;
    end
    
endmodule
