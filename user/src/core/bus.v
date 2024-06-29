`include "../core/defines.v"

//NOTE:m0_req_i为ex.v的总线访问请求,m1_bus_req_i为pc_reg的读指令,始终为1
//s0:0000 rom
//s1:0001 ram
//s2:0010 gpio
module bus(
        //主设备0读写地址
    input   wire    [`MEM_ADDR_BUS]     m0_addr_i                                   ,                   
        //主设备0写数据
    input   wire    [`MEM_BUS]          m0_wdata_i                                  ,                   
    input   wire                        m0_bus_req_i                                ,                   
    input   wire                        m0_we_i                                     ,                   
    output  reg     [`MEM_BUS]          m0_rdata_o                                  ,                   
        //主设备1读写地址
    input   wire    [`MEM_ADDR_BUS]     m1_addr_i                                   ,                   
        //主设备1写数据
    input   wire    [`MEM_BUS]          m1_wdata_i                                  ,                   
    input   wire                        m1_bus_req_i                                ,                   
    input   wire                        m1_we_i                                     ,                   
    output  reg     [`MEM_BUS]          m1_rdata_o                                  ,                   
        //从设备0读、写地址
    output  reg     [`MEM_ADDR_BUS]     s0_addr_o                                   ,                   
    output  reg                         s0_we_o                                     ,                   
        //从设备0写数据
    output  reg     [`MEM_BUS]          s0_wdata_o                                  ,                   
    input   wire    [`MEM_BUS]          s0_rdata_i                                  ,                   
        //从设备1读、写地址
    output  reg     [`MEM_ADDR_BUS]     s1_addr_o                                   ,                   
    output  reg                         s1_we_o                                     ,                   
        //从设备1写数据
    output  reg     [`MEM_BUS]          s1_wdata_o                                  ,                   
    input   wire    [`MEM_BUS]          s1_rdata_i                                  ,                   
        //从设备2读、写地址
    output  reg     [`MEM_ADDR_BUS]     s2_addr_o                                   ,                   
    output  reg                         s2_we_o                                     ,                   
        //从设备2写数据
    output  reg     [`MEM_BUS]          s2_wdata_o                                  ,                   
    input   wire    [`MEM_BUS]          s2_rdata_i                                  ,                   

    output  reg                         bus_hold_flag_o                                                 
    );

    parameter   slave0              =               4                           'b0000; 
    parameter   slave1              =               4                           'b0001; 
    parameter   slave2              =               4                           'b0010; 
    parameter   slave3              =               4                           'b0011; 

    localparam grant0 = 1'b0;
    localparam grant1 = 1'b1;

    reg                                 grant                                       ;                               
    always @(*) begin
        if(m0_bus_req_i == 1'b1) begin
            grant = grant0;
            bus_hold_flag_o = `HOLD_ENABLE;
        end
        else if(m1_bus_req_i == 1'b1) begin
            grant = grant1;
            bus_hold_flag_o = `HOLD_DISABLE;
        end
    end

    always @(*) begin
        m0_rdata_o = `ZERO_WORD;
        m1_rdata_o = `INST_NOP;
        s0_addr_o = `ZERO_WORD;
        s0_wdata_o = `ZERO_WORD;
        s0_we_o = `WRITE_DISABLE;
        s1_addr_o = `ZERO_WORD;
        s1_wdata_o = `ZERO_WORD;
        s1_addr_o = `ZERO_WORD;
        s2_wdata_o = `ZERO_WORD;
        s2_we_o = `WRITE_DISABLE;
        s2_we_o = `WRITE_DISABLE;
        case(grant)
            grant0:
            case(m0_addr_i[31:28])
                slave0: begin
                    s0_we_o = m0_we_i;
                    s0_addr_o = {4'b0000, m0_addr_i[27:0]};
                    s0_wdata_o = m0_wdata_i;
                    m0_rdata_o = s0_rdata_i;
                end
                slave1: begin
                    s1_we_o = m0_we_i;
                    s1_addr_o = {4'b0000, m0_addr_i[27:0]};
                    s1_wdata_o = m0_wdata_i;
                    m0_rdata_o = s1_rdata_i;
                end
                slave2: begin
                    s2_we_o = m0_we_i;
                    s2_addr_o = {4'b0000, m0_addr_i[27:0]};
                    s2_wdata_o = m0_wdata_i;
                    m0_rdata_o = s2_rdata_i;
                end
            endcase
            grant1:
            case(m1_addr_i[31:28])
                slave0: begin
                    s0_we_o = m1_we_i;
                    s0_addr_o = {4'b0000, m1_addr_i[27:0]};
                    s0_wdata_o = m1_wdata_i;
                    m1_rdata_o = s0_rdata_i;
                end
                slave1: begin
                    s1_we_o = m1_we_i;
                    s1_addr_o = {4'b0000, m1_addr_i[27:0]};
                    s1_wdata_o = m1_wdata_i;
                    m1_rdata_o = s1_rdata_i;
                end
                slave2: begin
                    s2_we_o = m1_we_i;
                    s2_addr_o = {4'b0000, m1_addr_i[27:0]};
                    s2_wdata_o = m1_wdata_i;
                    m1_rdata_o = s2_rdata_i;
                end
            endcase
            default: begin

            end
        endcase
    end
endmodule
