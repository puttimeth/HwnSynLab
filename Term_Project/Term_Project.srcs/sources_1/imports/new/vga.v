`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2019 03:31:32 PM
// Design Name: 
// Module Name: vga
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
module vga_sync
	(
		input wire clk, reset,
		output wire hsync, vsync, video_on, p_tick,
		output wire [9:0] x, y
	);
	
	// constant declarations for VGA sync parameters
	localparam H_DISPLAY       = 640; // horizontal display area
	localparam H_L_BORDER      =  48; // horizontal left border
	localparam H_R_BORDER      =  16; // horizontal right border
	localparam H_RETRACE       =  96; // horizontal retrace
	localparam H_MAX           = H_DISPLAY + H_L_BORDER + H_R_BORDER + H_RETRACE - 1;
	localparam START_H_RETRACE = H_DISPLAY + H_R_BORDER;
	localparam END_H_RETRACE   = H_DISPLAY + H_R_BORDER + H_RETRACE - 1;
	
	localparam V_DISPLAY       = 480; // vertical display area
	localparam V_T_BORDER      =  10; // vertical top border
	localparam V_B_BORDER      =  33; // vertical bottom border
	localparam V_RETRACE       =   2; // vertical retrace
	localparam V_MAX           = V_DISPLAY + V_T_BORDER + V_B_BORDER + V_RETRACE - 1;
        localparam START_V_RETRACE = V_DISPLAY + V_B_BORDER;
	localparam END_V_RETRACE   = V_DISPLAY + V_B_BORDER + V_RETRACE - 1;
	
	// mod-4 counter to generate 25 MHz pixel tick
	reg [1:0] pixel_reg;
	wire [1:0] pixel_next;
	wire pixel_tick;
	
	always @(posedge clk, posedge reset)
		if(reset)
		  pixel_reg <= 0;
		else
		  pixel_reg <= pixel_next;
	
	assign pixel_next = pixel_reg + 1; // increment pixel_reg 
	
	assign pixel_tick = (pixel_reg == 0); // assert tick 1/4 of the time
	
	// registers to keep track of current pixel location
	reg [9:0] h_count_reg, h_count_next, v_count_reg, v_count_next;
	
	// register to keep track of vsync and hsync signal states
	reg vsync_reg, hsync_reg;
	wire vsync_next, hsync_next;
 
	// infer registers
	always @(posedge clk, posedge reset)
		if(reset)
		    begin
                    v_count_reg <= 0;
                    h_count_reg <= 0;
                    vsync_reg   <= 0;
                    hsync_reg   <= 0;
		    end
		else
		    begin
                    v_count_reg <= v_count_next;
                    h_count_reg <= h_count_next;
                    vsync_reg   <= vsync_next;
                    hsync_reg   <= hsync_next;
		    end
			
	// next-state logic of horizontal vertical sync counters
	always @*
		begin
		h_count_next = pixel_tick ? 
		               h_count_reg == H_MAX ? 0 : h_count_reg + 1
			       : h_count_reg;
		
		v_count_next = pixel_tick && h_count_reg == H_MAX ? 
		               (v_count_reg == V_MAX ? 0 : v_count_reg + 1) 
			       : v_count_reg;
		end
		
        // hsync and vsync are active low signals
        // hsync signal asserted during horizontal retrace
        assign hsync_next = h_count_reg >= START_H_RETRACE
                            && h_count_reg <= END_H_RETRACE;
   
        // vsync signal asserted during vertical retrace
        assign vsync_next = v_count_reg >= START_V_RETRACE 
                            && v_count_reg <= END_V_RETRACE;

        // video only on when pixels are in both horizontal and vertical display region
        assign video_on = (h_count_reg < H_DISPLAY) 
                          && (v_count_reg < V_DISPLAY);

        // output signals
        assign hsync  = hsync_reg;
        assign vsync  = vsync_reg;
        assign x      = h_count_reg;
        assign y      = v_count_reg;
        assign p_tick = pixel_tick;
endmodule

module vga_test
	(
		input wire clk,
		input wire [7:0] answer4,
		input wire [7:0] answer3,
		input wire [7:0] answer2,
		input wire [7:0] answer1,
		input wire [7:0] answer0,
		input wire [1:0] push,
		output wire hsync, vsync,
		output wire [11:0] rgb
	);

	parameter WIDTH = 640;
	parameter HEIGHT = 480;
		
	// register for Basys 2 8-bit RGB DAC 
	reg [11:0] rgb_reg;
	reg reset = 0;
	wire [9:0] x, y;

	// video status output from vga_sync to tell when to route out rgb signal to DAC
	wire video_on;
    wire p_tick;
	// instantiate vga_sync
	vga_sync vga_sync_unit (.clk(clk), .reset(reset), .hsync(hsync), .vsync(vsync), .video_on(video_on), .p_tick(p_tick), .x(x), .y(y));
		
	reg [11:0] screen[0:23][0:31];
	reg [11:0] set[0:7][0:4][0:15];
		
	// 0-9, 10-, 11N, 12A, 13I
	initial begin
	   // num0
	   set[0][0][0]=12'hff; set[0][1][0]=12'hff; set[0][2][0]=12'hff; set[0][3][0]=12'hff; set[0][4][0]=12'hff; 
	   set[1][0][0]=12'hff; set[1][1][0]=12'h00; set[1][2][0]=12'h00; set[1][3][0]=12'h00; set[1][4][0]=12'hff; 
	   set[2][0][0]=12'hff; set[2][1][0]=12'h00; set[2][2][0]=12'h00; set[2][3][0]=12'h00; set[2][4][0]=12'hff; 
	   set[3][0][0]=12'hff; set[3][1][0]=12'h00; set[3][2][0]=12'h00; set[3][3][0]=12'h00; set[3][4][0]=12'hff; 
	   set[4][0][0]=12'hff; set[4][1][0]=12'h00; set[4][2][0]=12'h00; set[4][3][0]=12'h00; set[4][4][0]=12'hff; 
	   set[5][0][0]=12'hff; set[5][1][0]=12'h00; set[5][2][0]=12'h00; set[5][3][0]=12'h00; set[5][4][0]=12'hff; 
	   set[6][0][0]=12'hff; set[6][1][0]=12'h00; set[6][2][0]=12'h00; set[6][3][0]=12'h00; set[6][4][0]=12'hff; 
	   set[7][0][0]=12'hff; set[7][1][0]=12'hff; set[7][2][0]=12'hff; set[7][3][0]=12'hff; set[7][4][0]=12'hff;
	   // num1
	   set[0][0][1]=12'h00; set[0][1][1]=12'h00; set[0][2][1]=12'h00; set[0][3][1]=12'hff; set[0][4][1]=12'hff; 
	   set[1][0][1]=12'h00; set[1][1][1]=12'h00; set[1][2][1]=12'h00; set[1][3][1]=12'h00; set[1][4][1]=12'hff; 
	   set[2][0][1]=12'h00; set[2][1][1]=12'h00; set[2][2][1]=12'h00; set[2][3][1]=12'h00; set[2][4][1]=12'hff; 
	   set[3][0][1]=12'h00; set[3][1][1]=12'h00; set[3][2][1]=12'h00; set[3][3][1]=12'h00; set[3][4][1]=12'hff; 
	   set[4][0][1]=12'h00; set[4][1][1]=12'h00; set[4][2][1]=12'h00; set[4][3][1]=12'h00; set[4][4][1]=12'hff; 
	   set[5][0][1]=12'h00; set[5][1][1]=12'h00; set[5][2][1]=12'h00; set[5][3][1]=12'h00; set[5][4][1]=12'hff; 
	   set[6][0][1]=12'h00; set[6][1][1]=12'h00; set[6][2][1]=12'h00; set[6][3][1]=12'h00; set[6][4][1]=12'hff; 
	   set[7][0][1]=12'h00; set[7][1][1]=12'h00; set[7][2][1]=12'h00; set[7][3][1]=12'h00; set[7][4][1]=12'hff;
	   // num2
	   set[0][0][2]=12'hff; set[0][1][2]=12'hff; set[0][2][2]=12'hff; set[0][3][2]=12'hff; set[0][4][2]=12'hff; 
	   set[1][0][2]=12'h00; set[1][1][2]=12'h00; set[1][2][2]=12'h00; set[1][3][2]=12'h00; set[1][4][2]=12'hff; 
	   set[2][0][2]=12'h00; set[2][1][2]=12'h00; set[2][2][2]=12'h00; set[2][3][2]=12'h00; set[2][4][2]=12'hff; 
	   set[3][0][2]=12'hff; set[3][1][2]=12'hff; set[3][2][2]=12'hff; set[3][3][2]=12'hff; set[3][4][2]=12'hff; 
	   set[4][0][2]=12'hff; set[4][1][2]=12'h00; set[4][2][2]=12'h00; set[4][3][2]=12'h00; set[4][4][2]=12'h00; 
	   set[5][0][2]=12'hff; set[5][1][2]=12'h00; set[5][2][2]=12'h00; set[5][3][2]=12'h00; set[5][4][2]=12'h00; 
	   set[6][0][2]=12'hff; set[6][1][2]=12'h00; set[6][2][2]=12'h00; set[6][3][2]=12'h00; set[6][4][2]=12'h00; 
	   set[7][0][2]=12'hff; set[7][1][2]=12'hff; set[7][2][2]=12'hff; set[7][3][2]=12'hff; set[7][4][2]=12'hff; 
	   // num3
	   set[0][0][3]=12'hff; set[0][1][3]=12'hff; set[0][2][3]=12'hff; set[0][3][3]=12'hff; set[0][4][3]=12'hff; 
	   set[1][0][3]=12'h00; set[1][1][3]=12'h00; set[1][2][3]=12'h00; set[1][3][3]=12'h00; set[1][4][3]=12'hff; 
	   set[2][0][3]=12'h00; set[2][1][3]=12'h00; set[2][2][3]=12'h00; set[2][3][3]=12'h00; set[2][4][3]=12'hff; 
	   set[3][0][3]=12'hff; set[3][1][3]=12'hff; set[3][2][3]=12'hff; set[3][3][3]=12'hff; set[3][4][3]=12'hff; 
	   set[4][0][3]=12'h00; set[4][1][3]=12'h00; set[4][2][3]=12'h00; set[4][3][3]=12'h00; set[4][4][3]=12'hff; 
	   set[5][0][3]=12'h00; set[5][1][3]=12'h00; set[5][2][3]=12'h00; set[5][3][3]=12'h00; set[5][4][3]=12'hff; 
	   set[6][0][3]=12'h00; set[6][1][3]=12'h00; set[6][2][3]=12'h00; set[6][3][3]=12'h00; set[6][4][3]=12'hff; 
	   set[7][0][3]=12'hff; set[7][1][3]=12'hff; set[7][2][3]=12'hff; set[7][3][3]=12'hff; set[7][4][3]=12'hff; 
	   // num4
	   set[0][0][4]=12'hff; set[0][1][4]=12'h00; set[0][2][4]=12'h00; set[0][3][4]=12'h00; set[0][4][4]=12'hff; 
	   set[1][0][4]=12'hff; set[1][1][4]=12'h00; set[1][2][4]=12'h00; set[1][3][4]=12'h00; set[1][4][4]=12'hff; 
	   set[2][0][4]=12'hff; set[2][1][4]=12'h00; set[2][2][4]=12'h00; set[2][3][4]=12'h00; set[2][4][4]=12'hff; 
	   set[3][0][4]=12'hff; set[3][1][4]=12'hff; set[3][2][4]=12'hff; set[3][3][4]=12'hff; set[3][4][4]=12'hff; 
	   set[4][0][4]=12'h00; set[4][1][4]=12'h00; set[4][2][4]=12'h00; set[4][3][4]=12'h00; set[4][4][4]=12'hff; 
	   set[5][0][4]=12'h00; set[5][1][4]=12'h00; set[5][2][4]=12'h00; set[5][3][4]=12'h00; set[5][4][4]=12'hff; 
	   set[6][0][4]=12'h00; set[6][1][4]=12'h00; set[6][2][4]=12'h00; set[6][3][4]=12'h00; set[6][4][4]=12'hff; 
	   set[7][0][4]=12'h00; set[7][1][4]=12'h00; set[7][2][4]=12'h00; set[7][3][4]=12'h00; set[7][4][4]=12'hff; 
	   // num5
	   set[0][0][5]=12'hff; set[0][1][5]=12'hff; set[0][2][5]=12'hff; set[0][3][5]=12'hff; set[0][4][5]=12'hff; 
	   set[1][0][5]=12'hff; set[1][1][5]=12'h00; set[1][2][5]=12'h00; set[1][3][5]=12'h00; set[1][4][5]=12'h00; 
	   set[2][0][5]=12'hff; set[2][1][5]=12'h00; set[2][2][5]=12'h00; set[2][3][5]=12'h00; set[2][4][5]=12'h00; 
	   set[3][0][5]=12'hff; set[3][1][5]=12'hff; set[3][2][5]=12'hff; set[3][3][5]=12'hff; set[3][4][5]=12'hff; 
	   set[4][0][5]=12'h00; set[4][1][5]=12'h00; set[4][2][5]=12'h00; set[4][3][5]=12'h00; set[4][4][5]=12'hff; 
	   set[5][0][5]=12'h00; set[5][1][5]=12'h00; set[5][2][5]=12'h00; set[5][3][5]=12'h00; set[5][4][5]=12'hff; 
	   set[6][0][5]=12'h00; set[6][1][5]=12'h00; set[6][2][5]=12'h00; set[6][3][5]=12'h00; set[6][4][5]=12'hff; 
	   set[7][0][5]=12'hff; set[7][1][5]=12'hff; set[7][2][5]=12'hff; set[7][3][5]=12'hff; set[7][4][5]=12'hff; 
	   // num6
	   set[0][0][6]=12'hff; set[0][1][6]=12'hff; set[0][2][6]=12'hff; set[0][3][6]=12'hff; set[0][4][6]=12'hff; 
	   set[1][0][6]=12'hff; set[1][1][6]=12'h00; set[1][2][6]=12'h00; set[1][3][6]=12'h00; set[1][4][6]=12'h00; 
	   set[2][0][6]=12'hff; set[2][1][6]=12'h00; set[2][2][6]=12'h00; set[2][3][6]=12'h00; set[2][4][6]=12'h00; 
	   set[3][0][6]=12'hff; set[3][1][6]=12'hff; set[3][2][6]=12'hff; set[3][3][6]=12'hff; set[3][4][6]=12'hff; 
	   set[4][0][6]=12'hff; set[4][1][6]=12'h00; set[4][2][6]=12'h00; set[4][3][6]=12'h00; set[4][4][6]=12'hff; 
	   set[5][0][6]=12'hff; set[5][1][6]=12'h00; set[5][2][6]=12'h00; set[5][3][6]=12'h00; set[5][4][6]=12'hff; 
	   set[6][0][6]=12'hff; set[6][1][6]=12'h00; set[6][2][6]=12'h00; set[6][3][6]=12'h00; set[6][4][6]=12'hff; 
	   set[7][0][6]=12'hff; set[7][1][6]=12'hff; set[7][2][6]=12'hff; set[7][3][6]=12'hff; set[7][4][6]=12'hff; 
	   // num7
	   set[0][0][7]=12'hff; set[0][1][7]=12'hff; set[0][2][7]=12'hff; set[0][3][7]=12'hff; set[0][4][7]=12'hff; 
	   set[1][0][7]=12'hff; set[1][1][7]=12'h00; set[1][2][7]=12'h00; set[1][3][7]=12'h00; set[1][4][7]=12'hff; 
	   set[2][0][7]=12'hff; set[2][1][7]=12'h00; set[2][2][7]=12'h00; set[2][3][7]=12'h00; set[2][4][7]=12'hff; 
	   set[3][0][7]=12'h00; set[3][1][7]=12'h00; set[3][2][7]=12'h00; set[3][3][7]=12'h00; set[3][4][7]=12'hff; 
	   set[4][0][7]=12'h00; set[4][1][7]=12'h00; set[4][2][7]=12'h00; set[4][3][7]=12'h00; set[4][4][7]=12'hff; 
	   set[5][0][7]=12'h00; set[5][1][7]=12'h00; set[5][2][7]=12'h00; set[5][3][7]=12'h00; set[5][4][7]=12'hff; 
	   set[6][0][7]=12'h00; set[6][1][7]=12'h00; set[6][2][7]=12'h00; set[6][3][7]=12'h00; set[6][4][7]=12'hff; 
	   set[7][0][7]=12'h00; set[7][1][7]=12'h00; set[7][2][7]=12'h00; set[7][3][7]=12'h00; set[7][4][7]=12'hff; 
	   // num8
	   set[0][0][8]=12'hff; set[0][1][8]=12'hff; set[0][2][8]=12'hff; set[0][3][8]=12'hff; set[0][4][8]=12'hff; 
	   set[1][0][8]=12'hff; set[1][1][8]=12'h00; set[1][2][8]=12'h00; set[1][3][8]=12'h00; set[1][4][8]=12'hff; 
	   set[2][0][8]=12'hff; set[2][1][8]=12'h00; set[2][2][8]=12'h00; set[2][3][8]=12'h00; set[2][4][8]=12'hff; 
	   set[3][0][8]=12'hff; set[3][1][8]=12'hff; set[3][2][8]=12'hff; set[3][3][8]=12'hff; set[3][4][8]=12'hff; 
	   set[4][0][8]=12'hff; set[4][1][8]=12'h00; set[4][2][8]=12'h00; set[4][3][8]=12'h00; set[4][4][8]=12'hff; 
	   set[5][0][8]=12'hff; set[5][1][8]=12'h00; set[5][2][8]=12'h00; set[5][3][8]=12'h00; set[5][4][8]=12'hff; 
	   set[6][0][8]=12'hff; set[6][1][8]=12'h00; set[6][2][8]=12'h00; set[6][3][8]=12'h00; set[6][4][8]=12'hff; 
	   set[7][0][8]=12'hff; set[7][1][8]=12'hff; set[7][2][8]=12'hff; set[7][3][8]=12'hff; set[7][4][8]=12'hff; 
	   // num9
	   set[0][0][9]=12'hff; set[0][1][9]=12'hff; set[0][2][9]=12'hff; set[0][3][9]=12'hff; set[0][4][9]=12'hff; 
	   set[1][0][9]=12'hff; set[1][1][9]=12'h00; set[1][2][9]=12'h00; set[1][3][9]=12'h00; set[1][4][9]=12'hff; 
	   set[2][0][9]=12'hff; set[2][1][9]=12'h00; set[2][2][9]=12'h00; set[2][3][9]=12'h00; set[2][4][9]=12'hff; 
	   set[3][0][9]=12'hff; set[3][1][9]=12'hff; set[3][2][9]=12'hff; set[3][3][9]=12'hff; set[3][4][9]=12'hff; 
	   set[4][0][9]=12'h00; set[4][1][9]=12'h00; set[4][2][9]=12'h00; set[4][3][9]=12'h00; set[4][4][9]=12'hff; 
	   set[5][0][9]=12'h00; set[5][1][9]=12'h00; set[5][2][9]=12'h00; set[5][3][9]=12'h00; set[5][4][9]=12'hff; 
	   set[6][0][9]=12'h00; set[6][1][9]=12'h00; set[6][2][9]=12'h00; set[6][3][9]=12'h00; set[6][4][9]=12'hff; 
	   set[7][0][9]=12'hff; set[7][1][9]=12'hff; set[7][2][9]=12'hff; set[7][3][9]=12'hff; set[7][4][9]=12'hff; 
	   // 10 -
	   set[0][0][10]=12'h00; set[0][1][10]=12'h00; set[0][2][10]=12'h00; set[0][3][10]=12'h00; set[0][4][10]=12'h00; 
	   set[1][0][10]=12'h00; set[1][1][10]=12'h00; set[1][2][10]=12'h00; set[1][3][10]=12'h00; set[1][4][10]=12'h00; 
	   set[2][0][10]=12'h00; set[2][1][10]=12'h00; set[2][2][10]=12'h00; set[2][3][10]=12'h00; set[2][4][10]=12'h00; 
	   set[3][0][10]=12'hff; set[3][1][10]=12'hff; set[3][2][10]=12'hff; set[3][3][10]=12'hff; set[3][4][10]=12'hff; 
	   set[4][0][10]=12'h00; set[4][1][10]=12'h00; set[4][2][10]=12'h00; set[4][3][10]=12'h00; set[4][4][10]=12'h00; 
	   set[5][0][10]=12'h00; set[5][1][10]=12'h00; set[5][2][10]=12'h00; set[5][3][10]=12'h00; set[5][4][10]=12'h00; 
	   set[6][0][10]=12'h00; set[6][1][10]=12'h00; set[6][2][10]=12'h00; set[6][3][10]=12'h00; set[6][4][10]=12'h00; 
	   set[7][0][10]=12'h00; set[7][1][10]=12'h00; set[7][2][10]=12'h00; set[7][3][10]=12'h00; set[7][4][10]=12'h00; 
	   // 11 N
	   set[0][0][11]=12'hff; set[0][1][11]=12'h00; set[0][2][11]=12'h00; set[0][3][11]=12'h00; set[0][4][11]=12'hff; 
	   set[1][0][11]=12'hff; set[1][1][11]=12'hff; set[1][2][11]=12'h00; set[1][3][11]=12'h00; set[1][4][11]=12'hff; 
	   set[2][0][11]=12'hff; set[2][1][11]=12'h00; set[2][2][11]=12'hff; set[2][3][11]=12'h00; set[2][4][11]=12'hff; 
	   set[3][0][11]=12'hff; set[3][1][11]=12'h00; set[3][2][11]=12'hff; set[3][3][11]=12'h00; set[3][4][11]=12'hff; 
	   set[4][0][11]=12'hff; set[4][1][11]=12'h00; set[4][2][11]=12'h00; set[4][3][11]=12'hff; set[4][4][11]=12'hff; 
	   set[5][0][11]=12'hff; set[5][1][11]=12'h00; set[5][2][11]=12'h00; set[5][3][11]=12'h00; set[5][4][11]=12'hff; 
	   set[6][0][11]=12'hff; set[6][1][11]=12'h00; set[6][2][11]=12'h00; set[6][3][11]=12'h00; set[6][4][11]=12'hff; 
	   set[7][0][11]=12'hff; set[7][1][11]=12'h00; set[7][2][11]=12'h00; set[7][3][11]=12'h00; set[7][4][11]=12'hff; 
	   // 12 a
	   set[0][0][12]=12'h00; set[0][1][12]=12'h00; set[0][2][12]=12'h00; set[0][3][12]=12'h00; set[0][4][12]=12'h00; 
	   set[1][0][12]=12'h00; set[1][1][12]=12'h00; set[1][2][12]=12'h00; set[1][3][12]=12'h00; set[1][4][12]=12'h00; 
	   set[2][0][12]=12'h00; set[2][1][12]=12'h00; set[2][2][12]=12'h00; set[2][3][12]=12'h00; set[2][4][12]=12'h00; 
	   set[3][0][12]=12'hff; set[3][1][12]=12'hff; set[3][2][12]=12'hff; set[3][3][12]=12'hff; set[3][4][12]=12'h00; 
	   set[4][0][12]=12'hff; set[4][1][12]=12'h00; set[4][2][12]=12'h00; set[4][3][12]=12'hff; set[4][4][12]=12'h00; 
	   set[5][0][12]=12'hff; set[5][1][12]=12'h00; set[5][2][12]=12'h00; set[5][3][12]=12'hff; set[5][4][12]=12'h00; 
	   set[6][0][12]=12'hff; set[6][1][12]=12'h00; set[6][2][12]=12'h00; set[6][3][12]=12'hff; set[6][4][12]=12'h00; 
	   set[7][0][12]=12'hff; set[7][1][12]=12'hff; set[7][2][12]=12'hff; set[7][3][12]=12'hff; set[7][4][12]=12'hff; 
	   // 13 i
	   set[0][0][13]=12'h00; set[0][1][13]=12'h00; set[0][2][13]=12'h00; set[0][3][13]=12'h00; set[0][4][13]=12'h00; 
	   set[1][0][13]=12'h00; set[1][1][13]=12'h00; set[1][2][13]=12'h00; set[1][3][13]=12'h00; set[1][4][13]=12'h00; 
	   set[2][0][13]=12'h00; set[2][1][13]=12'h00; set[2][2][13]=12'h00; set[2][3][13]=12'h00; set[2][4][13]=12'h00; 
	   set[3][0][13]=12'h00; set[3][1][13]=12'h00; set[3][2][13]=12'hff; set[3][3][13]=12'h00; set[3][4][13]=12'h00; 
	   set[4][0][13]=12'h00; set[4][1][13]=12'h00; set[4][2][13]=12'h00; set[4][3][13]=12'h00; set[4][4][13]=12'h00; 
	   set[5][0][13]=12'h00; set[5][1][13]=12'h00; set[5][2][13]=12'hff; set[5][3][13]=12'h00; set[5][4][13]=12'h00; 
	   set[6][0][13]=12'h00; set[6][1][13]=12'h00; set[6][2][13]=12'hff; set[6][3][13]=12'h00; set[6][4][13]=12'h00; 
	   set[7][0][13]=12'h00; set[7][1][13]=12'h00; set[7][2][13]=12'hff; set[7][3][13]=12'h00; set[7][4][13]=12'h00; 
	    
	   /*	   
	   set[0][0][0]=12'h00; set[0][1][0]=12'h00; set[0][2][0]=12'h00; set[0][3][0]=12'h00; set[0][4][0]=12'h00; 
	   set[1][0][0]=12'h00; set[1][1][0]=12'h00; set[1][2][0]=12'h00; set[1][3][0]=12'h00; set[1][4][0]=12'h00; 
	   set[2][0][0]=12'h00; set[2][1][0]=12'h00; set[2][2][0]=12'h00; set[2][3][0]=12'h00; set[2][4][0]=12'h00; 
	   set[3][0][0]=12'h00; set[3][1][0]=12'h00; set[3][2][0]=12'h00; set[3][3][0]=12'h00; set[3][4][0]=12'h00; 
	   set[4][0][0]=12'h00; set[4][1][0]=12'h00; set[4][2][0]=12'h00; set[4][3][0]=12'h00; set[4][4][0]=12'h00; 
	   set[5][0][0]=12'h00; set[5][1][0]=12'h00; set[5][2][0]=12'h00; set[5][3][0]=12'h00; set[5][4][0]=12'h00; 
	   set[6][0][0]=12'h00; set[6][1][0]=12'h00; set[6][2][0]=12'h00; set[6][3][0]=12'h00; set[6][4][0]=12'h00; 
	   set[7][0][0]=12'h00; set[7][1][0]=12'h00; set[7][2][0]=12'h00; set[7][3][0]=12'h00; set[7][4][0]=12'h00; 
	   */
	end
	
	always @(answer4 or answer3 or answer2 or answer1 or answer0) begin	   
	   // answer4
	   // row 0
	   screen[8][2] = set[0][0][answer4];
	   screen[8][3] = set[0][1][answer4];
	   screen[8][4] = set[0][2][answer4];
	   screen[8][5] = set[0][3][answer4];
	   screen[8][6] = set[0][4][answer4];
	   // row 1
	   screen[9][2] = set[1][0][answer4];
	   screen[9][3] = set[1][1][answer4];
	   screen[9][4] = set[1][2][answer4];
	   screen[9][5] = set[1][3][answer4];
	   screen[9][6] = set[1][4][answer4];
	   // row 2
	   screen[10][2] = set[2][0][answer4];
	   screen[10][3] = set[2][1][answer4];
	   screen[10][4] = set[2][2][answer4];
	   screen[10][5] = set[2][3][answer4];
	   screen[10][6] = set[2][4][answer4];
	   // row 3
	   screen[11][2] = set[3][0][answer4];
	   screen[11][3] = set[3][1][answer4];
	   screen[11][4] = set[3][2][answer4];
	   screen[11][5] = set[3][3][answer4];
	   screen[11][6] = set[3][4][answer4];
	   // row 4
	   screen[12][2] = set[4][0][answer4];
	   screen[12][3] = set[4][1][answer4];
	   screen[12][4] = set[4][2][answer4];
	   screen[12][5] = set[4][3][answer4];
	   screen[12][6] = set[4][4][answer4];
	   // row 5
	   screen[13][2] = set[5][0][answer4];
	   screen[13][3] = set[5][1][answer4];
	   screen[13][4] = set[5][2][answer4];
	   screen[13][5] = set[5][3][answer4];
	   screen[13][6] = set[5][4][answer4];
	   // row 6
	   screen[14][2] = set[6][0][answer4];
	   screen[14][3] = set[6][1][answer4];
	   screen[14][4] = set[6][2][answer4];
	   screen[14][5] = set[6][3][answer4];
	   screen[14][6] = set[6][4][answer4];
	   // row 7
	   screen[15][2] = set[7][0][answer4];
	   screen[15][3] = set[7][1][answer4];
	   screen[15][4] = set[7][2][answer4];
	   screen[15][5] = set[7][3][answer4];
	   screen[15][6] = set[7][4][answer4];
	   // answer3
	   // row 0
	   screen[8][8] = set[0][0][answer3];
	   screen[8][9] = set[0][1][answer3];
	   screen[8][10] = set[0][2][answer3];
	   screen[8][11] = set[0][3][answer3];
	   screen[8][12] = set[0][4][answer3];
	   // row 1
	   screen[9][8] = set[1][0][answer3];
	   screen[9][9] = set[1][1][answer3];
	   screen[9][10] = set[1][2][answer3];
	   screen[9][11] = set[1][3][answer3];
	   screen[9][12] = set[1][4][answer3];
	   // row 2
	   screen[10][8] = set[2][0][answer3];
	   screen[10][9] = set[2][1][answer3];
	   screen[10][10] = set[2][2][answer3];
	   screen[10][11] = set[2][3][answer3];
	   screen[10][12] = set[2][4][answer3];
	   // row 3
	   screen[11][8] = set[3][0][answer3];
	   screen[11][9] = set[3][1][answer3];
	   screen[11][10] = set[3][2][answer3];
	   screen[11][11] = set[3][3][answer3];
	   screen[11][12] = set[3][4][answer3];
	   // row 4
	   screen[12][8] = set[4][0][answer3];
	   screen[12][9] = set[4][1][answer3];
	   screen[12][10] = set[4][2][answer3];
	   screen[12][11] = set[4][3][answer3];
	   screen[12][12] = set[4][4][answer3];
	   // row 5
	   screen[13][8] = set[5][0][answer3];
	   screen[13][9] = set[5][1][answer3];
	   screen[13][10] = set[5][2][answer3];
	   screen[13][11] = set[5][3][answer3];
	   screen[13][12] = set[5][4][answer3];
	   // row 6
	   screen[14][8] = set[6][0][answer3];
	   screen[14][9] = set[6][1][answer3];
	   screen[14][10] = set[6][2][answer3];
	   screen[14][11] = set[6][3][answer3];
	   screen[14][12] = set[6][4][answer3];
	   // row 7
	   screen[15][8] = set[7][0][answer3];
	   screen[15][9] = set[7][1][answer3];
	   screen[15][10] = set[7][2][answer3];
	   screen[15][11] = set[7][3][answer3];
	   screen[15][12] = set[7][4][answer3];
	   // answer2
	   // row 0
	   screen[8][14] = set[0][0][answer2];
	   screen[8][15] = set[0][1][answer2];
	   screen[8][16] = set[0][2][answer2];
	   screen[8][17] = set[0][3][answer2];
	   screen[8][18] = set[0][4][answer2];
	   // row 1
	   screen[9][14] = set[1][0][answer2];
	   screen[9][15] = set[1][1][answer2];
	   screen[9][16] = set[1][2][answer2];
	   screen[9][17] = set[1][3][answer2];
	   screen[9][18] = set[1][4][answer2];
	   // row 2
	   screen[10][14] = set[2][0][answer2];
	   screen[10][15] = set[2][1][answer2];
	   screen[10][16] = set[2][2][answer2];
	   screen[10][17] = set[2][3][answer2];
	   screen[10][18] = set[2][4][answer2];
	   // row 3
	   screen[11][14] = set[3][0][answer2];
	   screen[11][15] = set[3][1][answer2];
	   screen[11][16] = set[3][2][answer2];
	   screen[11][17] = set[3][3][answer2];
	   screen[11][18] = set[3][4][answer2];
	   // row 4
	   screen[12][14] = set[4][0][answer2];
	   screen[12][15] = set[4][1][answer2];
	   screen[12][16] = set[4][2][answer2];
	   screen[12][17] = set[4][3][answer2];
	   screen[12][18] = set[4][4][answer2];
	   // row 5
	   screen[13][14] = set[5][0][answer2];
	   screen[13][15] = set[5][1][answer2];
	   screen[13][16] = set[5][2][answer2];
	   screen[13][17] = set[5][3][answer2];
	   screen[13][18] = set[5][4][answer2];
	   // row 6
	   screen[14][14] = set[6][0][answer2];
	   screen[14][15] = set[6][1][answer2];
	   screen[14][16] = set[6][2][answer2];
	   screen[14][17] = set[6][3][answer2];
	   screen[14][18] = set[6][4][answer2];
	   // row 7
	   screen[15][14] = set[7][0][answer2];
	   screen[15][15] = set[7][1][answer2];
	   screen[15][16] = set[7][2][answer2];
	   screen[15][17] = set[7][3][answer2];
	   screen[15][18] = set[7][4][answer2];
	   // answer1
	   // row 0
	   screen[8][20] = set[0][0][answer1];
	   screen[8][21] = set[0][1][answer1];
	   screen[8][22] = set[0][2][answer1];
	   screen[8][23] = set[0][3][answer1];
	   screen[8][24] = set[0][4][answer1];
	   // row 1
	   screen[9][20] = set[1][0][answer1];
	   screen[9][21] = set[1][1][answer1];
	   screen[9][22] = set[1][2][answer1];
	   screen[9][23] = set[1][3][answer1];
	   screen[9][24] = set[1][4][answer1];
	   // row 2
	   screen[10][20] = set[2][0][answer1];
	   screen[10][21] = set[2][1][answer1];
	   screen[10][22] = set[2][2][answer1];
	   screen[10][23] = set[2][3][answer1];
	   screen[10][24] = set[2][4][answer1];
	   // row 3
	   screen[11][20] = set[3][0][answer1];
	   screen[11][21] = set[3][1][answer1];
	   screen[11][22] = set[3][2][answer1];
	   screen[11][23] = set[3][3][answer1];
	   screen[11][24] = set[3][4][answer1];
	   // row 4
	   screen[12][20] = set[4][0][answer1];
	   screen[12][21] = set[4][1][answer1];
	   screen[12][22] = set[4][2][answer1];
	   screen[12][23] = set[4][3][answer1];
	   screen[12][24] = set[4][4][answer1];
	   // row 5
	   screen[13][20] = set[5][0][answer1];
	   screen[13][21] = set[5][1][answer1];
	   screen[13][22] = set[5][2][answer1];
	   screen[13][23] = set[5][3][answer1];
	   screen[13][24] = set[5][4][answer1];
	   // row 6
	   screen[14][20] = set[6][0][answer1];
	   screen[14][21] = set[6][1][answer1];
	   screen[14][22] = set[6][2][answer1];
	   screen[14][23] = set[6][3][answer1];
	   screen[14][24] = set[6][4][answer1];
	   // row 7
	   screen[15][20] = set[7][0][answer1];
	   screen[15][21] = set[7][1][answer1];
	   screen[15][22] = set[7][2][answer1];
	   screen[15][23] = set[7][3][answer1];
	   screen[15][24] = set[7][4][answer1];
	   // answer0
	   // row 0
	   screen[8][26] = set[0][0][answer0];
	   screen[8][27] = set[0][1][answer0];
	   screen[8][28] = set[0][2][answer0];
	   screen[8][29] = set[0][3][answer0];
	   screen[8][30] = set[0][4][answer0];
	   // row 1
	   screen[9][26] = set[1][0][answer0];
	   screen[9][27] = set[1][1][answer0];
	   screen[9][28] = set[1][2][answer0];
	   screen[9][29] = set[1][3][answer0];
	   screen[9][30] = set[1][4][answer0];
	   // row 2
	   screen[10][26] = set[2][0][answer0];
	   screen[10][27] = set[2][1][answer0];
	   screen[10][28] = set[2][2][answer0];
	   screen[10][29] = set[2][3][answer0];
	   screen[10][30] = set[2][4][answer0];
	   // row 3
	   screen[11][26] = set[3][0][answer0];
	   screen[11][27] = set[3][1][answer0];
	   screen[11][28] = set[3][2][answer0];
	   screen[11][29] = set[3][3][answer0];
	   screen[11][30] = set[3][4][answer0];
	   // row 4
	   screen[12][26] = set[4][0][answer0];
	   screen[12][27] = set[4][1][answer0];
	   screen[12][28] = set[4][2][answer0];
	   screen[12][29] = set[4][3][answer0];
	   screen[12][30] = set[4][4][answer0];
	   // row 5
	   screen[13][26] = set[5][0][answer0];
	   screen[13][27] = set[5][1][answer0];
	   screen[13][28] = set[5][2][answer0];
	   screen[13][29] = set[5][3][answer0];
	   screen[13][30] = set[5][4][answer0];
	   // row 6
	   screen[14][26] = set[6][0][answer0];
	   screen[14][27] = set[6][1][answer0];
	   screen[14][28] = set[6][2][answer0];
	   screen[14][29] = set[6][3][answer0];
	   screen[14][30] = set[6][4][answer0];
	   // row 7
	   screen[15][26] = set[7][0][answer0];
	   screen[15][27] = set[7][1][answer0];
	   screen[15][28] = set[7][2][answer0];
	   screen[15][29] = set[7][3][answer0];
	   screen[15][30] = set[7][4][answer0];
	end
	
	always @(posedge p_tick) begin
	   rgb_reg[11:0] = screen[y/20][x/20];
	end
		        
//	output
	assign rgb = (video_on) ? rgb_reg : 12'b0;
endmodule