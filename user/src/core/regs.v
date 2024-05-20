`include "defines.v"

module regs(

    input   wire                        clk                                         ,                   
    input   wire                        rst                                         ,                   

    // from ex
    input   wire                        we_i                                        ,           // 写寄存器标志
    input   wire    [`REG_ADDR_BUS]     waddr_i                                     ,           // 写寄存器地址
    input   wire    [`REG_BUS]          wdata_i                                     ,           // 写寄存器数据

    // from id
    input   wire    [`REG_ADDR_BUS]     raddr1_i                                    ,           // 读寄存器1地址

    // to id
    output  reg     [`REG_BUS]          rdata1_o                                    ,           // 读寄存器1数据

    // from id
    input   wire    [`REG_ADDR_BUS]     raddr2_i                                    ,           // 读寄存器2地址

    // to id
    output  reg     [`REG_BUS]          rdata2_o                                                // 读寄存器2数据

    );

    reg     [`REG_BUS]                  regs                        [0:`REG_NUM - 1];                               
    

    // write regs
    always @ (posedge clk) begin
        if (rst == `RSTN) begin
            if ((we_i == `WRITE_ENABLE) && (waddr_i != `ZERO_REG)) begin
                regs[waddr_i] <= wdata_i;
            end
        end
    end

    // read reg1
    always @ (*) begin
        if (raddr1_i == `ZERO_REG) begin
            rdata1_o = `ZERO_WORD;
        // 如果读地址等于写地址，并且正在写操作，则直接返回写数据
        end else if (raddr1_i == waddr_i && we_i == `WRITE_ENABLE) begin
            rdata1_o = wdata_i;
        end else begin
            rdata1_o = regs[raddr1_i];
        end
    end

    // read reg2
    always @ (*) begin
        if (raddr2_i == `ZERO_REG) begin
            rdata2_o = `ZERO_WORD;
        // 如果读地址等于写地址，并且正在写操作，则直接返回写数据
        end else if (raddr2_i == waddr_i && we_i == `WRITE_ENABLE) begin
            rdata2_o = wdata_i;
        end else begin
            rdata2_o = regs[raddr2_i];
        end
    end
endmodule
