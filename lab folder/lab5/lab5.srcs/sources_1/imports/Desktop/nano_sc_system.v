`timescale 1ns / 1ps
//-------------------------------------------------------
// File name    : nano_sc_system.v
// Title        : nanoCPU Single Cycle system.
// Library      : nanoLADA
// Purpose      : Computer Architecture
// Developers   : Krerk Piromsopa, Ph. D.
//              : Chulalongkorn University.

module nano_sc_system(seg,dp,an,sw);
wire 	[31:0]	p_address;
wire 	[31:0]	p_data;
wire	[31:0]	d_address;
wire		mem_wr;
wire	[31:0]	d_data;
reg		clock;
reg		nreset;
output [6:0] seg;
output dp;
output [3:0] an;
input [11:0] sw;

nanocpu	CPU(p_address,p_data,d_address,d_data,mem_wr,clock,nreset);
rom 	PROGMEM(p_data,p_address[17:2]);
memory 	DATAMEM(d_data,d_address[15:0],mem_wr,clock,sw,seg,an,dp);

initial
begin
	$dumpfile("nano_sc_system.dump");
	$dumpvars(4, nano_sc_system);

	clock=0;
	nreset=0;
	#40;
	nreset=1;
	#2000;
	$finish;
end

always
begin : CLOCK
	#20
	clock=~clock;
end


endmodule
