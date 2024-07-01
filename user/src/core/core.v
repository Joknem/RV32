`timescale 1ns/1ns

`include "defines.v"
`include "pc_reg.v"
`include "if_id.v"
`include "regs.v"
`include "id.v"
`include "id_ex.v"
`include "ex.v"
`include "bus.v"
`include "../utils/gen_dff.v"


module core(
    input   wire                        clk                                         ,                   
    input   wire                        rst                                         ,                   
    input   wire                        bus_hold_flag_i                             ,                   
    output  wire    [`MEM_ADDR_BUS]     pc_addr_o                                   ,                   
    input   wire    [`MEM_BUS]          pc_data_i                                   ,                   
    input   wire    [`MEM_BUS]          ex_bus_data_i                               ,                   
    output  wire    [`MEM_ADDR_BUS]     ex_bus_addr_o                               ,                   
    output  wire    [`MEM_BUS]          ex_bus_data_o                               ,                   
    output  wire                        ex_bus_req_o                                ,                   
    output  wire                        ex_bus_we_o                                                     
);
    reg     [`MEM_ADDR_BUS]             jump_addr_i                                 ;                               
    reg     [`HOLD_FLAG_BUS]            hold_flag_i                                 ;                               
    wire    [`MEM_ADDR_BUS]             pc_o                                        ;                               

    //rom module
    wire    [`INST_BUS]                 rom_inst_o                                  ;                               

    //if_id module
    wire    [`INST_BUS]                 ifid_inst_addr_o                            ;                               
    wire    [`INST_BUS]                 ifid_inst_o                                 ;                               

    //id module
    wire    [`REG_ADDR_BUS]             id_reg1_raddr_o                             ;                               
    wire    [`REG_ADDR_BUS]             id_reg2_raddr_o                             ;                               
    wire                                id_reg_we_o                                 ;                               
    wire    [`MEM_ADDR_BUS]             id_op1_o                                    ;                               
    wire    [`MEM_ADDR_BUS]             id_op2_o                                    ;                               
    wire    [`MEM_ADDR_BUS]             id_op1_jump_o                               ;                               
    wire    [`MEM_ADDR_BUS]             id_op2_jump_o                               ;                               
    wire    [`REG_ADDR_BUS]             id_reg_waddr_o                              ;                               
    wire    [`MEM_ADDR_BUS]             id_inst_addr_o                              ;                               
    wire    [`MEM_BUS]                  id_inst_o                                   ;                               
    wire    [`REG_BUS]                  id_reg1_rdata_o                             ;                               
    wire    [`REG_BUS]                  id_reg2_rdata_o                             ;                               

    //regs module
    wire    [`MEM_ADDR_BUS]             regs_reg1_rdata_o                           ;                               
    wire    [`MEM_ADDR_BUS]             regs_reg2_rdata_o                           ;                               
    wire    [`MEM_BUS]                  regs_op1_o                                  ;                               
    wire    [`MEM_BUS]                  regs_op2_o                                  ;                               
    wire    [`REG_BUS]                  sp                                          ;                               
    wire    [`REG_BUS]                  s0                                          ;                               
    wire    [`REG_BUS]                  a5                                          ;                               
    wire    [`REG_BUS]                  a4                                          ;                               
    wire    [`REG_BUS]                  a0                                          ;                               
    //TODO: ADD method to test
    wire    [`REG_BUS]                  x26                                         ;                               
    wire    [`REG_BUS]                  x27                                         ;                               

    //id_ex module
    wire    [`MEM_ADDR_BUS]             idex_inst_addr_o                            ;                               
    wire    [`MEM_BUS]                  idex_inst_o                                 ;                               
    wire    [`MEM_ADDR_BUS]             idex_op1_o                                  ;                               
    wire    [`MEM_ADDR_BUS]             idex_op2_o                                  ;                               
    wire    [`MEM_ADDR_BUS]             idex_op1_jump_o                             ;                               
    wire    [`MEM_ADDR_BUS]             idex_op2_jump_o                             ;                               
    wire                                idex_reg_we_o                               ;                               
    wire    [`REG_ADDR_BUS]             idex_reg_waddr_o                            ;                               
    wire    [`REG_BUS]                  idex_reg1_rdata_o                           ;                               
    wire    [`REG_BUS]                  idex_reg2_rdata_o                           ;                               

    //ex module
    wire                                ex_reg_we_o                                 ;                               
    wire                                ex_mem_we_o                                 ;                               
    wire                                ex_mem_req_o                                ;                               
    wire    [`REG_ADDR_BUS]             ex_reg_waddr_o                              ;                               
    wire    [`REG_BUS]                  ex_reg_wdata_o                              ;                               
    wire    [`MEM_ADDR_BUS]             ex_mem_waddr_o                              ;                               
    wire    [`MEM_ADDR_BUS]             ex_mem_raddr_o                              ;                               
    wire    [`MEM_BUS]                  ex_mem_wdata_o                              ;                               
    wire    [`MEM_ADDR_BUS]             ex_jump_addr_o                              ;                               
    wire    [`HOLD_FLAG_BUS]            ex_hold_flag_o                              ;                               
    wire                                ex_jump_flag_o                              ;                               

    assign ex_bus_req_o = ex_mem_req_o;
    assign ex_bus_we_o = ex_mem_we_o;
    assign ex_bus_addr_o = (ex_bus_we_o == `WRITE_ENABLE) ? ex_mem_waddr_o : ex_mem_raddr_o; 
    assign ex_bus_data_o = ex_mem_wdata_o;
    assign pc_addr_o = pc_o;
    assign rom_inst_o = pc_data_i;
    //ram module

    pc_reg pc_reg_inst(
        .clk(clk),
        .rst(rst),
        .start_i(`ZERO_WORD),
        .jump_flag_i(ex_jump_flag_o),
        .jump_addr_i(ex_jump_addr_o),
        .hold_flag_i(ex_hold_flag_o),
        .pc_o(pc_o)
    );


    if_id if_id_inst(
        .clk(clk),
        .rst(rst),
        .hold_flag_i(ex_hold_flag_o),
        .inst_i(rom_inst_o),
        .inst_addr_i(pc_o),
        .inst_addr_o(ifid_inst_addr_o),
        .inst_o(ifid_inst_o)
    );

    regs regs_inst(
        .clk(clk),
        .rst(rst),
        .raddr1_i(id_reg1_raddr_o),
        .raddr2_i(id_reg2_raddr_o),
        .we_i(ex_reg_we_o),
        .waddr_i(ex_reg_waddr_o),
        .wdata_i(ex_reg_wdata_o),
        .rdata1_o(regs_reg1_rdata_o),
        .rdata2_o(regs_reg2_rdata_o),
        .sp(sp),
        .s0(s0),
        .a5(a5),
        .a4(a4),
        .a0(a0)
    );
    id id_inst(
        .rst(rst),
        .inst_i(ifid_inst_o),
        .inst_addr_i(ifid_inst_addr_o),
        .reg1_rdata_i(regs_reg1_rdata_o),
        .reg2_rdata_i(regs_reg2_rdata_o),
        .reg1_raddr_o(id_reg1_raddr_o),
        .reg2_raddr_o(id_reg2_raddr_o),
        .op1_o(id_op1_o),
        .op2_o(id_op2_o),
        .op1_jump_o(id_op1_jump_o),
        .op2_jump_o(id_op2_jump_o),
        .reg_we_o(id_we_o),
        .reg_waddr_o(id_reg_waddr_o),
        .inst_addr_o(id_inst_addr_o),
        .inst_o(id_inst_o),
        .reg1_rdata_o(id_reg1_rdata_o),
        .reg2_rdata_o(id_reg2_rdata_o)
    );

    id_ex id_ex_inst(
        .clk(clk),
        .rst(rst),
        .op1_i(id_op1_o),
        .op2_i(id_op2_o),
        .op1_jump_i(id_op1_jump_o),
        .op2_jump_i(id_op2_jump_o),
        .reg_we_i(id_we_o),
        .reg_waddr_i(id_reg_waddr_o),
        .inst_addr_i(id_inst_addr_o),
        .inst_i(id_inst_o),
        .reg1_rdata_i(id_reg1_rdata_o),
        .reg2_rdata_i(id_reg2_rdata_o),
        .hold_flag_i(ex_hold_flag_o),
        .reg1_rdata_o(idex_reg1_rdata_o),
        .reg2_rdata_o(idex_reg2_rdata_o),
        .inst_addr_o(idex_inst_addr_o),
        .inst_o(idex_inst_o),
        .op1_o(idex_op1_o),
        .op2_o(idex_op2_o),
        .op1_jump_o(idex_op1_jump_o),
        .op2_jump_o(idex_op2_jump_o),
        .reg_we_o(idex_reg_we_o),
        .reg_waddr_o(idex_reg_waddr_o)
    );

    ex ex_inst(
        .clk(clk),
        .rst(rst),
        .op1_i(idex_op1_o),
        .op2_i(idex_op2_o),
        .op1_jump_i(idex_op1_jump_o),
        .op2_jump_i(idex_op2_jump_o),
        .inst_addr_i(idex_inst_addr_o),
        .inst_i(idex_inst_o),
        .reg_we_i(idex_reg_we_o),
        .reg_waddr_i(idex_reg_waddr_o),
        .reg1_rdata_i(idex_reg1_rdata_o),
        .reg2_rdata_i(idex_reg2_rdata_o),
        .reg_we_o(ex_reg_we_o),
        .reg_waddr_o(ex_reg_waddr_o),
        .reg_wdata_o(ex_reg_wdata_o),
        .mem_rdata_i(ex_bus_data_i),
        .mem_we_o(ex_mem_we_o),
        .mem_req_o(ex_mem_req_o),
        .mem_raddr_o(ex_mem_raddr_o),
        .mem_waddr_o(ex_mem_waddr_o),
        .mem_wdata_o(ex_mem_wdata_o),
        .jump_addr_o(ex_jump_addr_o),
        .jump_flag_o(ex_jump_flag_o),
        .hold_flag_o(ex_hold_flag_o)
    );

endmodule //top
