`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/04 11:20:39
// Design Name: 
// Module Name: regfile_tb
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

module regfile_tb;

parameter PERIOD  = 10;


// regfile Inputs
reg   clk                                  = 0 ;
reg   rst                                  = 1 ;
reg   wr_en                                = 0 ;
reg   [`RegAddrBus-1:0]  wr_addr           = 0 ;
reg   [`RegBus-1:0]  wr_data               = 0 ;
reg   rd_1_en                              = 0 ;
reg   [`RegAddrBus-1:0]  rd_1_addr         = 0 ;
reg   rd_2_en                              = 0 ;
reg   [`RegAddrBus-1:0]  rd_2_addr         = 0 ;

// regfile Outputs
wire  [`RegBus-1:0]  rd_1_data             ;
wire  [`RegBus-1:0]  rd_2_data             ;


initial
begin
    forever #(PERIOD/2)  clk = ~clk;
end

initial
begin
    #(PERIOD*2) rst = 0;
end

regfile  u_regfile (
    .clk                     ( clk                          ),
    .rst                     ( rst                          ),
    .wr_en                   ( wr_en                        ),
    .wr_addr                 ( wr_addr    [`RegAddrBus-1:0] ),
    .wr_data                 ( wr_data    [`RegBus-1:0]     ),
    .rd_1_en                 ( rd_1_en                      ),
    .rd_1_addr               ( rd_1_addr  [`RegAddrBus-1:0] ),
    .rd_2_en                 ( rd_2_en                      ),
    .rd_2_addr               ( rd_2_addr  [`RegAddrBus-1:0] ),
    .rd_1_data               ( rd_1_data  [`RegBus-1:0]     ),
    .rd_2_data               ( rd_2_data  [`RegBus-1:0]     )
);

// genvar i;
// // initial
// // begin
//     generate
//     for (i=0;i<32;i=i+1) begin:write
//         #5 wr_en  = `WriteEnable;
//         #5 wr_en  = `WriteDisable;
//     end
//     endgenerate
//     $finish;
// // end


integer i;
initial begin
    for (i=0;i<32;i=i+1) begin:write
        #5 wr_en  = `WriteEnable;
        #0 wr_addr = i;
        #0 wr_data = i;
        #5 wr_en  = `WriteDisable;
    end
end

integer j;
initial begin
    #20 rd_1_en = `ReadDisable;
    #0  rd_2_en = `ReadDisable;
    for (j=2;j<32;j=j+2) begin:read
        #15 rd_1_en = `ReadEnable;
        #0  rd_2_en = `ReadEnable;
        #0  rd_1_addr = j;
        #0  rd_2_addr = j+1;
        #5  rd_1_en  = `ReadDisable;
        #0  rd_2_en  = `ReadDisable;
    end
end
endmodule
