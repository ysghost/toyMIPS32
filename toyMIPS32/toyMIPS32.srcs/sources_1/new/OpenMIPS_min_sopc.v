`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yan
// 
// Create Date: 2019/10/05 17:08:37
// Design Name: 
// Module Name: OpenMIPS_min_sopc
// Project Name: MIPS32
// Target Devices: 
// Tool Versions: 
// Description: a minimum sopc for 5 cycles pipeline MIPS
//   support instruction (ORI)
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   contain OpenMIPS module and inst_room module
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module OpenMIPS_min_sopc(
    input  wire                    clk,
    input  wire                    rst,
    output wire                    reg_wr_en_o,   
    output wire [`RegAddrBus-1:0]  reg_wr_addr_o, 
    output wire [`RegBus-1:0]      reg_wr_data_o 
    );

    wire  [`InstAddrBus-1:0] pc;
    wire                     chip_enable;
    wire  [`InstBus-1:0]     instruction;


    OpenMIPS  u_OpenMIPS (
        .clk                     ( clk               ),
        .rst                     ( rst               ),
        .rom_data                ( instruction       ),

        .rom_addr                ( pc                ),
        .rom_chip_enable         ( chip_enable       ),
        .wb_reg_wr_en_o          ( reg_wr_en_o       ),
        .wb_reg_wr_addr_o        ( reg_wr_addr_o     ),  
        .wb_reg_wr_data_o        ( reg_wr_data_o     )
    );

    inst_rom  u_inst_rom (
        .chip_enable             ( chip_enable       ),
        .addr                    ( pc                ),

        .inst                    ( instruction       )
    );



endmodule
