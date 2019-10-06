`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yan
// 
// Create Date: 2019/10/03 20:01:15
// Design Name: 
// Module Name: inst_rom
// Project Name: MIPS32 
// Target Devices: 
// Tool Versions: 
// Description: instruction rom (inst_rom)
//   The inst_rom stores the instruction and outputs the corresponding 
//   instruction (inst) according to address (addr) 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   inst_rom is combinational logic logic @ pipeline Stage 1
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module inst_rom(
    input  wire                     chip_enable,
    input  wire [`InstAddrBus-1:0]  addr,
    output reg  [`InstBus-1:0]      inst
    );

    reg [`InstBus-1:0] instruction_rom [0:`InstMemNum-1];

    //initial $readmemh ( "inst_rom.data", instruction_rom );

    initial begin
        // instruction_rom[0] = `InstBus'h34011100;
        // instruction_rom[1] = `InstBus'h34020020;
        // instruction_rom[2] = `InstBus'h3403ff00;
        // instruction_rom[3] = `InstBus'h3404ffff;
        instruction_rom[0] = `InstBus'h34011100;
        instruction_rom[1] = `InstBus'h34210020;
        instruction_rom[2] = `InstBus'h34214400;
        instruction_rom[3] = `InstBus'h34210044;
    end



    always @(*) begin
        if (chip_enable == `ChipDisable) begin
            inst = `ZeroWord;
        end else begin
            inst = instruction_rom[addr[`InstMemNumLog2+1:2]];
        end
    end

    // initial begin
    //     instruction_rom[0] = 0;
    //     instruction_rom[1] = 1;
    //     instruction_rom[2] = 2;
    //     instruction_rom[3] = 3;
    //     instruction_rom[4] = 4;
    //     instruction_rom[5] = 5;
    //     instruction_rom[6] = 6;
    //     instruction_rom[7] = 7;
    //     instruction_rom[8] = 8;
    //     instruction_rom[9] = 9;
    // end

    // always @(*) begin
    //     if (chip_enable == `ChipDisable) begin
    //         inst <= 0;
    //     end else begin
    //         inst <= instruction_rom[addr];
    //     end
    // end

endmodule
