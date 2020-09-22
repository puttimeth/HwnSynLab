`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2020 04:12:41 PM
// Design Name: 
// Module Name: binary2BCD
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


module binary2BCD(
    output [6:0] seg,
    output dp,
    output [3:0] an,
    input [4:0] sw,
    input clk
    );
    
//    reg [7:0] rom[31:0];
//    initial $readmemb("binary2BCD.dat", rom);
    
    wire [3:0] num0,num1,num2,num3;
    wire targetClk;
    wire an0,an1,an2,an3;
    wire [18:0] tclk;
    wire [7:0] d;
    assign an={an3,an2,an1,an0};
    assign tclk[0]=clk;    
    genvar c;
    generate for(c=0;c<18;c=c+1)
    begin
        clockDiv fdiv(tclk[c+1], tclk[c]);
    end
    endgenerate    
    clockDiv fdivTarget(targetClk, tclk[18]);
    
    ram r(d,sw,1,0,targetClk);
    
    assign num3 = 0;
    assign num2 = 0;
    assign num1 = d[7:4];
    assign num0 = d[3:0];
    
    quadSevenSeg q7seg(seg,dp,an0,an1,an2,an3,num0,num1,num2,num3,targetClk);
    
endmodule
