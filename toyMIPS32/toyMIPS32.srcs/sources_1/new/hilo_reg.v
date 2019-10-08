`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yan
// 
// Create Date: 2019/10/07 15:54:14
// Design Name: 
// Module Name: hilo_reg
// Project Name: MIPS32
// Target Devices: 
// Tool Versions: 
// Description: hilo_reg
//   hilo_reg contains high 32-bit hi and low 32-bit lo, 
//   its essence is a DFF
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   is sequential logic @ pipeline Stage 5
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module hilo_reg(
    input  wire                   clk,
    input  wire                   rst,          // active high, synchronous
    input  wire                   hilo_wr_en,
    input  wire  [`RegBus-1:0]    hi_wr_data,
    input  wire  [`RegBus-1:0]    lo_wr_data,
    output reg   [`RegBus-1:0]    hi_data,
    output reg   [`RegBus-1:0]    lo_data
    );

    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            hi_data <= `ZeroWord;
            lo_data <= `ZeroWord;
        end else if (hilo_wr_en == `WriteEnable) begin
            hi_data <= hi_wr_data;
            lo_data <= lo_wr_data;         
        end else begin
            hi_data <= hi_data;
            lo_data <= lo_data;            
        end
    end

endmodule
