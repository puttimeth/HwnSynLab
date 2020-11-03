`timescale 1ns / 1ps
//-------------------------------------------------------
// File name    : memory.v
// Title        : Memory
// Library      : nanoLADA
// Purpose      : Computer Architecture
// Developers   : Krerk Piromsopa, Ph. D.
//              : Chulalongkorn University.
module memory(data,address,wr,clock,sw,seg,an,dp);
parameter DATA_WIDTH=32;
parameter ADDR_WIDTH=16;

inout	[DATA_WIDTH-1:0]	data;
input	[ADDR_WIDTH-1:0]	address;
input		wr;
input		clock;
input [11:0] sw;
output [6:0] seg;
output [3:0] an;
output dp;

reg [3:0] num0, num1, num2, num3;
wire dp, an0, an1, an2, an3;

reg	[DATA_WIDTH-1:0]	mem[0:(1<<ADDR_WIDTH) -1];

reg	[DATA_WIDTH-1:0]	data_out;
// Tri-State buffer
assign data=(wr==0) ? data_out:32'bz;

//assign num3 = mem[65532][3:0];
//assign num2 = mem[65528][3:0];
//assign num1 = mem[65524][3:0];
//assign num0 = mem[65520][3:0];
//assign sw[11:8] = mem[65512][3:0];
//assign sw[7:4] = mem[65508][3:0];
//assign sw[3:0] = mem[65504][3:0];

quadSevenSeg quad7seg(seg, dp, an[0],an[1],an[2],an[3], num0, num1, num2, num3, clock);

integer i;
initial
begin
	$readmemb("data.dat",mem);
end

always @(address)
begin
    case (address)
        16'hFFF0 : data_out = num0;
        16'hFFF4 : data_out = num1;
        16'hFFF8 : data_out = num2;
        16'hFFFC : data_out = num3;
        16'hFFE0 : data_out = sw[3:0];
        16'hFFE4 : data_out = sw[7:4];
        16'hFFE8 : data_out = sw[11:8];
        default : data_out = mem[address];        
    endcase 
//	$display("%10d - mem[%h] -  %h\n",$time, address,data_out);	
//	data_out = mem[address];
end

always @(posedge clock)
begin : MEM_WRITE
	if (wr) begin
	   case (address)
	       16'hFFF0 : num0 = data;
	       16'hFFF4 : num1 = data;
	       16'hFFF8 : num2 = data;
	       16'hFFFC : num3 = data[7:4];
	       default : mem[address] = data;
		endcase
//		mem[address]=data;
//		$display("%10d - MEM[%h] <- %h",$time, address, data);
	end
end

endmodule
