`include "defines.v"

module ex(
    input   wire                        clk                                         ,                   
    input   wire                        rst                                         ,                   

    //from id_ex
    input   wire    [`MEM_BUS]          op1_i                                       ,                   
    input   wire    [`MEM_BUS]          op2_i                                       ,                   
    input   wire    [`MEM_BUS]          op1_jump_i                                  ,                   
    input   wire    [`MEM_BUS]          op2_jump_i                                  ,                   
    input   wire    [`MEM_ADDR_BUS]     inst_addr_i                                 ,                   
    input   wire    [`MEM_ADDR_BUS]     inst_i                                      ,                   
    input   wire                        reg_we_i                                    ,                   
    input   wire    [`REG_ADDR_BUS]     reg_waddr_i                                 ,                   
    input   wire    [`REG_BUS]          reg1_rdata_i                                ,                   
    input   wire    [`REG_BUS]          reg2_rdata_i                                ,                   

    //from mem
    input   wire    [`MEM_BUS]          mem_rdata_i                                 ,                   

    //to regs
    output  wire                        reg_we_o                                    ,                   
    output  wire    [`REG_ADDR_BUS]     reg_waddr_o                                 ,                   
    output  wire    [`REG_BUS]          reg_wdata_o                                 ,                   

    //to mem
    output  reg                         mem_we_o                                    ,                   
    output  reg     [`MEM_ADDR_BUS]     mem_raddr_o                                 ,                   
    output  reg     [`MEM_ADDR_BUS]     mem_waddr_o                                 ,                   
    output  reg     [`MEM_BUS]          mem_wdata_o                                 ,                   

    //to pc_reg
    output  reg                         jump_flag_o                                 ,                   
    output  reg     [`MEM_ADDR_BUS]     jump_addr_o                                 ,                   

    output  reg     [`HOLD_FLAG_BUS]    hold_flag_o                                                     
);
    wire    [`OPCODE_BUS]               opcode                                      ;                               
    wire    [`FUNCT7_BUS]               funct7                                      ;                               
    wire    [`FUNCT3_BUS]               funct3                                      ;                               
    wire    [`REG_ADDR_BUS]             rd                                          ;                               
    wire    [`MEM_BUS]                  op1_add_op2                                 ;                               
    wire    [`MEM_ADDR_BUS]             op1_jump_add_op2_jump                       ;                               
    reg                                 reg_we                                      ;                               
    reg     [`REG_ADDR_BUS]             reg_waddr                                   ;                               
    reg     [`REG_BUS]                  reg_wdata                                   ;                               

    assign opcode = inst_i[6:0];
    assign funct7 = inst_i[31:25];
    assign funct3 = inst_i[14:12];
    assign rd = inst_i[11:7];
    assign reg_wdata_o = reg_wdata;
    assign reg_waddr_o = reg_waddr;
    assign op1_add_op2 = op1_i + op2_i;
    assign op1_jump_add_op2_jump = op1_jump_i + op2_jump_i;
    assign reg_we_o = reg_we;


    always @(*)begin
        reg_we = reg_we_i;
        reg_waddr = reg_waddr_i;
        jump_addr_o = `ZERO_WORD;
        case(opcode)
            `INST_TYPE_I:begin
                mem_we_o = `WRITE_DISABLE;
                mem_wdata_o = `ZERO_WORD;
                mem_waddr_o = `ZERO_WORD;
                mem_raddr_o = `ZERO_WORD;
                jump_flag_o = `JUMP_NO;
                hold_flag_o = `HOLD_NONE;
                case(funct3)
                    `INST_ADDI:begin
                        reg_wdata = op1_add_op2;
                    end
                    `INST_ANDI:begin
                        reg_wdata = op1_i & op2_i;
                    end
                    `INST_ORI:begin
                        reg_wdata = op1_i | op2_i;
                    end
                    `INST_XORI:begin
                        reg_wdata = op1_i ^ op2_i;
                    end
                    `INST_SLLI:begin
                        reg_wdata = op1_i << op2_i;
                    end
                    `INST_SLTI:begin
                        reg_wdata = (op1_i < op2_i) ? 32'h00000001 : `ZERO_WORD;
                    end
                    `INST_SLTIU:begin
                        reg_wdata = ($unsigned(op1_i) < $unsigned(op2_i)) ? 32'h00000001 : `ZERO_WORD;
                    end
                    `INST_SRI: begin
                        if (inst_i[30] == 1'b1) begin
                            //TODO: 算数右移
                        end else begin
                            //逻辑右移
                        end
                    end
                    default:begin
                    end
                endcase
            end
            `INST_TYPE_R:begin
                mem_we_o = `WRITE_DISABLE;
                mem_wdata_o = `ZERO_WORD;
                mem_waddr_o = `ZERO_WORD;
                mem_raddr_o = `ZERO_WORD;
                jump_flag_o = `JUMP_NO;
                hold_flag_o = `HOLD_NONE;
                case(funct3)
                    `INST_ADD:begin
                        reg_wdata = op1_add_op2;
                    end
                    `INST_SLL:begin
                        reg_wdata = op1_i << op2_i[4:0];
                    end
                    `INST_SLT:begin
                        reg_wdata = (op1_i < op2_i) ? 32'h00000001 : `ZERO_WORD;
                    end
                    `INST_SLTU:begin
                        reg_wdata = ($unsigned(op1_i) < $unsigned(op2_i)) ? 32'h00000001 : `ZERO_WORD;
                    end
                    `INST_XOR:begin
                        reg_wdata = op1_i ^ op2_i;
                    end
                    `INST_SR:begin
                        
                    end
                    `INST_OR:begin
                        reg_wdata = op1_i | op2_i;
                    end
                    `INST_AND:begin
                        reg_wdata = op1_i & op2_i;
                    end
                    default:begin
                    end
                endcase
            end
            `INST_TYPE_L:begin
                mem_we_o = `WRITE_DISABLE;
                mem_wdata_o = `ZERO_WORD;
                mem_waddr_o = `ZERO_WORD;
                mem_raddr_o = op1_add_op2;
                jump_flag_o = `JUMP_NO;
                hold_flag_o = `HOLD_NONE;
                case(funct3)
                    `INST_LB:begin
                        reg_wdata = {{24{mem_rdata_i[7]}}, mem_rdata_i[7:0]};
                    end
                    `INST_LH:begin
                        reg_wdata = {{16{mem_rdata_i[15]}}, mem_rdata_i[15:0]};
                    end
                    `INST_LW:begin
                        reg_wdata = mem_rdata_i;
                    end
                    `INST_LBU:begin
                        reg_wdata = {24'h0, mem_rdata_i[7:0]};
                    end
                    `INST_LHU:begin
                        reg_wdata = {16'h0, mem_rdata_i[15:0]};
                    end
                    default:begin
                    end
                endcase
            end
            `INST_TYPE_S:begin
                mem_we_o = `WRITE_ENABLE;
                mem_waddr_o = op1_add_op2;
                mem_raddr_o = op1_add_op2;
                reg_wdata = `ZERO_WORD;
                jump_flag_o = `JUMP_NO;
                hold_flag_o = `HOLD_NONE;
                case(funct3)
                    `INST_SB:begin
                        mem_wdata_o = {mem_rdata_i[31:8], reg2_rdata_i[7:0]};
                    end
                    `INST_SH:begin
                        mem_wdata_o = {mem_rdata_i[31:16], reg2_rdata_i[15:0]};
                    end
                    `INST_SW:begin
                        mem_wdata_o = reg2_rdata_i;
                    end
                    default:begin
                    end
                endcase
            end
            `INST_TYPE_B:begin
                mem_we_o = `WRITE_DISABLE;
                reg_wdata = `ZERO_WORD;
                reg_we = `WRITE_DISABLE;
                hold_flag_o = `HOLD_NONE;
                case(funct3)
                    `INST_BEQ:begin
                        jump_flag_o = (op1_i == op2_i);
                        hold_flag_o = {3{jump_flag_o}} & `HOLD_ID;
                        jump_addr_o = {32{jump_flag_o}} & op1_jump_add_op2_jump;
                    end   
                    `INST_BNE:begin
                        jump_flag_o = (op1_i != op2_i);
                        hold_flag_o = {3{jump_flag_o}} & `HOLD_ID;
                        jump_addr_o = {32{jump_flag_o}} & op1_jump_add_op2_jump;
                    end   
                    `INST_BLT:begin
                        jump_flag_o = (op1_i < op2_i);
                        hold_flag_o = {3{jump_flag_o}} & `HOLD_ID;
                        jump_addr_o = {32{jump_flag_o}} & op1_jump_add_op2_jump;
                    end
                    `INST_BGE:begin
                        jump_flag_o = (op1_i >= op2_i);
                        hold_flag_o = {3{jump_flag_o}} & `HOLD_ID;
                        jump_addr_o = {32{jump_flag_o}} & op1_jump_add_op2_jump;
                    end
                    `INST_BLTU:begin
                        jump_flag_o = ($unsigned(op1_i) < $unsigned(op2_i));
                        hold_flag_o = {3{jump_flag_o}} & `HOLD_ID;
                        jump_addr_o = {32{jump_flag_o}} & op1_jump_add_op2_jump;
                    end
                    `INST_BGEU:begin
                        jump_flag_o = ($unsigned(op1_i) >= $unsigned(op2_i));
                        hold_flag_o = {3{jump_flag_o}} & `HOLD_ID;
                        jump_addr_o = {32{jump_flag_o}} & op1_jump_add_op2_jump;
                    end
                    default:begin
                        jump_flag_o = `JUMP_NO;
                        jump_addr_o = `ZERO_WORD;
                        hold_flag_o = `HOLD_NONE;
                    end
                endcase
            end
            `INST_JAL:begin
                mem_we_o = `WRITE_DISABLE;
                mem_waddr_o = `ZERO_WORD;
                mem_wdata_o = `ZERO_WORD;
                mem_raddr_o = `ZERO_WORD;
                reg_wdata = op1_add_op2;
                jump_flag_o = `JUMP_YES;
                jump_addr_o = op1_jump_add_op2_jump;
                hold_flag_o = `HOLD_ID;
            end
            `INST_JALR:begin
                mem_we_o = `WRITE_DISABLE;
                mem_waddr_o = `ZERO_WORD;
                mem_wdata_o = `ZERO_WORD;
                mem_raddr_o = `ZERO_WORD;
                reg_wdata = op1_add_op2;
                jump_flag_o = `JUMP_YES;
                jump_addr_o = op1_jump_add_op2_jump;
                hold_flag_o = `HOLD_ID;
            end
            `INST_LUI, `INST_AUIPC:begin
                mem_we_o = `WRITE_DISABLE;
                mem_waddr_o = `ZERO_WORD;
                mem_wdata_o = `ZERO_WORD;
                mem_raddr_o = `ZERO_WORD;
                reg_wdata = op1_add_op2;
                jump_flag_o = `JUMP_NO;
                jump_addr_o = `ZERO_WORD;
                hold_flag_o = `HOLD_NONE;
            end
            `INST_NOP_OP:begin
                mem_we_o = `WRITE_DISABLE;
                mem_waddr_o = `ZERO_WORD;
                mem_wdata_o = `ZERO_WORD;
                mem_raddr_o= `ZERO_WORD;
                reg_wdata = `ZERO_WORD;
                jump_flag_o = `JUMP_NO;
                jump_addr_o = `ZERO_WORD;
                hold_flag_o = `HOLD_NONE;
            end
            default:begin
                mem_we_o = `WRITE_DISABLE;
                mem_waddr_o = `ZERO_WORD;
                mem_wdata_o = `ZERO_WORD;
                mem_raddr_o= `ZERO_WORD;
                reg_wdata = `ZERO_WORD;
                jump_flag_o = `JUMP_NO;
                jump_addr_o = `ZERO_WORD;
                hold_flag_o = `HOLD_NONE;
            end
        endcase
    end
endmodule //ex
