`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2020 12:30:22 PM
// Design Name: 
// Module Name: singlePulser
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


module singlePulser(
    output q,
    input d,
    input clock
    );
    
    reg q;
    reg state;
    initial begin 
        q <= 0;
        state <= 0;
    end
    always @(posedge clock) begin
        if (d==1) begin
            if(state==0) begin 
                q <= 1;
                state <= 1;
            end
            else begin
                q <= 0;
            end
        end
        else begin
            q <= 0;
            state <=0;
        end
      end
    
endmodule
