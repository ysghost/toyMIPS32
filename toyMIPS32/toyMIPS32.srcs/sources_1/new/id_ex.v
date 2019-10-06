`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yan
// 
// Create Date: 2019/10/04 20:25:02
// Design Name: 
// Module Name: id_ex
// Project Name: MIPS32
// Target Devices: 
// Tool Versions: 
// Description: instruction decode to execution
//   The id_ex aims to store the instruction in the instruction decode process,
//   which is passed to the execution process in the next cycle
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   id_ex is sequential logic @ pipeline Stage 3
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module id_ex(
    input  wire                    clk,
    input  wire                    rst,
    input  wire                    id_reg_wr_en,                 
    input  wire [`RegAddrBus-1:0]  id_reg_wr_addr,
    input  wire [`RegBus-1:0]      id_reg1,
    input  wire [`RegBus-1:0]      id_reg2,
    input  wire [`AluOpBus-1:0]    id_alu_op,
    input  wire [`AluSelBus-1:0]   id_alu_sel,
    output reg                     ex_reg_wr_en,                 
    output reg  [`RegAddrBus-1:0]  ex_reg_wr_addr,
    output reg  [`RegBus-1:0]      ex_reg1,
    output reg  [`RegBus-1:0]      ex_reg2,
    output reg  [`AluOpBus-1:0]    ex_alu_op,
    output reg  [`AluSelBus-1:0]   ex_alu_sel
    );

    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            ex_reg_wr_en    <= `WriteDisable  ;
            ex_reg_wr_addr  <= `NOPRegAddr    ;
            ex_reg1         <= `ZeroWord      ;
            ex_reg2         <= `ZeroWord      ;
            ex_alu_op       <= `EXE_NOP_OP    ;
            ex_alu_sel      <= `EXE_RES_NOP   ;
        end else begin
            ex_reg_wr_en    <= id_reg_wr_en   ;
            ex_reg_wr_addr  <= id_reg_wr_addr ;
            ex_reg1         <= id_reg1        ;
            ex_reg2         <= id_reg2        ;
            ex_alu_op       <= id_alu_op      ;
            ex_alu_sel      <= id_alu_sel     ;
        end        
    end

endmodule
