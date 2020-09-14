`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2020 11:51:01 AM
// Design Name: 
// Module Name: tester
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


module tester(

    );
    
    reg a,b,cin;
    wire cout,s;
    
    fullAdder2 a1(cout,s,a,b,cin);
    
    initial
    begin
        $monitor("time %t: {%b %b} <- {%d %d %d}", $time, cout, s, a,b, cin);
        #0;
        a=0;
        b=0;
        cin=0;
        #5;
        a=0;
        b=0;
        cin=1;
        #5;
        a=0;
        b=1;
        cin=0;
        #5;
        a=0;
        b=1;
        cin=1;
        #5;
        a=1;
        b=0;
        cin=0;
        #5;
        a=1;
        b=0;
        cin=1;
        #5;
        a=1;
        b=1;
        cin=0;
        #5;
        a=1;
        b=1;
        cin=1;
        #5;
        $finish;
    end    
endmodule
