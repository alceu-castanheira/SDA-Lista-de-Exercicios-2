// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Tue Oct 13 14:18:56 2020
// Host        : LAPTOP-1MDN7U1C running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/alceu/Documents/Doutorado/SDA/SDA_lista_exercicios_2/SDA_lista_2_ex3/SDA_lista_2_ex3.srcs/sources_1/ip/vio_0/vio_0_stub.v
// Design      : vio_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2018.3" *)
module vio_0(clk, probe_out0, probe_out1, probe_out2, 
  probe_out3, probe_out4, probe_out5)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_out0[0:0],probe_out1[0:0],probe_out2[0:0],probe_out3[0:0],probe_out4[0:0],probe_out5[0:0]" */;
  input clk;
  output [0:0]probe_out0;
  output [0:0]probe_out1;
  output [0:0]probe_out2;
  output [0:0]probe_out3;
  output [0:0]probe_out4;
  output [0:0]probe_out5;
endmodule
