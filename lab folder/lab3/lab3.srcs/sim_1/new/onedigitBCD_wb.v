`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2020 12:01:41 PM
// Design Name: 
// Module Name: onedigitBCD_wb
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


module onedigitBCD_wb(

    );
    
    reg up,down,set9,set0,clock;
    wire [3:0] DCBA;
    wire cout, bout;
    
    onedigitBCD bcd(DCBA, cout, bout, up, down, set9, set0, clock);
       
    initial begin
        #0
        clock = 0;
        up = 1;
        down = 0;
        set9 = 0;
        set0 = 0;
        #150
        up = 0;
        down = 1;
        #150
        down = 0;
        set9 = 1;
        #20
        set9 = 0;
        up = 1;
        #50
        up = 0;
        set0 = 1;
        #20
        set0 = 0;
        down = 1;
        #50
        $finish;
    end
    
    always begin
        #5
        clock = ~clock;
    end
    
endmodule
