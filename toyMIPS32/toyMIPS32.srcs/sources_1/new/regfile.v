`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yan
// 
// Create Date: 2019/10/04 09:56:38
// Design Name: 
// Module Name: regfile
// Project Name: MIPS32 
// Target Devices: 
// Tool Versions: 
// Description: regfile
//   Regfile implements 32 general-purpose integer registers, which can 
//   READ two registers and WRITE to one register simultaneously.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   regfile is logic @ pipeline Stage 2
// 
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module regfile(
    input  wire                   clk,
    input  wire                   rst,          // active high, synchronous
    input  wire                   wr_en,
    input  wire [`RegAddrBus-1:0] wr_addr,
    input  wire [`RegBus-1:0]     wr_data,
    input  wire                   rd_1_en,
    input  wire [`RegAddrBus-1:0] rd_1_addr,
    output reg  [`RegBus-1:0]     rd_1_data,
    input  wire                   rd_2_en,
    input  wire [`RegAddrBus-1:0] rd_2_addr,
    output reg  [`RegBus-1:0]     rd_2_data
    );

    /*define regfile*/
    reg [`RegBus-1:0] regs [`RegNum-1:0];

    /*write
    * write is sequential logic, the data is writen in the next cycle
    * allowed: rst not active && wr_en active && wr != 0 ($0 cannot be written)
    */
    always @(posedge clk) begin
        if (rst == `RstDisable && wr_en == `WriteEnable 
            && wr_addr != `RegNumLog2'h0) begin
            regs[wr_addr] <= wr_data;
        end
    end

    /*read
    * read is combinational logic, the data is writen in the current cycle
    * allowed: rst not active && rd_en active
    * feature: If read and write the same address simultaneously, the data 
    * corresponding to the write address is directly sent to the read data.
    */
    /*read 1*/
    always @(*) begin
        if (rst == `RstEnable) begin
            rd_1_data = `ZeroWord;
        end else if (rd_1_addr == `RegNumLog2'h0) begin
            rd_1_data = `ZeroWord;
        end else if (rd_1_addr == wr_addr && wr_en == `WriteEnable 
                        && rd_1_en == `ReadEnable) begin
            rd_1_data = wr_data;
        end else if (rd_1_en == `ReadEnable) begin
            rd_1_data = regs[rd_1_addr];
        end else begin
            rd_1_data = `ZeroWord;
        end
    end

    /*read 2*/
    always @(*) begin
        if (rst == `RstEnable) begin
            rd_2_data = `ZeroWord;
        end else if (rd_2_addr == `RegNumLog2'h0) begin
            rd_2_data = `ZeroWord;
        end else if (rd_2_addr == wr_addr && wr_en == `WriteEnable 
                        && rd_2_en == `ReadEnable) begin
            rd_2_data = wr_data;
        end else if (rd_2_en == `ReadEnable) begin
            rd_2_data = regs[rd_2_addr];
        end else begin
            rd_2_data = `ZeroWord;
        end
    end

endmodule
