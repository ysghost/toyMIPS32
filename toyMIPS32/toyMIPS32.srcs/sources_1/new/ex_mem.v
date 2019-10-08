`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yan
// 
// Create Date: 2019/10/04 22:42:16
// Design Name: 
// Module Name: ex_mem
// Project Name: MIPS32
// Target Devices: 
// Tool Versions: 
// Description: execution to memory access (ex_mem)
//   The ex_mem aims to store the execution results in the execution process,
//   which is passed to the memory access process in the next cycle   
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Add "Operand Forwarding" 
// Additional Comments:
//   ex_mem is sequential logic @ pipeline Stage 4
// Revision 0.02 - Add "Operand Forwarding" 
//   Add ex_hilo_wr_en, ex_hi_wr_data, ex_lo_wr_data,
//       mem_hilo_wr_en, mem_hi_wr_data, mem_lo_wr_data
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module ex_mem(
    input  wire                    clk,
    input  wire                    rst,
    input  wire                    ex_reg_wr_en,  
    input  wire [`RegAddrBus-1:0]  ex_reg_wr_addr,
    input  wire [`RegBus-1:0]      ex_reg_wr_data,
    input  wire                    ex_hilo_wr_en,
    input  wire [`RegBus-1:0]      ex_hi_wr_data,
    input  wire [`RegBus-1:0]      ex_lo_wr_data,
    output reg                     mem_reg_wr_en,  
    output reg  [`RegAddrBus-1:0]  mem_reg_wr_addr,
    output reg  [`RegBus-1:0]      mem_reg_wr_data,
    output reg                     mem_hilo_wr_en,
    output reg  [`RegBus-1:0]      mem_hi_wr_data,
    output reg  [`RegBus-1:0]      mem_lo_wr_data
    );

    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            mem_reg_wr_en     <= `WriteDisable   ;
            mem_reg_wr_addr   <= `NOPRegAddr     ;
            mem_reg_wr_data   <= `ZeroWord       ;
            mem_hilo_wr_en    <= `WriteDisable   ;
            mem_hi_wr_data    <= `ZeroWord       ;
            mem_lo_wr_data    <= `ZeroWord       ;
        end else begin
            mem_reg_wr_en     <= ex_reg_wr_en    ;
            mem_reg_wr_addr   <= ex_reg_wr_addr  ;
            mem_reg_wr_data   <= ex_reg_wr_data  ;
            mem_hilo_wr_en    <= ex_hilo_wr_en   ;
            mem_hi_wr_data    <= ex_hi_wr_data   ;
            mem_lo_wr_data    <= ex_lo_wr_data   ;
        end // if(rst) else
    end //always
endmodule
