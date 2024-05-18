`include "defines.v"

module id(
    input   wire                        rst                                         ,                   
    //from if_id
    input   wire    [`INST_ADDR_BUS]    inst_addr_i                                 ,                   
    input   wire    [`INST_BUS]         inst_i                                      ,                   

    //from regs
    input   wire    [`REG_BUS]          reg1_rdata_i                                 ,                   
    input   wire    [`REG_BUS]          reg2_rdata_i                                 ,                   

    //to regs
    output  reg     [`REG_ADDR_BUS]     reg1_raddr_o                                ,                   
    output  reg     [`REG_ADDR_BUS]     reg2_raddr_o                                ,                   
    

    //to ex
    output  reg     [`MEM_ADDR_BUS]     op1_o                                       ,                   
    output  reg     [`MEM_ADDR_BUS]     op2_o                                       ,                   
    output  reg                         reg_we_o                                    ,                   
    output  reg     [`REG_ADDR_BUS]     reg_waddr_o                                                     

);
    wire [`FUNCT7_BUS] opcode = inst_i[6:0];
    wire [`FUNCT3_BUS] funct3 = inst_i[14:12];
    wire [`FUNCT7_BUS] funct7 = inst_i[31:25];
    wire[`REG_ADDR_BUS] rd = inst_i[11:7];
    wire[`REG_ADDR_BUS] rs1 = inst_i[19:15];
    wire[`REG_ADDR_BUS] rs2 = inst_i[24:20];

    always @(*)begin
        reg1_raddr_o = rs1;
        reg2_raddr_o = rs2;
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
                    `INST_ADD_SUB, `INST_SLL, `INST_SLT, `INST_SLTU, `INST_XOR, `INST_SR, `INST_OR, `INST_AND: begin
                            reg_we_o = `WRITE_DISABLE;
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
            default:begin

            end
        endcase
    end
endmodule //decode
