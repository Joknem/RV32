`timescale 1ns/1ns

`include "../src/core/defines.v"
`include "../src/core/pc_reg.v"
`include "../src/core/if_id.v"
`include "../src/utils/gen_dff.v"
`include "../src/peripherals/rom.v"
`include "../src/core/regs.v"
`include "../src/core/id.v"
`include "../src/core/id_ex.v"
`include "../src/core/ex.v"


module top();
    reg clk;
    reg rst;
    reg jump_flag_i;
    reg [`MEM_ADDR_BUS] start_i;
    reg [`MEM_ADDR_BUS] jump_addr_i;
    reg [`HOLD_FLAG_BUS] hold_flag_i;
    wire [`MEM_ADDR_BUS] pc_o;

    //rom module
    wire[`INST_BUS] rom_inst_o;

    //if_id module
    wire[`INST_BUS] ifid_inst_addr_o;
    wire[`INST_BUS] ifid_inst_o;

    //id module
    wire [`REG_ADDR_BUS] id_reg1_raddr_o;
    wire [`REG_ADDR_BUS] id_reg2_raddr_o;
    wire id_reg_we_o;
    wire [`MEM_ADDR_BUS] id_op1_o;
    wire [`MEM_ADDR_BUS] id_op2_o;
    wire [`REG_ADDR_BUS] id_reg_waddr_o;
    wire [`MEM_ADDR_BUS] id_inst_addr_o;
    wire [`MEM_BUS] id_inst_o;
    wire [`REG_BUS] id_reg1_rdata_o;
    wire [`REG_BUS] id_reg2_rdata_o;

    //regs module
    wire [`MEM_ADDR_BUS] regs_reg1_rdata_o;
    wire [`MEM_ADDR_BUS] regs_reg2_rdata_o;
    wire [`MEM_BUS] regs_op1_o;
    wire [`MEM_BUS] regs_op2_o;

    //id_ex module
    wire [`MEM_ADDR_BUS] idex_inst_addr_o;
    wire [`MEM_BUS] idex_inst_o;
    wire [`MEM_ADDR_BUS] idex_op1_o;
    wire [`MEM_ADDR_BUS] idex_op2_o;
    wire idex_reg_we_o;
    wire [`REG_ADDR_BUS] idex_reg_waddr_o;
    wire [`REG_BUS] idex_reg1_rdata_o;
    wire [`REG_BUS] idex_reg2_rdata_o;

    //FIXME: this is a test

    //ex module
    wire ex_reg_we_o;
    wire ex_mem_we_o;
    wire [`REG_ADDR_BUS] ex_reg_waddr_o;
    wire [`REG_BUS] ex_reg_wdata_o;
    wire [`MEM_ADDR_BUS] ex_mem_raddr_o;
    wire [`MEM_ADDR_BUS] ex_mem_waddr_o;
    wire [`MEM_BUS] ex_mem_wdata_o;
    wire [`REG_BUS] sp;
    wire [`REG_BUS] s0;
    wire [`REG_BUS] a5;
    wire [`REG_BUS] a4;

    always #10 clk = ~clk;

    initial begin:mem_init
        integer i;
        for (i = 0; i < 32; i = i + 1) begin
            regs_inst.regs[i] = `ZERO_WORD; // 初始化
        end
    end

    initial begin
        $dumpfile("./wave.vcd");
        $dumpvars(0, pc_reg_inst);
        $dumpvars(0, rom_inst);
        $dumpvars(0, if_id_inst);
        $dumpvars(0, id_inst);
        $dumpvars(0, regs_inst);
        $dumpvars(0, id_ex_inst);
        $dumpvars(0, ex_inst);
        clk = 0;
        rst = `RSTN;
        jump_flag_i = `JUMP_NO;
        jump_addr_i = `ZERO_WORD;
        hold_flag_i = `HOLD_NONE;
        start_i = `ZERO_WORD;
        #10 rst = `RST;
        #10 rst = `RSTN;
        #100 hold_flag_i = `HOLD_NONE;
        #300 jump_flag_i = `JUMP_YES;
        jump_addr_i = 32'h00000004;
    end

    initial begin
        #3000;
        $display("Time Out.");
        $finish;
    end


    pc_reg pc_reg_inst(
        .clk(clk),
        .rst(rst),
        .start_i(start_i),
        .jump_flag_i(jump_flag_i),
        .jump_addr_i(jump_addr_i),
        .hold_flag_i(hold_flag_i),
        .pc_o(pc_o)
    );

    rom rom_inst(
        .clk(clk),
        .rst(rst),
        .addr_i(pc_o),
        .inst_o(rom_inst_o)
    );

    if_id if_id_inst(
        .clk(clk),
        .rst(rst),
        .hold_flag_i(hold_flag_i),
        .inst_i(rom_inst_o),
        .inst_addr_i(pc_o),
        .inst_addr_o(ifid_inst_addr_o),
        .inst_o(ifid_inst_o)
    );

    regs regs_inst(
        .clk(clk),
        .rst(rst),
        //FIXME: this should from execute module not decode
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
        .a4(a4)
    );

    id id_inst(
        .rst(rst),
        .inst_i(ifid_inst_o),
        .inst_addr_i(ifid_inst_addr_o),
        .reg1_rdata_i(regs_reg1_rdata_o),
        .reg2_rdata_i(regs_reg1_rdata_o),
        .reg1_raddr_o(id_reg1_raddr_o),
        .reg2_raddr_o(id_reg2_raddr_o),
        .op1_o(id_op1_o),
        .op2_o(id_op2_o),
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
        .reg_we_i(id_we_o),
        .reg_waddr_i(id_reg_waddr_o),
        .inst_addr_i(id_inst_addr_o),
        .inst_i(id_inst_o),
        .reg1_rdata_i(id_reg1_rdata_o),
        .reg2_rdata_i(id_reg2_rdata_o),
        .hold_flag_i(hold_flag_i),
        .reg1_rdata_o(idex_reg1_rdata_o),
        .reg2_rdata_o(idex_reg2_rdata_o),
        .inst_addr_o(idex_inst_addr_o),
        .inst_o(idex_inst_o),
        .op1_o(idex_op1_o),
        .op2_o(idex_op2_o),
        .reg_we_o(idex_reg_we_o),
        .reg_waddr_o(idex_reg_waddr_o)
    );

    ex ex_inst(
        .clk(clk),
        .rst(rst),
        .op1_i(idex_op1_o),
        .op2_i(idex_op2_o),
        .inst_addr_i(idex_inst_addr_o),
        .inst_i(idex_inst_o),
        .reg_we_i(idex_reg_we_o),
        .reg_waddr_i(idex_reg_waddr_o),
        .reg1_rdata_i(idex_reg1_rdata_o),
        .reg2_rdata_i(idex_reg2_rdata_o),
        .mem_data_i(32'h0),
        .reg_we_o(ex_reg_we_o),
        .reg_waddr_o(ex_reg_waddr_o),
        .reg_wdata_o(ex_reg_wdata_o),
        .mem_we_o(ex_mem_we_o),
        .mem_raddr_o(ex_mem_raddr_o),
        .mem_waddr_o(ex_mem_waddr_o),
        .mem_wdata_o(ex_mem_wdata_o)
    );


endmodule //top
