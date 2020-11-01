`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2020 04:40:44 PM
// Design Name: 
// Module Name: cpuWB
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


module cpuWB(

    );

parameter DATA_WIDTH=32;
parameter ADDR_WIDTH=27;
reg	[7:0]	mem[0:1<<10 -1];
initial begin
	$readmemb("binary2BCD.dat",mem);
end

endmodule
