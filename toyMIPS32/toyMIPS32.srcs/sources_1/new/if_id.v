`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yan
// 
// Create Date: 2019/10/04 09:40:46
// Design Name: 
// Module Name: if_id
// Project Name: MIPS32 
// Target Devices: 
// Tool Versions: 
// Description: instruction fetch to instruction decode (if_id)
//   The if_id aims to store the address and instruction in the instruction fetch
//   process, which is passed to the instruction decode process in the next cycle
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   if_id is sequential logic @ pipeline Stage 2
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module if_id(
    input  wire                    clk,
    input  wire                    rst,
    input  wire [`InstAddrBus-1:0] if_pc,
    input  wire [`InstBus-1:0]     if_inst,
    output reg  [`InstAddrBus-1:0] id_pc,
    output reg  [`InstBus-1:0]     id_inst
    );

    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            id_pc <= 32'h0;
            id_inst <= `ZeroWord;
        end else begin
            id_pc <= if_pc;
            id_inst <= if_inst;            
        end
    end

endmodule
