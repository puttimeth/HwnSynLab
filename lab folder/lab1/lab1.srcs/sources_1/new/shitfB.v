`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2020 03:40:47 PM
// Design Name: 
// Module Name: shitfB
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


module shiftB(q,clock,d);
    output [1:0] q;
    input clock;
    input d;
    reg [1:0] q;
    always @(posedge clock)
    begin
        q[0]<=d;
        q[1]<=q[0];
    end
endmodule
