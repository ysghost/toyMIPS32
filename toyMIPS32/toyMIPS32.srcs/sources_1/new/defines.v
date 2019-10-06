//global
`define RstEnable 1'b1
`define RstDisable 1'b0
`define ZeroWord 32'h00000000
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0
`define AluOpBus 8
`define AluSelBus 3
`define InstValid 1'b0
`define InstInvalid 1'b1
`define Stop 1'b1
`define NoStop 1'b0
`define InDelaySlot 1'b1
`define NotInDelaySlot 1'b0
`define Branch 1'b1
`define NotBranch 1'b0
`define InterruptAssert 1'b1
`define InterruptNotAssert 1'b0
`define TrapAssert 1'b1
`define TrapNotAssert 1'b0
`define True_v 1'b1
`define False_v 1'b0
`define ChipEnable 1'b1
`define ChipDisable 1'b0


//instructions
`define EXE_ORI  6'b001101


`define EXE_NOP 6'b000000


//AluOp
`define EXE_OR_OP    8'b00100101
`define EXE_ORI_OP  8'b01011010


`define EXE_NOP_OP    8'b00000000

//AluSel
`define EXE_RES_LOGIC 3'b001

`define EXE_RES_NOP 3'b000


//IR: inst_rom
`define InstAddrBus 32
`define InstBus 32
`define InstMemNum 131071
`define InstMemNumLog2 17


//ͨregister file: regfile
`define RegAddrBus 5
`define RegBus 32
`define RegWidth 32
`define DoubleRegWidth 64
`define DoubleRegBus 64
`define RegNum 32
`define RegNumLog2 5
`define NOPRegAddr 5'b00000