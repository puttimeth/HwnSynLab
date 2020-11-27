`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2020 07:47:46 PM
// Design Name: 
// Module Name: baudrate_gen
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


module baudrate_gen(
    input clk,
    output baud
    );
    
    reg baud;
    reg [16:0] counter;
    
    always @(posedge clk) begin
        counter = counter + 1;
        if(counter >= 104166) begin counter=0; baud=~baud; end
    end
    
endmodule
