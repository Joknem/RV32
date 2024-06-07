`include "defines.v"

module id(
    input   wire                        rst                                         ,                   
    //from if_id
    input   wire    [`INST_ADDR_BUS]    inst_addr_i                                 ,                   
    input   wire    [`INST_BUS]         inst_i                                      ,                   

    //from regs
    input   wire    [`REG_BUS]          reg1_rdata_i                                ,                   
    input   wire    [`REG_BUS]          reg2_rdata_i                                ,                   

    //to regs
    output  reg     [`REG_ADDR_BUS]     reg1_raddr_o                                ,                   
    output  reg     [`REG_ADDR_BUS]     reg2_raddr_o                                ,                   
    

    //to id_ex
    output  reg     [`REG_BUS]          reg1_rdata_o                                ,                   
    output  reg     [`REG_BUS]          reg2_rdata_o                                ,                   
    output  reg     [`MEM_ADDR_BUS]     op1_o                                       ,                   
    output  reg     [`MEM_ADDR_BUS]     op2_o                                       ,                   
    output  reg     [`MEM_ADDR_BUS]     op1_jump_o                                  ,                   
    output  reg     [`MEM_ADDR_BUS]     op2_jump_o                                  ,                   
    output  reg                         reg_we_o                                    ,                   
    output  reg     [`REG_ADDR_BUS]     reg_waddr_o                                 ,                   
    output  reg     [`MEM_ADDR_BUS]     inst_addr_o                                 ,                   
    output  reg     [`MEM_BUS]          inst_o                                                          


);
    wire [`OPCODE_BUS] opcode = inst_i[6:0];
    wire [`FUNCT3_BUS] funct3 = inst_i[14:12];
    wire [`FUNCT7_BUS] funct7 = inst_i[31:25];
    wire[`REG_ADDR_BUS] rd = inst_i[11:7];
    wire[`REG_ADDR_BUS] rs1 = inst_i[19:15];
    wire[`REG_ADDR_BUS] rs2 = inst_i[24:20];

    always @(*)begin
        inst_o = inst_i;
        inst_addr_o = inst_addr_i;
        reg1_raddr_o = rs1;
        reg2_raddr_o = rs2;
        reg1_rdata_o = reg1_rdata_i;
        reg2_rdata_o = reg2_rdata_i;
        op1_o = `ZERO_WORD;
        op2_o = `ZERO_WORD;

        case(opcode)
            `INST_TYPE_I:begin
                case(funct3)
                    `INST_ADDI, `INST_SLTI, `INST_SLTIU, `INST_XORI, `INST_ORI, `INST_ANDI, `INST_SLLI, `INST_SRI: begin
                        reg_we_o = `WRITE_ENABLE;
                        reg_waddr_o = rd;
                        reg1_raddr_o = rs1;
                        reg2_raddr_o = `ZERO_REG;
                        op1_o = reg1_rdata_i;
                        op2_o = {{20{inst_i[31]}}, inst_i[31:20]};
                    end
                    default: begin
                        reg_we_o = `WRITE_DISABLE;
                        reg_waddr_o = `ZERO_REG;
                        reg1_raddr_o = `ZERO_REG;
                        reg2_raddr_o = `ZERO_REG;
                    end
                endcase
            end
            `INST_TYPE_R:begin
                case(funct3)
                    `INST_ADD, `INST_SLL, `INST_SLT, `INST_SLTU, `INST_XOR, `INST_SR, `INST_OR, `INST_AND: begin
                            reg_we_o = `WRITE_ENABLE;
                            reg_waddr_o = rd;
                            reg1_raddr_o = rs1;
                            reg2_raddr_o = rs2;
                            op1_o = reg1_rdata_i;
                            op2_o = reg2_rdata_i;
                    end
                    default:begin
                        reg_we_o = `WRITE_DISABLE;
                        reg_waddr_o = `ZERO_REG;
                        reg1_raddr_o = `ZERO_REG;
                        reg2_raddr_o = `ZERO_REG;
                    end
                endcase
            end
            `INST_TYPE_L: begin
                case (funct3)
                    `INST_LB, `INST_LH, `INST_LW, `INST_LBU, `INST_LHU: begin
                        reg1_raddr_o = rs1;
                        reg2_raddr_o = `ZERO_REG;
                        reg_we_o = `WRITE_ENABLE;
                        reg_waddr_o = rd;
                        op1_o = reg1_rdata_i;
                        op2_o = {{20{inst_i[31]}}, inst_i[31:20]};
                    end
                    default: begin
                        reg1_raddr_o = `ZERO_REG;
                        reg2_raddr_o = `ZERO_REG;
                        reg_we_o = `WRITE_DISABLE;
                        reg_waddr_o = `ZERO_REG;
                    end
                endcase
            end
            `INST_TYPE_S: begin
                case (funct3)
                    `INST_SB, `INST_SW, `INST_SH: begin
                        reg1_raddr_o = rs1;
                        reg2_raddr_o = rs2;
                        reg_we_o = `WRITE_DISABLE;
                        reg_waddr_o = `ZERO_REG;
                        op1_o = reg1_rdata_i;
                        op2_o = {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]};
                    end
                    default: begin
                        reg1_raddr_o = `ZERO_REG;
                        reg2_raddr_o = `ZERO_REG;
                        reg_we_o = `WRITE_DISABLE;
                        reg_waddr_o = `ZERO_REG;
                    end
                endcase
            end
            `INST_TYPE_B: begin
                case (funct3)
                    `INST_BEQ, `INST_BNE, `INST_BLT, `INST_BGE, `INST_BLTU, `INST_BGEU: begin
                        reg1_raddr_o = rs1;
                        reg2_raddr_o = rs2;
                        reg_we_o = `WRITE_DISABLE;
                        reg_waddr_o = `ZERO_REG;
                        op1_o = reg1_rdata_i;
                        op2_o = reg2_rdata_i;
                        op1_jump_o = inst_addr_i;
                        op2_jump_o = {{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
                    end
                    default: begin
                        reg1_raddr_o = `ZERO_REG;
                        reg2_raddr_o = `ZERO_REG;
                        reg_we_o = `WRITE_DISABLE;
                        reg_waddr_o = `ZERO_REG;
                    end
                endcase
            end
            `INST_JAL: begin
                reg_we_o = `WRITE_ENABLE;
                reg_waddr_o = rd;
                reg1_raddr_o = `ZERO_REG;
                reg2_raddr_o = `ZERO_REG;
                op1_o = inst_addr_i;
                op2_o = 32'h4;
                op1_jump_o = inst_addr_i;
                op2_jump_o = {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
            end
            `INST_JALR: begin
                reg_we_o = `WRITE_ENABLE;
                reg1_raddr_o = rs1;
                reg2_raddr_o = `ZERO_REG;
                reg_waddr_o = rd;
                op1_o = inst_addr_i;
                op2_o = 32'h4;
                op1_jump_o = reg1_rdata_i;
                op2_jump_o = {{20{inst_i[31]}}, inst_i[31:20]};
            end
            `INST_LUI: begin
                reg_we_o = `WRITE_ENABLE;
                reg_waddr_o = rd;
                reg1_raddr_o = `ZERO_REG;
                reg2_raddr_o = `ZERO_REG;
                op1_o = {inst_i[31:12], 12'b0};
                op2_o = `ZERO_WORD;
            end
            `INST_AUIPC: begin
                reg_we_o = `WRITE_ENABLE;
                reg_waddr_o = rd;
                reg1_raddr_o = `ZERO_REG;
                reg2_raddr_o = `ZERO_REG;
                op1_o = inst_addr_i;
                op2_o = {inst_i[31:12], 12'b0};
            end
            `INST_NOP_OP: begin
                reg_we_o = `WRITE_DISABLE;
                reg_waddr_o = `ZERO_REG;
                reg1_raddr_o = `ZERO_REG;
                reg2_raddr_o = `ZERO_REG;
            end
            default:begin
                reg_we_o = `WRITE_DISABLE;
                reg_waddr_o = `ZERO_REG;
                reg1_raddr_o = `ZERO_REG;
                reg2_raddr_o = `ZERO_REG;
            end
        endcase
    end
endmodule //decode
