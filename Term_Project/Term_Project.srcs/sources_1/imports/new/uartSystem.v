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
    output RsTx
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
    reg [7:0] K_ENTER = 8'h0a;      //new line
    
    reg ena, last_rec;
    reg [7:0] data_in;
    wire [7:0] data_out_plus;
    wire [7:0] data_out;
    wire sent, received, baud;
    
    
    baudrate_gen baudrate_gen(clk, baud);
    receiver receiver(baud, RsRx, received, data_out);
    transmitter transmitter(baud, data_in, ena, sent, RsTx);
    
    always @(posedge baud)
    begin
        if (ena == 1) ena = 0;
        
        if (~last_rec & received) begin
            case (data_out)
                K0: begin data_in = data_out; end
                K1: begin data_in = data_out; end
                K2: begin data_in = data_out; end
                K3: begin data_in = data_out; end
                K4: begin data_in = data_out; end
                K5: begin data_in = data_out; end
                K6: begin data_in = data_out; end
                K7: begin data_in = data_out; end
                K8: begin data_in = data_out; end
                K9: begin data_in = data_out; end                
                K_PLUS: begin data_in = data_out; end
                K_MINUS: begin data_in = data_out; end
                K_MUL: begin data_in = data_out; end
                K_DIV: begin data_in = data_out; end
                K_ENTER: begin data_in = data_out; end
                default: data_in = 8'hff;
            endcase
            if (data_in != 8'hFF) ena = 1;
        end
        last_rec = received;
    end
    
endmodule
