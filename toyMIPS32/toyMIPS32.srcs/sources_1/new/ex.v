`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yan
// 
// Create Date: 2019/10/04 21:22:56
// Design Name: 
// Module Name: ex
// Project Name: MIPS32 
// Target Devices: 
// Tool Versions: 
// Description: execution (ex)
//   ex aims to execute computation
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Add AND, OR, XOR, NOR, ANDI, ORI, XORI, LUI,
//                     SLL, SLLV, SRL, SRLV, SRA, SRAV, SYNC
// Revision 0.03 - Add MOVZ, MOVN, MFHI, MTHI, MFLO, MTLO 
//                 Add "Operand Forwarding" from mem & wb
// Additional Comments:
// Revision 0.01
//   ex is combinational logic @ pipeline Stage 3
//
// Revision 0.02
//   Add AND, OR, XOR, NOR, ANDI, ORI, XORI, LUI,
//       SLL, SLLV, SRL, SRLV, SRA, SRAV, SYNC
//   Add shift_out
//
// Revision 0.03
//   Add MOVZ, MOVN, MFHI, MTHI, MFLO, MTLO 
//   Add "Operand Forwarding" from mem & wb
//   Add move_out
//////////////////////////////////////////////////////////////////////////////////

`include "defines.v"

module ex(
    input  wire                    rst,
    input  wire                    reg_wr_en_i,       
    input  wire [`RegAddrBus-1:0]  reg_wr_addr_i,
    input  wire [`RegBus-1:0]      reg1,
    input  wire [`RegBus-1:0]      reg2,
    input  wire [`RegBus-1:0]      hi_rd_data, //output of hilo
    input  wire [`RegBus-1:0]      lo_rd_data,
    input  wire                    mem_hilo_wr_en, //output of mem
    input  wire [`RegBus-1:0]      mem_hi_wr_data,
    input  wire [`RegBus-1:0]      mem_lo_wr_data,
    input  wire                    wb_hilo_wr_en, //output of wb & input of hilo
    input  wire [`RegBus-1:0]      wb_hi_wr_data,
    input  wire [`RegBus-1:0]      wb_lo_wr_data,
    input  wire [`AluOpBus-1:0]    alu_op,
    input  wire [`AluSelBus-1:0]   alu_sel,
    output wire                    reg_wr_en_o,  
    output wire [`RegAddrBus-1:0]  reg_wr_addr_o,
    output reg  [`RegBus-1:0]      reg_wr_data_o,
    output reg                     hilo_wr_en_o,
    output reg  [`RegBus-1:0]      hi_wr_data_o,
    output reg  [`RegBus-1:0]      lo_wr_data_o
    );

    assign reg_wr_en_o   = reg_wr_en_i    ;
    assign reg_wr_addr_o = reg_wr_addr_i  ;
    
    reg [`RegBus-1:0] logic_out;
    reg [`RegBus-1:0] shift_out;
    reg [`RegBus-1:0] move_out;

    /*store hi & lo*/
    reg [`RegBus-1:0] HI;
    reg [`RegBus-1:0] LO;
    /*determine hi & lo*/
    always @(*) begin
        if (rst == `RstEnable) begin
            {HI, LO} = {`ZeroWord, `ZeroWord};
        end else if (mem_hilo_wr_en == `WriteEnable) begin
            {HI, LO} = {mem_hi_wr_data, mem_lo_wr_data};
        end else if (wb_hilo_wr_en == `WriteEnable) begin
            {HI, LO} = {wb_hi_wr_data, wb_lo_wr_data};
        end else begin
            {HI, LO} = {hi_rd_data, lo_rd_data};
        end
    end

    /*ALU Operand*/
    /*logic_out*/
    always @(*) begin
        if (rst == `RstEnable) begin
            logic_out = `ZeroWord;
        end else begin
            case (alu_op)
                `EXE_ORI_OP: begin
                    logic_out = reg1 | reg2;   // reg1 or reg2
                end // `EXE_ORI_OP
                `EXE_OR_OP: begin
                    logic_out = reg1 | reg2;   // reg1 or reg2
                end // `EXE_OR_OP
                `EXE_ANDI_OP: begin
                    logic_out = reg1 & reg2;   // reg1 and reg2
                end // `EXE_ANDI_OP
                `EXE_AND_OP: begin
                    logic_out = reg1 & reg2;   // reg1 and reg2
                end // `EXE_AND_OP
                `EXE_XORI_OP: begin
                    logic_out = reg1 ^ reg2;   // reg1 xor reg2
                end // `EXE_XORI_OP
                `EXE_XOR_OP: begin
                    logic_out = reg1 ^ reg2;   // reg1 xor reg2
                end // `EXE_XOR_OP
                `EXE_NOR_OP: begin
                    logic_out = ~(reg1 | reg2);// reg1 nor reg2
                end // `EXE_NOR_OP                               
                default: begin
                    logic_out = `ZeroWord;
                end // default
            endcase //case (alu_op)
        end // if (rst) else 
    end // always

    /*shift_out*/
    always @(*) begin
        if (rst == `RstEnable) begin
            shift_out = `ZeroWord;
        end else begin
            case (alu_op)
                `EXE_SLL_OP: begin
                    shift_out = reg2 << reg1[4:0];  // rd <- reg2(rt) << reg1(sa) 
                end // `EXE_SLL_OP
                `EXE_SLLV_OP: begin
                    shift_out = reg2 << reg1[4:0];  // rd <- reg2(rt) << reg1(rs)
                end // `EXE_SLLV_OP
                `EXE_SRL_OP: begin
                    shift_out = reg2 >> reg1[4:0];  // rd <- reg2(rt) >> reg1(sa)
                end // `EXE_SRL_OP
                `EXE_SRLV_OP: begin
                    shift_out = reg2 >> reg1[4:0];  // rd <- reg2(rt) >> reg1(rs)
                end // `EXE_SRLV_OP
                `EXE_SRA_OP: begin
                    // rd <- reg2(rt) >> reg1(sa) 
                    // the vacant MSB is filled with value of the previous MSB
                    // Anothor method: shift_out = $signed(reg2) >>> reg1[4:0];
                    shift_out = ({{31{reg2[31]}},1'b0} << (~reg1[4:0]) )
                                | (reg2 >> reg1[4:0]);
                end // `EXE_SRA_OP
                `EXE_SRAV_OP: begin
                    // rd <- reg2(rt) >> reg1(rs)
                    // the vacant MSB is filled with value of the previous MSB
                    // Anothor method: shift_out = $signed(reg2) >>> reg1[4:0];
                    shift_out = ({{31{reg2[31]}},1'b0} << (~reg1[4:0]) )
                                | (reg2 >> reg1[4:0]); 
                end // `EXE_SRAV_OP             
                default: begin
                    shift_out = `ZeroWord;
                end // default
            endcase //case (alu_op)
        end // if (rst) else 
    end // always

    /*move_out*/
    always @(*) begin
        if (rst == `RstEnable) begin
            move_out = `ZeroWord;
        end else begin
            case (alu_op)
                `EXE_MOVZ_OP: begin
                    move_out = reg1;   // if rt == 0 then rd <- rs(reg1)
                end // `EXE_MOVZ_OP
                `EXE_MOVN_OP: begin
                    move_out = reg1;   // if rt != 0 then rd <- rs
                end // `EXE_MOVN_OP
                `EXE_MFHI_OP: begin
                    move_out = HI;     // rd <- hi
                end // `EXE_MFHI_OP
                `EXE_MFLO_OP: begin
                    move_out = LO;     // rd <- lo
                end // `EXE_MFLO_OP                              
                default: begin
                    move_out = `ZeroWord;
                end // default
            endcase //case (alu_op)
        end // if (rst) else 
    end // always

    /*for EXE_MTHI_OP & EXE_MTLO_OP*/
    //To write the hilo_reg, hilo_wr_en, hi_wr_data, 
    //    lo_wr_data are needed to be given
    always @(*) begin
        if (rst == `RstEnable) begin
            hilo_wr_en_o = `WriteDisable ;
            hi_wr_data_o = `ZeroWord     ;
            lo_wr_data_o = `ZeroWord     ;
        end else begin
            case (alu_op)
                `EXE_MTHI_OP: begin // hi <- rs(reg1)
                    hilo_wr_en_o = `WriteEnable  ;
                    hi_wr_data_o = reg1          ;
                    lo_wr_data_o = LO            ; //lo remains unchanged
                end // `EXE_MTHI_OP
                `EXE_MTLO_OP: begin // lo <- rs(reg1)
                    hilo_wr_en_o = `WriteEnable  ;
                    hi_wr_data_o = HI            ; //hi remains unchanged
                    lo_wr_data_o = reg1          ;  
                end // `EXE_MTLO_OP                             
                default: begin
                    hilo_wr_en_o = `WriteDisable ;
                    hi_wr_data_o = `ZeroWord     ;
                    lo_wr_data_o = `ZeroWord     ;
                end // default
            endcase //case (alu_op)
        end // if (rst) else 
    end // always

    /*select output: LOGIC or SHIFT or MOVE*/
    always @(*) begin
        if (rst == `RstEnable) begin
            reg_wr_data_o = `ZeroWord;
        end else begin
            case (alu_sel)
                `EXE_RES_LOGIC: begin
                    reg_wr_data_o = logic_out; // output the logic result
                end //`EXE_RES_LOGIC
                `EXE_RES_SHIFT: begin
                    reg_wr_data_o = shift_out; // output the shift result
                end //`EXE_RES_SHIFT 
                `EXE_RES_MOVE: begin
                    reg_wr_data_o = move_out; // output the move result
                end //`EXE_RES_MOVE                              
                default: begin
                    reg_wr_data_o = `ZeroWord;
                end //default
            endcase //case (alu_sel)
        end // if (rst) else 
    end // always

endmodule
