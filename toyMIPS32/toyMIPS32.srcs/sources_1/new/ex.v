`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yan
// 
// Create Date: 2019/10/04 21:22:56
// Design Name: 
// Module Name: ex
// Project Name: MIPS32 
// Target Devices: 
// Tool Versions: 
// Description: execution (ex)
//   ex aims to execute computation
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   ex is combinational logic @ pipeline Stage 3
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module ex(
    input  wire                    rst,
    input  wire                    reg_wr_en_i,       
    input  wire [`RegAddrBus-1:0]  reg_wr_addr_i,
    input  wire [`RegBus-1:0]      reg1,
    input  wire [`RegBus-1:0]      reg2,
    input  wire [`AluOpBus-1:0]    alu_op,
    input  wire [`AluSelBus-1:0]   alu_sel,
    output wire                    reg_wr_en_o,  
    output wire [`RegAddrBus-1:0]  reg_wr_addr_o,
    output reg  [`RegBus-1:0]      reg_wr_data_o
    );

    assign reg_wr_en_o   = reg_wr_en_i    ;
    assign reg_wr_addr_o = reg_wr_addr_i  ;
    
    reg [`RegBus-1:0] logic_out;
    /*alu_op*/
    always @(*) begin
        if (rst == `RstEnable) begin
            logic_out = `ZeroWord;
        end else begin
            case (alu_op)
                `EXE_ORI_OP: begin
                    logic_out = reg1 | reg2;   // reg1 or reg2
                end // `EXE_ORI_OP
                default: begin
                    logic_out = `ZeroWord;
                end // default
            endcase //case (alu_op)
        end // if (rst) else 
    end

    /*alu_sel*/
    always @(*) begin
        if (rst == `RstEnable) begin
            reg_wr_data_o = `ZeroWord;
        end else begin
            case (alu_sel)
                `EXE_RES_LOGIC: begin
                    reg_wr_data_o = logic_out; // output the logic result
                end //`EXE_RES_LOGIC
                default: begin
                    reg_wr_data_o = `ZeroWord;
                end //default
            endcase //case (alu_sel)
        end
    end

endmodule
