`timescale 1ns / 1ps
//-------------------------------------------------------
// File name    : memory.v
// Title        : Memory
// Library      : nanoLADA
// Purpose      : Computer Architecture
// Developers   : Krerk Piromsopa, Ph. D.
//              : Chulalongkorn University.
module memory(data,address,wr,clock,num3,num2,num1,num0,sw);
parameter DATA_WIDTH=32;
parameter ADDR_WIDTH=27;

inout	[DATA_WIDTH-1:0]	data;
input	[ADDR_WIDTH-1:0]	address;
input		wr;
input		clock;
output [3:0] num3,num2,num1,num0;
output [11:0] sw;

reg	[DATA_WIDTH-1:0]	mem[0:(1<<ADDR_WIDTH) -1];

reg	[DATA_WIDTH-1:0]	data_out;
// Tri-State buffer
assign data=(wr==0) ? data_out:32'bz;

assign num3 = mem[65532][3:0];
assign num2 = mem[65528][3:0];
assign num1 = mem[65524][3:0];
assign num0 = mem[65520][3:0];
assign sw[11:8] = mem[65512][3:0];
assign sw[7:4] = mem[65508][3:0];
assign sw[3:0] = mem[65504][3:0];

integer i;
initial
begin
	$readmemb("data.dat",mem);
end

always @(address)
begin
	$display("%10d - mem[%h] -  %h\n",$time, address,data_out);	
	data_out = mem[address];
end

always @(posedge clock)
begin : MEM_WRITE
	if (wr) begin
		mem[address]=data;
		$display("%10d - MEM[%h] <- %h",$time, address, data);
	end
end

endmodule
