`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2019 03:09:33 PM
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
    output wire RsTx,
    input wire RsRx,
    output wire [3:0]vgaRed, vgaGreen, vgaBlue,
    output wire Hsync, Vsync,
    input btnC, clk
    );

wire [7:0] answer[0:4];

vga_test vga(
    .clk(clk), 
    .answer4(answer[4]),
    .answer3(answer[3]),
    .answer2(answer[2]),
    .answer1(answer[1]),
    .answer0(answer[0]),
    .hsync(Hsync),
    .vsync(Vsync),
    .rgb({vgaRed, vgaGreen, vgaBlue})
);

uartSystem u(
    .clk(clk),
    .RsRx(RsRx),
    .btnC(btnC),
    .RsTx(RsTx),
    .answer4(answer[4]),
    .answer3(answer[3]),
    .answer2(answer[2]),
    .answer1(answer[1]),
    .answer0(answer[0])
);

endmodule