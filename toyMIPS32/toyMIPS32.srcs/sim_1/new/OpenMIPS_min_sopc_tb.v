`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/05 19:20:29
// Design Name: 
// Module Name: OpenMIPS_min_sopc_tb
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

module OpenMIPS_min_sopc_tb;   

    // OpenMIPS_min_sopc Parameters
    parameter PERIOD  = 10;        


    // OpenMIPS_min_sopc Inputs
    reg   clk                                  = 0 ;
    reg   rst                                  = 1 ;

    // OpenMIPS_min_sopc Outputs
    wire                   reg_wr_en_out  ;
    wire [`RegAddrBus-1:0] reg_wr_addr_out;
    wire [`RegBus-1:0]     reg_wr_data_out;


    initial
    begin
        forever #(PERIOD/2)  clk = ~clk;
    end

    initial
    begin
        #(PERIOD*2) rst = 0;
    end

    OpenMIPS_min_sopc  u_OpenMIPS_min_sopc (
        .clk                     ( clk   ),
        .rst                     ( rst   ),
        .reg_wr_en_o             ( reg_wr_en_out  ),
        .reg_wr_addr_o           ( reg_wr_addr_out),
        .reg_wr_data_o           ( reg_wr_data_out) 
    );

    initial
    begin

        #500 $finish;
    end

endmodule
