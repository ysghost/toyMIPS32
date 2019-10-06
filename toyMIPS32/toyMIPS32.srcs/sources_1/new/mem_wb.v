`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yan
// 
// Create Date: 2019/10/05 14:33:59
// Design Name: 
// Module Name: mem_wb
// Project Name: MIPS32 
// Target Devices: 
// Tool Versions: 
// Description: memory access to write back (mem_wb)
//   The mem_wb aims to store the data and address in the memory access process,
//   which is passed to the write back process in the next cycle
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module mem_wb(
    input  wire                    clk,
    input  wire                    rst,
    input  wire                    mem_reg_wr_en,  
    input  wire [`RegAddrBus-1:0]  mem_reg_wr_addr,
    input  wire [`RegBus-1:0]      mem_reg_wr_data,
    output reg                     wb_reg_wr_en,  
    output reg  [`RegAddrBus-1:0]  wb_reg_wr_addr,
    output reg  [`RegBus-1:0]      wb_reg_wr_data
    );

    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            wb_reg_wr_en     <= `WriteDisable    ;
            wb_reg_wr_addr   <= `NOPRegAddr      ;
            wb_reg_wr_data   <= `ZeroWord        ;
        end else begin
            wb_reg_wr_en     <= mem_reg_wr_en    ;
            wb_reg_wr_addr   <= mem_reg_wr_addr  ;
            wb_reg_wr_data   <= mem_reg_wr_data  ;
        end // if(rst) else
    end //always

endmodule
