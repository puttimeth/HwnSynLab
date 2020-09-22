`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2020 04:05:26 PM
// Design Name: 
// Module Name: stack
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


module stack(
    output [6:0] seg,
    output dp,
    output [3:0] an,
    input [7:0] sw,
    input btnU,
    input btnC,
    input btnD,
    input clk
    );
    
    wire [3:0] num0,num1,num2,num3;
    wire targetClk;
    wire an0,an1,an2,an3;
    wire [18:0] tclk;
    wire btnC, btnU, btnD, btnC_sp, btnU_sp, btnD_sp;
    
    assign an={an3,an2,an1,an0};
    assign tclk[0]=clk;
    
    genvar c;
    generate for(c=0;c<18;c=c+1)
    begin
        clockDiv fdiv(tclk[c+1], tclk[c]);
    end
    endgenerate    
    clockDiv fdivTarget(targetClk, tclk[18]);   
    
    singlePulser spBtnC(btnC_sp, btnC, targetClk);
    singlePulser spBtnU(btnU_sp, btnU, targetClk);
    singlePulser spBtnD(btnD_sp, btnD, targetClk);    
    
    reg [7:0] s[256:0];
    reg [7:0] address;
    reg [7:0] left;
    
    assign num3 = left[7:4];
    assign num2 = left[3:0];
    assign num1 = address[7:4];
    assign num0 = address[3:0];
    
    quadSevenSeg q7seg(seg,dp,an0,an1,an2,an3,num0,num1,num2,num3,targetClk);
    
    initial begin
        address = 0;
        left = 0;
    end
    
    always @(posedge targetClk) begin
        if(btnU_sp == 1) begin
            if(address < 256) begin
                address <= address+1;
                s[address+1] <= sw;
            end
        end
        else if(btnC_sp == 1) begin
            if(address > 0) begin
                left <= s[address];
                address <= address-1;
            end
        end
        else if(btnD_sp == 1) begin
            address <= 0;
            left <= 0;
        end
    end
    
endmodule
