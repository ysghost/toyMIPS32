`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yan
// 
// Create Date: 2019/10/05 14:25:44
// Design Name: 
// Module Name: mem
// Project Name: MIPS32 
// Target Devices: 
// Tool Versions: 
// Description: memory access (mem)
//   mem aims to access external memory
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Add "Operand Forwarding" 
// Additional Comments:
//   mem is combinational logic @ pipeline Stage 4
// Revision 0.02 - Add "Operand Forwarding" 
//   Add ex_hilo_wr_en_i, ex_hi_wr_data_i, ex_lo_wr_data_i,
//       mem_hilo_wr_en_o, mem_hi_wr_data_o, mem_lo_wr_data_o

//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module mem(
    input  wire                    rst,
    input  wire                    reg_wr_en_i,  
    input  wire [`RegAddrBus-1:0]  reg_wr_addr_i,
    input  wire [`RegBus-1:0]      reg_wr_data_i,
    input  wire                    hilo_wr_en_i,
    input  wire [`RegBus-1:0]      hi_wr_data_i,
    input  wire [`RegBus-1:0]      lo_wr_data_i,
    output reg                     reg_wr_en_o,  
    output reg  [`RegAddrBus-1:0]  reg_wr_addr_o,
    output reg  [`RegBus-1:0]      reg_wr_data_o,
    output reg                     hilo_wr_en_o,
    output reg  [`RegBus-1:0]      hi_wr_data_o,
    output reg  [`RegBus-1:0]      lo_wr_data_o
    );

    always @(*) begin
        if (rst == `RstEnable) begin
            reg_wr_en_o    = `WriteDisable   ;
            reg_wr_addr_o  = `NOPRegAddr     ;
            reg_wr_data_o  = `ZeroWord       ;
            hilo_wr_en_o   = `WriteDisable   ;
            hi_wr_data_o   = `ZeroWord       ;
            lo_wr_data_o   = `ZeroWord       ;
        end else begin
            reg_wr_en_o    = reg_wr_en_i     ;
            reg_wr_addr_o  = reg_wr_addr_i   ;
            reg_wr_data_o  = reg_wr_data_i   ;
            hilo_wr_en_o   = hilo_wr_en_i    ;
            hi_wr_data_o   = hi_wr_data_i    ;
            lo_wr_data_o   = lo_wr_data_i    ;
        end //if(rst) else
    end //always

endmodule
