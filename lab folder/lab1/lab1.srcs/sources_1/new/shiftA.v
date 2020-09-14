`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2020 03:39:55 PM
// Design Name: 
// Module Name: shiftA
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


module shiftA(
    output [1:0] q,
    input clock,
    input d
    );
    reg [1:0] q;
    always @(posedge clock)
    begin
        q[0]=d;
        q[1]=q[0];
    end
endmodule
