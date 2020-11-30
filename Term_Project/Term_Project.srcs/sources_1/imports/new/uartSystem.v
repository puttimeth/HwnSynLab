`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: Computer Engineering Department, Chulalongkorn University
// Engineer: Pollawat Hongwimol
// 
// Create Date: 04/12/2020 03:03:19 AM
// Design Name: 
// Module Name: uartSystem
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
module uartSystem(
    input clk,
    input RsRx,
    output RsTx,
    output [7:0] answer4,
    output [7:0] answer3,
    output [7:0] answer2,
    output [7:0] answer1,
    output [7:0] answer0
    );
    
    reg [7:0] K0 = 8'h30;       //0
    reg [7:0] K1 = 8'h31;       //1
    reg [7:0] K2 = 8'h32;       //2
    reg [7:0] K3 = 8'h33;       //3
    reg [7:0] K4 = 8'h34;       //4
    reg [7:0] K5 = 8'h35;       //5
    reg [7:0] K6 = 8'h36;       //6
    reg [7:0] K7 = 8'h37;       //7
    reg [7:0] K8 = 8'h38;       //8
    reg [7:0] K9 = 8'h39;       //9
    reg [7:0] K_PLUS = 8'h2b;       //+
    reg [7:0] K_MINUS = 8'h2d;      //-
    reg [7:0] K_MUL = 8'h2a;        //*
    reg [7:0] K_DIV = 8'h2f;        ///
    reg [7:0] K_ENTER = 8'h0d;      //new line
    
    reg [7:0] equation[0:8];
    reg [3:0] equation_index = 0;
    
    reg ena, last_rec;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire sent, received, baud;
    reg [7:0] answer[0:4];
    reg [2:0] state = 0;
    reg signed [15:0] result;
    reg signed [14:0] op1, op2;
    reg op1_sign=0, op2_sign=0;
    reg [1:0] operation=0;
    
    assign answer4 = answer[4];
    assign answer3 = answer[3];
    assign answer2 = answer[2];
    assign answer1 = answer[1];
    assign answer0 = answer[0];
    
    baudrate_gen baudrate_gen(clk, baud);
    receiver receiver(baud, RsRx, received, data_out);
    transmitter transmitter(baud, data_in, ena, sent, RsTx);
    
    initial begin
        answer[4] = 0;
        answer[3] = 0;
        answer[2] = 0;
        answer[1] = 0;
        answer[0] = 0;
        op1=0;
        op2=0;
    end
    
    always @(posedge baud)
    begin
        if (ena == 1) ena = 0;
        
        if (~last_rec & received) begin
            case (data_out)
                K0: begin data_in = data_out;
                if (state==0 || state==1) begin state=1; op1=op1*10; end
                if (state==3 || state==4) begin state=4; op2=op2*10; end end
                K1: begin data_in = data_out;
                if (state==0 || state==1) begin state=1; op1=op1*10+1; end
                if (state==3 || state==4) begin state=4; op2=op2*10+1; end end
                K2: begin data_in = data_out;
                if (state==0 || state==1) begin state=1; op1=op1*10+2; end
                if (state==3 || state==4) begin state=4; op2=op2*10+2; end end
                K3: begin data_in = data_out;
                if (state==0 || state==1) begin state=1; op1=op1*10+3; end
                if (state==3 || state==4) begin state=4; op2=op2*10+3; end end
                K4: begin data_in = data_out;
                if (state==0 || state==1) begin state=1; op1=op1*10+4; end
                if (state==3 || state==4) begin state=4; op2=op2*10+4; end end
                K5: begin data_in = data_out;
                if (state==0 || state==1) begin state=1; op1=op1*10+5; end
                if (state==3 || state==4) begin state=4; op2=op2*10+5; end end
                K6: begin data_in = data_out;
                if (state==0 || state==1) begin state=1; op1=op1*10+6; end
                if (state==3 || state==4) begin state=4; op2=op2*10+6; end end
                K7: begin data_in = data_out;
                if (state==0 || state==1) begin state=1; op1=op1*10+7; end
                if (state==3 || state==4) begin state=4; op2=op2*10+7; end end
                K8: begin data_in = data_out;
                if (state==0 || state==1) begin state=1; op1=op1*10+8; end
                if (state==3 || state==4) begin state=4; op2=op2*10+8; end end
                K9: begin data_in = data_out;
                if (state==0 || state==1) begin state=1; op1=op1*10+9; end
                if (state==3 || state==4) begin state=4; op2=op2*10+9; end end                
                K_PLUS: begin data_in = data_out;
                if (state==1) begin operation=0; state=3; end
                end
                K_MINUS: begin data_in = data_out;                 
                if (state==0) begin op1_sign=1; state=1; end
                else if (state==1) begin operation=1; state=3; end
                else if (state==3) begin op2_sign=1; state=4; end
                end
                K_MUL: begin data_in = data_out;
                if (state==1) begin operation=2; state=3; end  end
                K_DIV: begin data_in = data_out;
                if (state==1) begin operation=3; state=3; end  end
                K_ENTER: begin 
                data_in = data_out; 
                if (op1_sign) op1=-op1;
                if (op2_sign) op2=-op2;
                case (operation)
                    2'b00: begin result=op1+op2; end
                    2'b01: begin result=op1-op2; end
                    2'b10: begin result=op1*op2; end
                    2'b11: begin result=op1/op2; end
                    default: begin result=0; end
                endcase
                if (result>9999 | result<-9999) begin
                    answer[4]=10;
                    answer[3]=11;
                    answer[2]=12;
                    answer[1]=11;
                    answer[0]=13;
                end
                else begin
                    if (result<$signed(0)) begin
                        result=-result;
                        answer[4]=10;
                    end
                    else answer[4]=0;
                    answer[3]=(result/1000)-(result/10000*10);
                    answer[2]=(result/100)-(result/1000*10);
                    answer[1]=(result/10)-(result/100*10);
                    answer[0]=(result)-(result/10*10);
                end
                state=0; op1_sign=0; op2_sign=0; op1=0; op2=0;
                end
                default: data_in = 8'hff;
            endcase
            if (data_in != 8'hFF) ena = 1;
        end
        last_rec = received;
    end
    
endmodule
