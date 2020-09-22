`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2020 08:15:14 AM
// Design Name: 
// Module Name: ram
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


module ram(
    inout wire [7:0] d,
    input wire [6:0] addr,
    input wire oe,
    input wire we,
    input wire clk
    );
    
//    (* synthesis, ram block *)
    reg [7:0] mem [127:0];
    
    initial $readmemb("binary2BCD.dat", mem);
    
    always @(posedge clk) begin
        if(we) begin
            mem[addr] <= d;
        end
    end
    assign d = oe ? mem[addr]: 8'bZ;
    
endmodule
