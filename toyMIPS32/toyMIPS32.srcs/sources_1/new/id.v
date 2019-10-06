`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yan
// 
// Create Date: 2019/10/04 15:58:39
// Design Name: 
// Module Name: id
// Project Name: MIPS32
// Target Devices: 
// Tool Versions: 
// Description: instruction decode (id)
//   id aims to decode the instruction
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Add "Operand Forwarding" 
// Additional Comments:
//   id is combinational logic @ pipeline Stage 2
//   3 types of instruction:
//                 31-26(6) | 25-21(5) | 20-16(5) | 15-11(5) | 10-6(5) | 5-0(6)
//     1) R-type:      op   |    rs    |    rt    |   rd     |    sa   |  func
//     2) I-type:      op   |    rs    |    rt    |        immediate(16)
//     3) J-type:      op   |                    address(26)
//
//   Operand Forwarding
//   We send the result of the calculation directly from the generation (ex/mem)
//   to id to avoid RAW problems and pipeline stall.
//   CHANGES:
//     1. add input ex_reg_wr_en, ex_reg_wr_addr, ex_reg_wr_data
//     2. add input mem_reg_wr_en, mem_reg_wr_addr, mem_reg_wr_data
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module id(
    input wire                    rst,
    input wire [`InstAddrBus-1:0] pc,
    input wire [`InstBus-1:0]     inst,
    input wire [`RegBus-1:0]      reg_1_rd_data,
    input wire [`RegBus-1:0]      reg_2_rd_data,
    input wire                    ex_reg_wr_en,  //directly from ex output
    input wire [`RegAddrBus-1:0]  ex_reg_wr_addr, 
    input wire [`RegBus-1:0]      ex_reg_wr_data,
    input wire                    mem_reg_wr_en, //directly from mem output
    input wire [`RegAddrBus-1:0]  mem_reg_wr_addr,
    input wire [`RegBus-1:0]      mem_reg_wr_data,
    output reg                    reg_wr_en,
    output reg [`RegAddrBus-1:0]  reg_wr_addr,
    output reg                    reg_1_rd_en,
    output reg                    reg_2_rd_en,
    output reg [`RegAddrBus-1:0]  reg_1_rd_addr,
    output reg [`RegAddrBus-1:0]  reg_2_rd_addr,
    output reg [`RegBus-1:0]      reg1,
    output reg [`RegBus-1:0]      reg2,
    output reg [`AluOpBus-1:0]    alu_op,
    output reg [`AluSelBus-1:0]   alu_sel
    );

    //instruction
    wire [5:0] op = inst[31:26];
    wire [4:0] rs = inst[25:21];
    wire [4:0] rt = inst[20:16];
    //R-type
    wire [4:0] rd = inst[15:11];
    wire [4:0] sa = inst[10:6];
    wire [5:0] func = inst[5:0];
    //I-type
    wire [15:0] immediate = inst[15:0];
    //J-type
    wire [25:0] address = inst[25:0];

    //instruction valid
    reg inst_valid;

    //32 bit immediate
    reg [`RegBus-1:0] imme;

    //decode
    always @(*) begin
        if (rst == `RstEnable) begin
            inst_valid          = `InstValid        ;
            reg_wr_en           = `WriteDisable     ;
            reg_wr_addr         = `NOPRegAddr       ;
            reg_1_rd_en         = `ReadDisable      ;
            reg_1_rd_addr       = `NOPRegAddr       ;            
            reg_2_rd_en         = `ReadDisable      ;
            reg_2_rd_addr       = `NOPRegAddr       ;
            alu_op              = `EXE_NOP_OP       ;
            alu_sel             = `EXE_RES_NOP      ;
            imme                = `ZeroWord         ;
        end else begin
            // default values
            inst_valid          = `InstInvalid      ;
            reg_wr_en           = `WriteDisable     ;
            reg_wr_addr         = rt                ;
            reg_1_rd_en         = `ReadDisable      ;
            reg_1_rd_addr       = rs                ;            
            reg_2_rd_en         = `ReadDisable      ;
            reg_2_rd_addr       = rt                ;
            alu_op              = `EXE_NOP_OP       ;
            alu_sel             = `EXE_RES_NOP      ;
            imme                = `ZeroWord         ;

            case (op)
                `EXE_ORI: begin
                    reg_wr_en           = `WriteEnable      ;
                    reg_wr_addr         = rt                ;
                    reg_1_rd_en         = `ReadEnable       ;
                    reg_1_rd_addr       = rs                ;
                    reg_2_rd_en         = `ReadDisable      ;           
                    alu_op              = `EXE_ORI_OP       ;//FIX
                    alu_sel             = `EXE_RES_LOGIC    ;
                    imme                = {16'h0, immediate};         
                end //`EXE_ORI
                default: begin               
                
                end //default
            endcase //case (op)
        end //if else
    end //always

    /*Get data stored in reg_1*/
    always @(*) begin
        if (rst == `RstEnable) begin
            reg1 = `ZeroWord;
        end else if (reg_1_rd_en == `ReadEnable && ex_reg_wr_en == `WriteEnable
                        && reg_1_rd_addr == ex_reg_wr_addr) begin
            // If reg to be written by ex is the same as reg to be read by reg1
            reg1 = ex_reg_wr_data; 
        end else if (reg_1_rd_en == `ReadEnable && mem_reg_wr_en == `WriteEnable
                        && reg_1_rd_addr == mem_reg_wr_addr) begin
            // If reg to be written by mem is the same as reg to be read by reg1
            reg1 = mem_reg_wr_data; 
        end else if (reg_1_rd_en == `ReadEnable) begin
            //if rd active, sent reg_1_rd_data to reg1
            reg1 = reg_1_rd_data;
        end else if (reg_1_rd_en == `ReadDisable) begin
            //if rd inactive, sent imme to reg1
            reg1 = imme;
        end else begin
            reg1 = `ZeroWord;
        end
    end // always

    // /*Get data stored in reg_1*/
    // always @(*) begin
    //     if (rst == `RstEnable) begin
    //         reg1 = `ZeroWord;
    //     end else if (reg_1_rd_en == `ReadEnable) begin
    //         //if rd active, sent reg_1_rd_data to reg1
    //         reg1 = reg_1_rd_data;
    //     end else if (reg_1_rd_en == `ReadDisable) begin
    //         //if rd inactive, sent imme to reg1
    //         reg1 = imme;
    //     end else begin
    //         reg1 = `ZeroWord;
    //     end
    // end // always

    /*Get data stored in reg_2*/
    always @(*) begin
        if (rst == `RstEnable) begin
            reg2 = `ZeroWord;
        end else if (reg_2_rd_en == `ReadEnable && ex_reg_wr_en == `WriteEnable
                        && reg_2_rd_addr == ex_reg_wr_addr) begin
            // If reg to be written by ex is the same as reg to be read by reg2
            reg2 = ex_reg_wr_data; 
        end else if (reg_2_rd_en == `ReadEnable && mem_reg_wr_en == `WriteEnable
                        && reg_2_rd_addr == mem_reg_wr_addr) begin
            // If reg to be written by mem is the same as reg to be read by reg2
            reg2 = mem_reg_wr_data; 
        end else if (reg_2_rd_en == `ReadEnable) begin
            //if rd active, sent reg_2_rd_data to reg2
            reg2 = reg_2_rd_data;
        end else if (reg_2_rd_en == `ReadDisable) begin
            //if rd inactive, sent imme to reg2
            reg2 = imme;
        end else begin
            reg2 = `ZeroWord;
        end
    end // always

    // always @(*) begin
    //     if (rst == `RstEnable) begin
    //         reg2 = `ZeroWord;
    //     end else if (reg_2_rd_en == `ReadEnable) begin
    //         //if rd active, sent reg_2_rd_data to reg2
    //         reg2 = reg_2_rd_data;
    //     end else if (reg_2_rd_en == `ReadDisable) begin
    //         //if rd inactive, sent imme to reg2
    //         reg2 = imme;
    //     end else begin
    //         reg2 = `ZeroWord;
    //     end 
    // end // always


endmodule
