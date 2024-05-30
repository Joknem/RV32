`include "defines.v"
`include "../utils/gen_dff.v"

module id_ex(
    input   wire                        clk                                         ,                   
    input   wire                        rst                                         ,                   

    //from id
    input   wire    [`MEM_BUS]          op1_i                                       ,                   
    input   wire    [`MEM_BUS]          op2_i                                       ,                   
    input   wire    [`MEM_BUS]          op1_jump_i                                  ,                   
    input   wire    [`MEM_BUS]          op2_jump_i                                  ,                   
    input   wire                        reg_we_i                                    ,                   
    input   wire    [`REG_ADDR_BUS]     reg_waddr_i                                 ,                   
    input   wire    [`MEM_ADDR_BUS]     inst_addr_i                                 ,                   
    input   wire    [`MEM_BUS]          inst_i                                      ,                   
    input   wire    [`REG_BUS]          reg1_rdata_i                                ,                   
    input   wire    [`REG_BUS]          reg2_rdata_i                                ,                   

    //from ex
    input   wire    [`HOLD_FLAG_BUS]    hold_flag_i                                 ,                   

    //to ex
    output  wire    [`REG_BUS]          reg1_rdata_o                                ,                   
    output  wire    [`REG_BUS]          reg2_rdata_o                                ,                   
    output  wire    [`MEM_ADDR_BUS]     inst_addr_o                                 ,                   
    output  wire    [`MEM_BUS]          inst_o                                      ,                   
    output  wire    [`MEM_BUS]          op1_o                                       ,                   
    output  wire    [`MEM_BUS]          op2_o                                       ,                   
    output  wire    [`MEM_BUS]          op1_jump_o                                  ,                   
    output  wire    [`MEM_BUS]          op2_jump_o                                  ,                   
    output  wire                        reg_we_o                                    ,                   
    output  wire    [`REG_ADDR_BUS]     reg_waddr_o                                                     
);
    wire hold_en = (hold_flag_i >= `HOLD_ID);
    
    gen_pipe_dff #(32) inst_ff(clk, rst, hold_en, `INST_NOP, inst_i, inst_o);
    gen_pipe_dff #(32) inst_addr_ff(clk, rst, hold_en, `ZERO_WORD, inst_addr_i, inst_addr_o);
    gen_pipe_dff #(32) op1_dff(clk, rst, hold_en, `ZERO_WORD, op1_i, op1_o);
    gen_pipe_dff #(32) op2_dff(clk, rst, hold_en, `ZERO_WORD, op2_i, op2_o);
    gen_pipe_dff #(32) op1_jump_dff(clk, rst, hold_en, `ZERO_WORD, op1_jump_i, op1_jump_o);
    gen_pipe_dff #(32) op2_jump_dff(clk, rst, hold_en, `ZERO_WORD, op2_jump_i, op2_jump_o);
    gen_pipe_dff #(32) reg1_rdata_dff(clk, rst, hold_en, `ZERO_WORD, reg1_rdata_i, reg1_rdata_o);
    gen_pipe_dff #(32) reg2_rdata_dff(clk, rst, hold_en, `ZERO_WORD, reg2_rdata_i, reg2_rdata_o);
    gen_pipe_dff #(1) reg_we(clk, rst, hold_en, `WRITE_DISABLE, reg_we_i, reg_we_o);
    gen_pipe_dff #(5) reg_waddr(clk, rst, hold_en, `ZERO_REG, reg_waddr_i, reg_waddr_o);
    

endmodule //id_ex
