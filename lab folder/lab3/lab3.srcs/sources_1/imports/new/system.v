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


module system(
    output [6:0] seg,
    output dp,
    output [3:0] an,
    input [7:0] sw,
    input btnC,
    input btnU,
    input clk

    );
    
    wire [3:0] num0;
    wire [3:0] num1;
    wire [3:0] num2;
    wire [3:0] num3;
    wire cout0,bout0,cout1,bout1,cout2,bout2,cout3,bout3;
    reg up0,up1,up2,up3;
    reg down0,down1,down2,down3;
    reg set90,set91,set92,set93;
    reg set00,set01,set02,set03;
    
//    reg [3:0] num0_reg, num1_reg, num2_reg, num3_reg;
    
//    assign num0=num0_reg;
//    assign num1=num1_reg;
//    assign num2=num2_reg;
//    assign num3=num3_reg;
    
    wire targetClk;
    wire an0,an1,an2,an3;
    
    assign an={an3,an2,an1,an0};
    
    wire [18:0] tclk;
    
    assign tclk[0]=clk;
    
    genvar c;
    generate for(c=0;c<18;c=c+1)
    begin
        clockDiv fdiv(tclk[c+1], tclk[c]);
    end
    endgenerate
    
    clockDiv fdivTarget(targetClk, tclk[18]);    
    
    wire [7:0] sw;
    wire [7:0] sw_sp;
    wire btnC, btnU, btnC_sp, btnW_sp;
    generate for(c=0;c<8;c=c+1)
    begin
        singlePulser sp(sw_sp[c], sw[c], targetClk);
    end
    endgenerate
    singlePulser sp2(btnC_sp, btnC, targetClk);
    singlePulser sp3(btnU_sp, btnU, targetClk);
    
    onedigitBCD bcd0(num0,cout0,bout0,up0,down0,set90,set00,targetClk);
    onedigitBCD bcd1(num1,cout1,bout1,up1,down1,set91,set01,targetClk);
    onedigitBCD bcd2(num2,cout2,bout2,up2,down2,set92,set02,targetClk);
    onedigitBCD bcd3(num3,cout3,bout3,up3,down3,set93,set03,targetClk);
    quadSevenSeg q7seg(seg,dp,an0,an1,an2,an3,num0,num1,num2,num3,targetClk);
    
    always @(sw_sp) begin
        case(sw_sp)
            8'b00000000:begin up0=0;up1=0;up2=0;up3=0; end
            8'b00000001:begin up0=0;up1=0;up2=0;up3=0; end
            8'b00000010:begin up0=((num3!=9)||(num2!=9)||(num1!=9)||(num0!=9));
                                up1=(((num3!=9)||(num2!=9)||(num1!=9))&&(num0==9));
                                up2=(((num3!=9)||(num2!=9))&&(num1==9)&&(num0==9));
                                up3=((num3!=9)&&(num2==9)&&(num1==9)&&(num0==9)); end
            8'b00000100:begin up0=0;up1=0;up2=0;up3=0; end
            8'b00001000:begin up0=0;up1=((num3!=9)||(num2!=9)||(num1!=9));
                                up2=(((num3!=9)||(num2!=9))&&(num1==9));
                                up3=((num3!=9)&&(num2==9)&&(num1==9)); end
            8'b00010000:begin up0=0;up1=0;up2=0;up3=0; end
            8'b00100000:begin up0=0;up1=0;up2=((num3!=9)||(num2!=9));
                                up3=((num3!=9)&&(num2==9)); end
            8'b01000000:begin up0=0;up1=0;up2=0;up3=0; end
            8'b10000000:begin up0=0;up1=0;up2=0;up3=(num3!=9); end
        endcase
        case(sw_sp)
            8'b00000000:begin down0=0;down1=0;down2=0;down3=0; end
            8'b00000001:begin down0=(num3!=0)||(num2!=0)||(num1!=0)||(num0!=0);
                                down1=((num3!=0)||(num2!=0)||(num1!=0))&&(num0==0);
                                down2=((num3!=0)||(num2!=0))&&(num1==0)&&(num0==0);
                                down3=(num3!=0)&&(num2==0)&&(num1==0)&&(num0==0); end
            8'b00000010:begin down0=0;down1=0;down2=0;down3=0; end
            8'b00000100:begin down0=0;down1=(num3!=0)||(num2!=0)||(num1!=0);
                                down2=((num3!=0)||(num2!=0))&&(num1==0);
                                down3=(num3!=0)&&(num2==0)&&(num1==0); end
            8'b00001000:begin down0=0;down1=0;down2=0;down3=0; end
            8'b00010000:begin down0=0;down1=0;down2=(num3!=0)||(num2!=0);
                                down3=(num3!=0)&&(num2==0); end
            8'b00100000:begin down0=0;down1=0;down2=0;down3=0; end
            8'b01000000:begin down0=0;down1=0;down2=0;down3=(num3!=0); end
            8'b10000000:begin down0=0;down1=0;down2=0;down3=0; end
        endcase
    end
    
    always @(btnC_sp) begin
        if(btnC_sp == 1) begin
            {set00,set01,set02,set03} = 4'b1111;
        end
        else begin
            {set00,set01,set02,set03} = 4'b0000;
        end
    end
    
    always @(btnU_sp) begin
        if(btnU_sp == 1) begin
            {set90,set91,set92,set93} = 4'b1111;
        end
        else begin
            {set90,set91,set92,set93} = 4'b0000;
        end
    end
    
endmodule