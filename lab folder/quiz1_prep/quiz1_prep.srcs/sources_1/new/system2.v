`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2020 08:25:10 PM
// Design Name: 
// Module Name: system
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


module system2(
    output [6:0] seg,
    output dp,
    output [3:0] an,
    output [7:0] led,
    input [7:0] sw,
    input btnC,
    input btnU,
    input btnL,
    input btnR,
    input btnD,
    input clk

    );
    
    wire [3:0] num0;
    wire [3:0] num1;
    wire [3:0] num2;
    wire [3:0] num3;
//    wire cout0,bout0,cout1,bout1,cout2,bout2,cout3,bout3;
//    reg up0,up1,up2,up3;
//    reg down0,down1,down2,down3;
//    reg set90,set91,set92,set93;
//    reg set00,set01,set02,set03;
    
    // ram
//    reg [7:0] mem [127:0];    
//    initial $readmemb(".dat", mem);
    // end
    
//    wire an0,an1,an2,an3;
    
//    assign an={an3,an2,an1,an0};
    
    // generate divide clock
    wire targetClk;
    wire [18:0] tclk;    
    assign tclk[0]=clk;    
    genvar c;
    generate for(c=0;c<18;c=c+1)
    begin
        clockDiv fdiv(tclk[c+1], tclk[c]);
    end
    endgenerate    
    clockDiv fdivTarget(targetClk, tclk[18]);   
    // end 
    
    // 7 segment
    quadSevenSeg q7seg(seg,dp,an[0],an[1],an[2],an[3],num0,num1,num2,num3,targetClk);
    // end
    
    // sw + btn -> single pulser + divide clock
    wire [7:0] sw;
    wire [7:0] sw_sp;
    wire btnC, btnU, btnL, btnR, btnD;
    wire btnC_sp, btnU_sp, btnL_sp, btnR_sp, btnD_sp;
    generate for(c=0;c<8;c=c+1)
    begin
        singlePulser sp(sw_sp[c], sw[c], targetClk);
    end
    endgenerate
    singlePulser spBtnC(btnC_sp, btnC, targetClk);
    singlePulser spBtnU(btnU_sp, btnU, targetClk);
    singlePulser spBtnL(btnL_sp, btnL, targetClk);
    singlePulser spBtnR(btnR_sp, btnR, targetClk);
    singlePulser spBtnD(btnD_sp, btnD, targetClk);
    // end
    
    // function
    reg [3:0] num3_reg, num2_reg, num1_reg, num0_reg;
    assign led = sw;
    assign num3 = num3_reg;
    assign num2 = num2_reg;
    assign num1 = num1_reg;
    assign num0 = num0_reg;
    
    initial begin
        num3_reg = 1;
        num2_reg = 2;
        num1_reg = 3;
        num0_reg = 4;
    end
    
    always @(btnC_sp) begin
        if(btnC_sp == 1) begin
            num3_reg <= num3_reg + num2_reg;
        end
    end
    
    always @(btnU_sp) begin
        if(btnU_sp == 1) begin
            num2_reg <= num2_reg + num1_reg;
        end
    end 
    
    always @(btnL_sp) begin
        if(btnL_sp == 1) begin
            num1_reg <= num1_reg + num0_reg;
        end
    end 
    
    always @(btnR_sp) begin
        if(btnR_sp == 1) begin
            num0_reg <= num0_reg + num3_reg;
        end
    end 
    
endmodule
