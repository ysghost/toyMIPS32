`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yan
// 
// Create Date: 2019/10/03 19:24:10
// Design Name: 
// Module Name: pc_reg
// Project Name: MIPS32 
// Target Devices: 
// Tool Versions: 
// Description: program counter (PC)
//   PC is the register of the next instruction address fetched from memory
// Addressing by Word (32 bit)
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   PC is sequential logic @ pipeline Stage 1
// 
//////////////////////////////////////////////////////////////////////////////////
`include "defines.v"

module pc_reg(
    input  wire                   clk,
    input  wire                   rst,          // active high, synchronous
    output reg                    chip_enable,
    output reg [`InstAddrBus-1:0] pc
    );

    /**/
    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            chip_enable <= `ChipDisable;
        end else begin
            chip_enable <= `ChipEnable;
        end
    end //always

    /*Word addressing*/
    always @(posedge clk) begin
        if (chip_enable == `ChipDisable) begin
            pc <= 32'h0;
        end else begin
            pc <= pc + 32'h4;
        end
    end


endmodule
