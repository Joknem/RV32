`include "../core/defines.v"

//NOTE:m0_req_i为ex.v的总线访问请求,m1_bus_req_i为pc_reg的读指令,始终为1
//s0:0000 rom
//s1:0001 ram
//s2:0010 gpio
module bus(
    input   wire                        clk                                         ,                   
    input   wire                        rst                                         ,                   
    //主设备0读写地址
    input   wire    [`MEM_ADDR_BUS]     m0_addr_i                                   ,                   
    //主设备0写数据
    input   wire    [`MEM_BUS]          m0_wdata_i                                  ,                   
    input   wire                        m0_bus_req_i                                ,                   
    input   wire                        m0_we_i                                     ,                   
    output  reg                         m0_rdata_o                                  ,                   
    //主设备1读写地址
    input   wire    [`MEM_ADDR_BUS]     m1_addr_i                                   ,                   
    //主设备1写数据
    input   wire    [`MEM_BUS]          m1_wdata_i                                  ,                   
    input   wire                        m1_bus_req_i                                ,                   
    input   wire                        m1_we_i                                     ,                   
    output  reg                         m0_rdata_o                                  ,                   
    //从设备0读、写地址
    output  reg     [`MEM_ADDR_BUS]     s0_addr_o                                   ,                   
    output  reg                         s0_we_o                                     ,                   
    //从设备0写数据
    output  reg     [`MEM_BUS]          s0_wdata_o                                                      
    input   wire    [`MEM_BUS]          s0_rdata_i                                  ,                   
    //从设备1读、写地址
    output  reg     [`MEM_ADDR_BUS]     s1_addr_o                                   ,                   
    output  reg                         s1_we_o                                     ,                   
    //从设备1写数据
    output  reg     [`MEM_BUS]          s1_wdata_o                                  ,                   
    input   wire    [`MEM_BUS]          s1_rdata_i                                  ,                   

    output  wire    [`HOLD_FLAG_BUS]    hold_flag_o                                                     
);
endmodule
