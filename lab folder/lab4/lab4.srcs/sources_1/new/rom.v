`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2020 04:32:12 PM
// Design Name: 
// Module Name: rom
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


module rom(
    (* synthesis, rom_block = "ROM_BLOCK XYZ01" *)
    output reg [3:0] z ,
    input clk,
    input wire [2:0] a); // address? 8 deep memory
    always@(posedge clk) begin // @(a)
        case (a)
            3'b000: z=4'b1011;
            
        endcase
    end
endmodule
