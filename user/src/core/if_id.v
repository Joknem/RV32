`include "defines.v"
`include "../utils/gen_dff.v"

module if_id(
    input   wire                        clk                                         ,                   
    input   wire                        rst                                         ,                   

    input   wire    [`INST_BUS]         inst_i                                      ,           // 指令内容 
    input   wire    [`INST_ADDR_BUS]    inst_addr_i                                 ,           // 指令地址 

    input   wire    [`HOLD_FLAG_BUS]    hold_flag_i                                 ,           // 流水线暂停标志


    output  wire    [`INST_BUS]         inst_o                                      ,           // 指令内容 
    output  wire    [`INST_ADDR_BUS]    inst_addr_o                                             // 指令地址 

    );


    wire hold_en = (hold_flag_i >= `HOLD_IF);

    wire    [`INST_BUS]                 inst                                        ;                               
    gen_pipe_dff #(32) inst_ff(clk, rst, hold_en, `INST_NOP, inst_i, inst);
    assign inst_o = inst;

    wire    [`INST_ADDR_BUS]            inst_addr                                   ;                               
    gen_pipe_dff #(32) inst_addr_ff(clk, rst, hold_en, `ZERO_WORD, inst_addr_i, inst_addr);
    assign inst_addr_o = inst_addr;


endmodule
