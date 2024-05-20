`include "defines.v"
`include "../utils/gen_dff.v"

module id_ex(
    input   wire                        clk                                         ,                   
    input   wire                        rst                                         ,                   

    //from id
    input   wire    [`MEM_BUS]          op1_i                                       ,                   
    input   wire    [`MEM_BUS]          op2_i                                       ,                   
    input   wire                        reg_we_i                                    ,                   
    input   wire    [`REG_ADDR_BUS]     reg_waddr_i                                 ,                   
    input   wire    [`MEM_ADDR_BUS]     inst_addr_i                                 ,                   
    input   wire    [`MEM_BUS]          inst_i                                      ,                   

    //from 
    input   wire    [`HOLD_FLAG_BUS]    hold_flag_i                                 ,                   

    //to ex
    output  wire    [`MEM_ADDR_BUS]     inst_addr_o                                 ,                   
    output  wire    [`MEM_BUS]          inst_o                                      ,                   
    output  wire    [`MEM_BUS]          op1_o                                       ,                   
    output  wire    [`MEM_BUS]          op2_o                                       ,                   
    output  wire                        reg_we_o                                    ,                   
    output  wire    [`REG_ADDR_BUS]     reg_waddr_o                                                     
);
    wire hold_en = (hold_flag_i >= `HOLD_ID);
    
    gen_pipe_dff #(32) inst_ff(clk, rst, hold_en, `INST_NOP, inst_i, inst_o);
    gen_pipe_dff #(32) inst_addr_ff(clk, rst, hold_en, `ZERO_WORD, inst_addr_i, inst_addr_o);
    gen_pipe_dff #(32) op1_dff(clk, rst, hold_en, `ZERO_WORD, op1_i, op1_o);
    gen_pipe_dff #(32) op2_dff(clk, rst, hold_en, `ZERO_WORD, op2_i, op2_o);
    gen_pipe_dff #(1) reg_we(clk, rst, hold_en, `WRITE_DISABLE, reg_we_i, reg_we_o);
    gen_pipe_dff #(5) reg_waddr(clk, rst, hold_en, `ZERO_REG, reg_waddr_i, reg_waddr_o);


endmodule //id_ex
