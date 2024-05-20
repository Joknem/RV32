`include "defines.v"

module pc_reg(

    input   wire                        clk                                         ,                   
    input   wire                        rst                                         ,                   

    input   wire    [`MEM_ADDR_BUS]     start_i                                     ,           // 起始地址 
    input   wire                        jump_flag_i                                 ,           // 跳转标志 
    input   wire    [`INST_ADDR_BUS]    jump_addr_i                                 ,           // 跳转地址 
    input   wire    [`HOLD_FLAG_BUS]    hold_flag_i                                 ,           // 流水线暂停标志

    output  reg     [`INST_ADDR_BUS]    pc_o                                                    // PC指针 

    );


    always @ (posedge clk) begin
        if (rst == `RST) begin
            pc_o <= `PC_RST_ADDR;
        end else if (jump_flag_i == `JUMP_YES) begin
            pc_o <= jump_addr_i;
        end else if (hold_flag_i >= `HOLD_PC) begin
            pc_o <= pc_o;
        end else begin
            pc_o <= pc_o + 32'h4;
        end
    end

endmodule
