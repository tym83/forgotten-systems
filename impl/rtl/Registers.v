`timescale 1ns / 1ps
// register file, triple-port -- ПОВЕДЕНЧЕСКАЯ ЗАМЕНА примитивов Xilinx RAM16X1D.
//
// Оригинал (Registers.xilinx.v.orig, 1.2.2018) построен на 64 примитивах RAM16X1D
// распределённой памяти Xilinx: запись синхронная по WCLK при WE, чтение асинхронное
// (SPO по адресу A, DPO по адресу DPRA). Здесь та же семантика на поведенческом Verilog,
// портируемая в Verilator / yosys / любой ASIC-поток.
//
// Интерфейс идентичен оригиналу -- drop-in.
//
// ⚠ ДОЛГ для пути в кремний: RAM16X1D имел .INIT(16'h0000), то есть регистровый файл
// обнулялся битстримом. В кремнии этого не будет. Порта сброса в интерфейсе нет;
// добавление потребует правки RISC5.v. Пока -- initial для симуляции.

module Registers(
  input clk, wr,
  input [3:0] rno0, rno1, rno2,
  input [31:0] din,
  output [31:0] dout0, dout1, dout2);

reg [31:0] R [0:15] /*verilator public*/;

integer k;
initial for (k = 0; k < 16; k = k + 1) R[k] = 32'b0;

always @(posedge clk) if (wr) R[rno0] <= din;

assign dout0 = R[rno0];
assign dout1 = R[rno1];
assign dout2 = R[rno2];

endmodule
