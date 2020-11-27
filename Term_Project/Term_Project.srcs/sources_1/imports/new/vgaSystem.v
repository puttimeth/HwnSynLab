`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: Computer Engineering Department, Chulalongkorn University
// Engineer: Pollawat Hongwimol
// 
// Create Date: 04/11/2020 09:39:11 PM
// Design Name: 
// Module Name: vgaSystem
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


module vgaSystem(
    input clk,
    input btnC,
    input [3:0] sw,
    output Hsync,
    output Vsync,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue
    );
    
    reg r,g,b;
    
    wire line_clk;
    wire [15:0] h_val, v_val;
    
    hsync hs(clk, line_clk, h_val);
    vsync vs(clk, line_clk, v_val);
    
    assign Hsync = (h_val < 200) ? 1 : 0;
    assign Vsync = (v_val < 200) ? 1 : 0;
    
    assign {vgaRed, vgaGreen, vgaBlue} = ((h_val-367)**2 + (v_val-273)**2 <= 100**2) ? 12'hfff : 12'h000;
//    assign {vgaRed, vgaGreen, vgaBlue} = 12'h000;
//    assign vgaRed = 10;
//    assign vgaGreen = 0;
//    assign vgaBlue = 0;
    
endmodule
