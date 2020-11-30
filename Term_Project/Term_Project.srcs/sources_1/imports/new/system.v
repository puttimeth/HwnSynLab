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
    output wire [10:0]led,
    output wire [3:0]vgaRed, vgaGreen, vgaBlue,
    output wire Hsync, Vsync,
    input wire [11:0]sw,
    input btnC, btnU, btnL, clk
    );

wire [7:0] answer[0:4];

vga_test vga(
    .clk(clk), 
    .answer4(answer[4]),
    .answer3(answer[3]),
    .answer2(answer[2]),
    .answer1(answer[1]),
    .answer0(answer[0]),
    .push({btnL, btnU}),
    .hsync(Hsync),
    .vsync(Vsync),
    .rgb({vgaRed, vgaGreen, vgaBlue})
);

uartSystem u(
    .clk(clk),
    .RsRx(RsRx),
    .RsTx(RsTx),
    .answer4(answer[4]),
    .answer3(answer[3]),
    .answer2(answer[2]),
    .answer1(answer[1]),
    .answer0(answer[0])
);

/*top_uart u(
    .RsTx(RsTx),
    .RsRx(RsRx),
    .led(led),
    .clk(clk)
    );*/
endmodule