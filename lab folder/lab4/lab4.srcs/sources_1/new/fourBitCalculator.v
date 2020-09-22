`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2020 11:22:42 PM
// Design Name: 
// Module Name: fourBitCalculator
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


module fourBitCalculator(
    output [6:0] seg,
    output dp,
    output [3:0] an,
    input [7:0] sw,
    input btnU,
    input btnL,
    input btnD,
    input btnR,
    input clk
    );
    
    reg [11:0] rom_add[255:0];
    reg [11:0] rom_sub[255:0];
    reg [11:0] rom_mul[255:0];
    reg [11:0] rom_div[255:0];
    initial $readmemb("4bitCalculator_add.dat", rom_add);
    initial $readmemb("4bitCalculator_minus.dat", rom_sub);
    initial $readmemb("4bitCalculator_multiply.dat", rom_mul);
    initial $readmemb("4bitCalculator_divide.dat", rom_div);
    
    wire [3:0] num0,num1,num2,num3;
    wire targetClk;
    wire an0,an1,an2,an3;
    wire [18:0] tclk;
    reg [3:0] n0,n1,n2;
    assign an={an3,an2,an1,an0};
    assign tclk[0]=clk;    
    genvar c;
    generate for(c=0;c<18;c=c+1)
    begin
        clockDiv fdiv(tclk[c+1], tclk[c]);
    end
    endgenerate    
    clockDiv fdivTarget(targetClk, tclk[18]);
    
    assign num3 = 0;
    assign num2 = n2;
    assign num1 = n1;
    assign num0 = n0;
    
    quadSevenSeg q7seg(seg,dp,an0,an1,an2,an3,num0,num1,num2,num3,targetClk);
    
    always @(posedge targetClk) begin
        if(btnU == 1) begin
            n2 = rom_add[sw][11:8];
            n1 = rom_add[sw][7:4];
            n0 = rom_add[sw][3:0];
        end
        else if(btnL == 1) begin
            n2 = rom_sub[sw][11:8];
            n1 = rom_sub[sw][7:4];
            n0 = rom_sub[sw][3:0];
        end
        else if(btnD == 1) begin
            n2 = rom_mul[sw][11:8];
            n1 = rom_mul[sw][7:4];
            n0 = rom_mul[sw][3:0];
        end
        else if(btnR == 1) begin
            n2 = rom_div[sw][11:8];
            n1 = rom_div[sw][7:4];
            n0 = rom_div[sw][3:0];
        end
    end
    
endmodule
