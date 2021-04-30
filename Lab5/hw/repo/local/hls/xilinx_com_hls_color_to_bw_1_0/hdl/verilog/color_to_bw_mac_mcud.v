// ==============================================================
// File generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2017.4
// Copyright (C) 1986-2017 Xilinx, Inc. All Rights Reserved.
// 
// ==============================================================

`timescale 1 ns / 1 ps

module color_to_bw_mac_mcud_DSP48_1(
    input  [8 - 1:0] in0,
    input  [20 - 1:0] in1,
    input  [29 - 1:0] in2,
    output [29 - 1:0]  dout);

wire signed [25 - 1:0]     a;
wire signed [18 - 1:0]     b;
wire signed [48 - 1:0]     c;
wire signed [43 - 1:0]     m;
wire signed [48 - 1:0]     p;

assign a  = $unsigned(in1);
assign b  = $unsigned(in0);
assign c  = $unsigned(in2);

assign m  = a * b;
assign p  = m + c;

assign dout = p;

endmodule

`timescale 1 ns / 1 ps
module color_to_bw_mac_mcud(
    din0,
    din1,
    din2,
    dout);

parameter ID = 32'd1;
parameter NUM_STAGE = 32'd1;
parameter din0_WIDTH = 32'd1;
parameter din1_WIDTH = 32'd1;
parameter din2_WIDTH = 32'd1;
parameter dout_WIDTH = 32'd1;
input[din0_WIDTH - 1:0] din0;
input[din1_WIDTH - 1:0] din1;
input[din2_WIDTH - 1:0] din2;
output[dout_WIDTH - 1:0] dout;



color_to_bw_mac_mcud_DSP48_1 color_to_bw_mac_mcud_DSP48_1_U(
    .in0( din0 ),
    .in1( din1 ),
    .in2( din2 ),
    .dout( dout ));

endmodule

