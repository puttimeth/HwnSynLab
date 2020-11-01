`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2020 03:25:18 PM
// Design Name: 
// Module Name: aluWB
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


module aluWB(

    );
    
//    reg clock;
    wire [31:0] S;
    wire z, Cout; 
    reg [31:0] A, B;
    reg [2:0] alu_ops;
    reg Cin;
    
//    always
//        #10 clock = ~clock;
        
    alu aaa(S, z, Cout, A, B, Cin, alu_ops);
    
    initial begin
        A=0;
        B=0;
        Cin=0;
        alu_ops=0;
    end
    
    always begin
        A=5;
        B=20;
        Cin=1;
        alu_ops=0; //26 0x1a
        #10
        A=15;
        B=3;
        Cin=0;
        alu_ops=1; //12 0x0c
        #10
        A=9; 
        B=5; 
        alu_ops=2; //13 0x0d
        #10
        alu_ops=3; //1 0x01
        #10
        alu_ops=4; //12 0x0c
        #10
        alu_ops=5; //0xfffffff7
        #10
        alu_ops=6; //0xfffffff6
        #10
        alu_ops=7; //0xfffffffa
        #10
        $finish;
    end
    
endmodule
