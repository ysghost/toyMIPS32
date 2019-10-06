`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yan
// 
// Create Date: 2019/10/05 14:46:04
// Design Name: 
// Module Name: OpenMIPS
// Project Name: MIPS32
// Target Devices: 
// Tool Versions: 
// Description: OpenMIPS is the top module
//   It includes 5 stages and excludes inst_rom
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module OpenMIPS(
    input  wire                     clk,
    input  wire                     rst,
    input  wire [`InstBus-1:0]      rom_data,
    output wire [`InstAddrBus-1:0]  rom_addr,
    output wire                     rom_chip_enable,
    output wire                     wb_reg_wr_en_o,  
    output wire [`RegAddrBus-1:0]   wb_reg_wr_addr_o,
    output wire [`RegBus-1:0]       wb_reg_wr_data_o
    );
  
    wire  [`InstBus-1:0] inst   =  rom_data;
    // pc_reg
    wire                           chip_enable;
    wire  [`InstAddrBus-1:0]       pc;
 
    // if_id  
    wire  [`InstAddrBus-1:0]       if_2_id_pc;
    wire  [`InstBus-1:0]           if_2_id_inst;
    // id Outputs    
    wire                           id_2_id_ex_reg_wr_en;
    wire  [`RegAddrBus-1:0]        id_2_id_ex_reg_wr_addr;
    wire                           reg_1_rd_en;     
    wire                           reg_2_rd_en;     
    wire  [`RegAddrBus-1:0]        reg_1_rd_addr;
    wire  [`RegAddrBus-1:0]        reg_2_rd_addr;
 
    wire  [`RegBus-1:0]            id_2_id_ex_reg1;
    wire  [`RegBus-1:0]            id_2_id_ex_reg2;
    wire  [`AluOpBus-1:0]          id_2_id_ex_alu_op ;
    wire  [`AluSelBus-1:0]         id_2_id_ex_alu_sel;

    // regfile Outputs
    wire  [`RegBus-1:0]            rd_1_data;
    wire  [`RegBus-1:0]            rd_2_data;

    // id_ex Outputs
    wire                           id_ex_2_ex_reg_wr_en;
    wire  [`RegAddrBus-1:0]        id_ex_2_ex_reg_wr_addr;
    wire  [`RegBus-1:0]            id_ex_2_ex_reg1;
    wire  [`RegBus-1:0]            id_ex_2_ex_reg2;
    wire  [`AluOpBus-1:0]          id_ex_2_ex_alu_op;
    wire  [`AluSelBus-1:0]         id_ex_2_ex_alu_sel;
    
    // ex Outputs
    wire                           ex_2_ex_mem_reg_wr_en;
    wire  [`RegAddrBus-1:0]        ex_2_ex_mem_reg_wr_addr;
    wire  [`RegBus-1:0]            ex_2_ex_mem_reg_wr_data;
    
    // ex_mem Outputs   
    wire                           ex_mem_2_mem_reg_wr_en;
    wire  [`RegAddrBus-1:0]        ex_mem_2_mem_reg_wr_addr;
    wire  [`RegBus-1:0]            ex_mem_2_mem_reg_wr_data;
    
    // mem Outputs
    wire                           mem_2_mem_wb_reg_wr_en;
    wire  [`RegAddrBus-1:0]        mem_2_mem_wb_reg_wr_addr;
    wire  [`RegBus-1:0]            mem_2_mem_wb_reg_wr_data;
    
    // mem_wb Outputs  
    wire                           wb_reg_wr_en;
    wire  [`RegAddrBus-1:0]        wb_reg_wr_addr;
    wire  [`RegBus-1:0]            wb_reg_wr_data;


    ////////////////////////////////////////////////////////////////////////////
    //    instruction fetch                                                 
    ////////////////////////////////////////////////////////////////////////////
    
    // pc_reg
    pc_reg  u_pc_reg (
        .clk                     ( clk           ),
        .rst                     ( rst           ),

        .chip_enable             ( chip_enable   ),
        .pc                      ( pc            )
    );

    assign rom_addr        = pc;
    assign rom_chip_enable = chip_enable;

    ////////////////////////////////////////////////////////////////////////////
    //    instruction decode                                                
    ////////////////////////////////////////////////////////////////////////////
    


    //if_id
    if_id  u_if_id (
        .clk                     ( clk            ),
        .rst                     ( rst            ),
        .if_pc                   ( pc             ),
        .if_inst                 ( inst           ),

        .id_pc                   ( if_2_id_pc     ),
        .id_inst                 ( if_2_id_inst   )
    );

    //id
    id  u_id (
        .rst                     ( rst                        ),
        .pc                      ( if_2_id_pc                 ),
        .inst                    ( if_2_id_inst               ),
        .reg_1_rd_data           ( rd_1_data                  ),
        .reg_2_rd_data           ( rd_2_data                  ),
        .ex_reg_wr_en            ( ex_2_ex_mem_reg_wr_en      ),
        .ex_reg_wr_addr          ( ex_2_ex_mem_reg_wr_addr    ),
        .ex_reg_wr_data          ( ex_2_ex_mem_reg_wr_data    ),
        .mem_reg_wr_en           ( mem_2_mem_wb_reg_wr_en     ),
        .mem_reg_wr_addr         ( mem_2_mem_wb_reg_wr_addr   ),
        .mem_reg_wr_data         ( mem_2_mem_wb_reg_wr_data   ),

        .reg_wr_en               ( id_2_id_ex_reg_wr_en       ),
        .reg_wr_addr             ( id_2_id_ex_reg_wr_addr     ),
        .reg_1_rd_en             ( reg_1_rd_en                ),
        .reg_2_rd_en             ( reg_2_rd_en                ),
        .reg_1_rd_addr           ( reg_1_rd_addr              ),
        .reg_2_rd_addr           ( reg_2_rd_addr              ),
        .reg1                    ( id_2_id_ex_reg1            ),
        .reg2                    ( id_2_id_ex_reg2            ),
        .alu_op                  ( id_2_id_ex_alu_op          ),
        .alu_sel                 ( id_2_id_ex_alu_sel         )
    );


    // id  u_id (
    //     .rst                     ( rst                     ),
    //     .pc                      ( if_2_id_pc              ),
    //     .inst                    ( if_2_id_inst            ),
    //     .reg_1_rd_data           ( rd_1_data               ),
    //     .reg_2_rd_data           ( rd_2_data               ),

    //     .reg_wr_en               ( id_2_id_ex_reg_wr_en    ),  
    //     .reg_wr_addr             ( id_2_id_ex_reg_wr_addr  ),
    //     .reg_1_rd_en             ( reg_1_rd_en             ),
    //     .reg_2_rd_en             ( reg_2_rd_en             ),
    //     .reg_1_rd_addr           ( reg_1_rd_addr           ),
    //     .reg_2_rd_addr           ( reg_2_rd_addr           ),
    //     .reg1                    ( id_2_id_ex_reg1         ),
    //     .reg2                    ( id_2_id_ex_reg2         ),
    //     .alu_op                  ( id_2_id_ex_alu_op       ),
    //     .alu_sel                 ( id_2_id_ex_alu_sel      )
    // );

    //regfile
    regfile  u_regfile (
        .clk                     ( clk                ),
        .rst                     ( rst                ),
        .wr_en                   ( wb_reg_wr_en       ),
        .wr_addr                 ( wb_reg_wr_addr     ),
        .wr_data                 ( wb_reg_wr_data     ),
        .rd_1_en                 ( reg_1_rd_en        ),
        .rd_1_addr               ( reg_1_rd_addr      ),
        .rd_2_en                 ( reg_2_rd_en        ),
        .rd_2_addr               ( reg_2_rd_addr      ),

        .rd_1_data               ( rd_1_data          ),
        .rd_2_data               ( rd_2_data          )
    );    

    ////////////////////////////////////////////////////////////////////////////
    //    exucution                                                
    ////////////////////////////////////////////////////////////////////////////

    //id_ex
    id_ex  u_id_ex (
        .clk                     ( clk                      ),
        .rst                     ( rst                      ),
        .id_reg_wr_en            ( id_2_id_ex_reg_wr_en     ),
        .id_reg_wr_addr          ( id_2_id_ex_reg_wr_addr   ),
        .id_reg1                 ( id_2_id_ex_reg1          ),
        .id_reg2                 ( id_2_id_ex_reg2          ),
        .id_alu_op               ( id_2_id_ex_alu_op        ),
        .id_alu_sel              ( id_2_id_ex_alu_sel       ),

        .ex_reg_wr_en            ( id_ex_2_ex_reg_wr_en     ),
        .ex_reg_wr_addr          ( id_ex_2_ex_reg_wr_addr   ),
        .ex_reg1                 ( id_ex_2_ex_reg1          ),
        .ex_reg2                 ( id_ex_2_ex_reg2          ),
        .ex_alu_op               ( id_ex_2_ex_alu_op        ),
        .ex_alu_sel              ( id_ex_2_ex_alu_sel       )
    );

    //ex
    ex  u_ex (
        .rst                     ( rst                         ),
        .reg_wr_en_i             ( id_ex_2_ex_reg_wr_en        ),
        .reg_wr_addr_i           ( id_ex_2_ex_reg_wr_addr      ),
        .reg1                    ( id_ex_2_ex_reg1             ),
        .reg2                    ( id_ex_2_ex_reg2             ),
        .alu_op                  ( id_ex_2_ex_alu_op           ),
        .alu_sel                 ( id_ex_2_ex_alu_sel          ),

        .reg_wr_en_o             ( ex_2_ex_mem_reg_wr_en       ),
        .reg_wr_addr_o           ( ex_2_ex_mem_reg_wr_addr     ),
        .reg_wr_data_o           ( ex_2_ex_mem_reg_wr_data     )
    );

    ////////////////////////////////////////////////////////////////////////////
    //    memory access                                                
    ////////////////////////////////////////////////////////////////////////////

    //ex_mem
    ex_mem  u_ex_mem (
        .clk                     ( clk                        ),
        .rst                     ( rst                        ),
        .ex_reg_wr_en            ( ex_2_ex_mem_reg_wr_en      ),
        .ex_reg_wr_addr          ( ex_2_ex_mem_reg_wr_addr    ),
        .ex_reg_wr_data          ( ex_2_ex_mem_reg_wr_data    ),

        .mem_reg_wr_en           ( ex_mem_2_mem_reg_wr_en     ),
        .mem_reg_wr_addr         ( ex_mem_2_mem_reg_wr_addr   ),
        .mem_reg_wr_data         ( ex_mem_2_mem_reg_wr_data   )
    );

    //mem
    mem  u_mem (
        .rst                     ( rst                          ),
        .reg_wr_en_i             ( ex_mem_2_mem_reg_wr_en       ),
        .reg_wr_addr_i           ( ex_mem_2_mem_reg_wr_addr     ),
        .reg_wr_data_i           ( ex_mem_2_mem_reg_wr_data     ),

        .reg_wr_en_o             ( mem_2_mem_wb_reg_wr_en       ),
        .reg_wr_addr_o           ( mem_2_mem_wb_reg_wr_addr     ),
        .reg_wr_data_o           ( mem_2_mem_wb_reg_wr_data     )
    );

    ////////////////////////////////////////////////////////////////////////////
    //    write back                                               
    ////////////////////////////////////////////////////////////////////////////
 
    //mem_wb
    mem_wb  u_mem_wb (
        .clk                     ( clk                        ),
        .rst                     ( rst                        ),
        .mem_reg_wr_en           ( mem_2_mem_wb_reg_wr_en     ),
        .mem_reg_wr_addr         ( mem_2_mem_wb_reg_wr_addr   ),
        .mem_reg_wr_data         ( mem_2_mem_wb_reg_wr_data   ),

        .wb_reg_wr_en            ( wb_reg_wr_en               ),
        .wb_reg_wr_addr          ( wb_reg_wr_addr             ),
        .wb_reg_wr_data          ( wb_reg_wr_data             )
    );    


    assign wb_reg_wr_en_o   = wb_reg_wr_en    ;   
    assign wb_reg_wr_addr_o = wb_reg_wr_addr  ;
    assign wb_reg_wr_data_o = wb_reg_wr_data  ;

endmodule
