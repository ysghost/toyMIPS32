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

    // initial begin
    //     // instruction_rom[0] = `InstBus'h34011100;
    //     // instruction_rom[1] = `InstBus'h34020020;
    //     // instruction_rom[2] = `InstBus'h3403ff00;
    //     // instruction_rom[3] = `InstBus'h3404ffff;
    //     instruction_rom[0] = `InstBus'h34011100;
    //     instruction_rom[1] = `InstBus'h34210020;
    //     instruction_rom[2] = `InstBus'h34214400;
    //     instruction_rom[3] = `InstBus'h34210044;
    // end

    // // logic test
    // initial begin
    //     instruction_rom[0] = `InstBus'h3c010101;
    //     instruction_rom[1] = `InstBus'h34210101;
    //     instruction_rom[2] = `InstBus'h34221100;
    //     instruction_rom[3] = `InstBus'h00220825;
    //     instruction_rom[4] = `InstBus'h302300fe;
    //     instruction_rom[5] = `InstBus'h00610824;
    //     instruction_rom[6] = `InstBus'h3824ff00;
    //     instruction_rom[7] = `InstBus'h00810826;
    //     instruction_rom[8] = `InstBus'h00810827;
    // end

    // shift test
    initial begin
        //lui	 $v0,0x404     --> $2 = 0x04040000
        //ori	 $v0,$v0,0x404 --> $2 = 0x04040404
        //sll	 $v0,$v0,0x8   --> $2 = 0x04040400
        //ori    $a3,$zero,0x2 --> $7 = 0x00000002
        //sllv   $v0,$v0,$a3   --> $2 = 0x10101000
        //srl	 $v0,$v0,0x8   --> $2 = 0x00101010
        //ori    $a1,$zero,0x3 --> $5 = 0x00000003
        //srlv   $v0,$v0,$a1   --> $2 = 0x00020202
        //sll	 $v0,$v0,0xe   --> $2 = 0x80808000
        //sra	 $v0,$v0,0x4   --> $2 = 0xf8080800
        //ori    $t0,$zero,0x8 --> $8 = 0x00000008
        //srav   $v0,$v0,$t0   --> $2 = 0xfff80808
        instruction_rom[0]  = `InstBus'h3c020404;//lui	 $v0,0x404    
        instruction_rom[1]  = `InstBus'h34420404;//ori	 $v0,$v0,0x404
        instruction_rom[2]  = `InstBus'h00021200;//sll	 $v0,$v0,0x8  
        instruction_rom[3]  = `InstBus'h34070002;//ori   $a3,$zero,0x2
        instruction_rom[4]  = `InstBus'h00e21004;//sllv  $v0,$v0,$a3  
        instruction_rom[5]  = `InstBus'h00021202;//srl	 $v0,$v0,0x8  
        instruction_rom[6]  = `InstBus'h34050003;//ori   $a1,$zero,0x3
        instruction_rom[7]  = `InstBus'h00a21006;//srlv  $v0,$v0,$a1  
        instruction_rom[8]  = `InstBus'h00021380;//sll	 $v0,$v0,0xe  
        instruction_rom[9]  = `InstBus'h00021103;//sra	 $v0,$v0,0x4  
        instruction_rom[10] = `InstBus'h34080008;//ori   $t0,$zero,0x8
        instruction_rom[11] = `InstBus'h01021007;//srav  $v0,$v0,$t0  
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
