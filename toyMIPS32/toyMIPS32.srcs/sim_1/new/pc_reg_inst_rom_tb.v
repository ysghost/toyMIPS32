`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/03 20:55:03
// Design Name: 
// Module Name: pc_reg_inst_rom_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "E:/MIPS32/MIPS_v1/MIPS_v1.srcs/sources_1/new/defines.v"

module pc_reg_inst_rom_tb;

    // pc_reg Inputs
    reg   clk;
    reg   rst;

    // pc_reg Outputs
    wire  chip_enable;
    wire  [`InstAddrBus-1:0]  pc;

    // inst_rom Outputs
    wire  [`InstBus-1:0]  inst;
    
    initial begin
        clk = 1'b0;
        rst = 1'b1;
        forever #10 clk = ~clk;
    end

    initial begin
        #60 rst = 1'b0;

    end


    pc_reg  u_pc_reg (
        .clk                     ( clk           ),
        .rst                     ( rst           ),
        .chip_enable             ( chip_enable   ),
        .pc                      ( pc            )
    );

    inst_rom  u_inst_rom (
        .chip_enable             ( chip_enable   ),
        .addr                    ( pc            ),
        .inst                    ( inst          )
    ); 


endmodule
