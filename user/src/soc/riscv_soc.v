`include "../core/core.v"
`include "../core/peripherals/ram.v"
`include "../core/peripherals/rom.v"
`include "../core/peripherals/gpio.v"
`include "../core/defines.v"

module riscv_soc(
    input   wire                        clk                                         ,                   
    input   wire                        rst                                                             
);
    //core
    wire    [`MEM_ADDR_BUS]             core_m0_addr_o                              ;                               
    wire    [`MEM_BUS]                  core_m0_data_o                              ;                               
    wire                                core_m0_req_o                               ;                               
    wire                                core_m0_we_o                                ;                               
    wire    [`MEM_ADDR_BUS]             core_m1_addr_o                              ;                               

    //bus
    wire    [`MEM_BUS]                  bus_m0_data_o                               ;                               
    wire    [`MEM_BUS]                  bus_m1_data_o                               ;                               
    wire    [`MEM_ADDR_BUS]             bus_s0_addr_o                               ;                               
    wire                                bus_s0_we_o                                 ;                               
    wire    [`MEM_BUS]                  bus_s0_wdata_o                              ;                               
    wire    [`MEM_BUS]                  bus_s0_rdata_i                              ;                               
    wire    [`MEM_ADDR_BUS]             bus_s1_addr_o                               ;                               
    wire                                bus_s1_we_o                                 ;                               
    wire    [`MEM_BUS]                  bus_s1_wdata_o                              ;                               
    wire    [`MEM_BUS]                  bus_s1_rdata_i                              ;                               
    wire    [`MEM_ADDR_BUS]             bus_s2_addr_o                               ;                               
    wire                                bus_s2_we_o                                 ;                               
    wire    [`MEM_BUS]                  bus_s2_wdata_o                              ;                               
    wire    [`MEM_BUS]                  bus_s2_rdata_i                              ;                               
    wire                                bus_hold_flag_o                             ;                               

    //gpio
    wire    [`IO_NUM_BUS]               io_pin                                      ;                               
    wire    [`REG_BUS]                  gpio_ctrl                                   ;                               
    wire    [`REG_BUS]                  gpio_data                                   ;                               

    core core_inst(
        .clk(clk),
        .rst(rst),
        .bus_hold_flag_i(bus_hold_flag_o),
        .pc_addr_o(core_m1_addr_o),
        .pc_data_i(bus_m1_data_o),
        .ex_bus_data_i(bus_m0_data_o),
        .ex_bus_addr_o(core_m0_addr_o),
        .ex_bus_data_o(core_m0_data_o),
        .ex_bus_req_o(core_m0_req_o),
        .ex_bus_we_o(core_m0_we_o)
    );

    bus bus_inst(
        .m0_addr_i(core_m0_addr_o),
        .m0_wdata_i(core_m0_data_o),
        .m0_bus_req_i(core_m0_req_o),
        .m0_we_i(core_m0_we_o),
        .m0_rdata_o(bus_m0_data_o),
        .m1_addr_i(core_m1_addr_o),
        .m1_wdata_i(`ZERO_WORD),
        .m1_bus_req_i(`BUS_REQ),
        .m1_we_i(`WRITE_ENABLE),
        .m1_rdata_o(bus_m1_data_o),
        .s0_addr_o(bus_s0_addr_o),
        .s0_we_o(bus_s0_we_o),
        .s0_wdata_o(bus_s0_wdata_o),
        .s0_rdata_i(bus_s0_rdata_i),
        .s1_addr_o(bus_s1_addr_o),
        .s1_we_o(bus_s1_we_o),
        .s1_wdata_o(bus_s1_wdata_o),
        .s1_rdata_i(bus_s1_rdata_i),
        .s2_addr_o(bus_s2_addr_o),
        .s2_we_o(bus_s2_we_o),
        .s2_wdata_o(bus_s2_wdata_o),
        .s2_rdata_i(bus_s2_rdata_i),
        .bus_hold_flag_o(bus_hold_flag_o)
    );

    rom rom_inst(
        .clk(clk),
        .rst(rst),
        .addr_i(bus_s0_addr_o),
        .inst_o(bus_s0_rdata_i)
    );

    ram ram_inst(
        .clk(clk),
        .rst(rst),
        .we_i(bus_s1_we_o),
        .wdata_i(bus_s1_wdata_o),
        .addr_i(bus_s1_addr_o),
        .rdata_o(bus_s1_rdata_i)
    );

    //BUG: fix this
    gpio gpio_inst(
        .clk(clk),
        .rst(rst),
        .we_i(bus_s2_we_o),
        .addr_i(bus_s2_addr_o),
        .wdata_i(bus_s2_wdata_o),
        .rdata_o(bus_s2_rdata_i),
        .io_pin_i(io_pin),
        .reg_ctrl_o(gpio_ctrl),
        .reg_data_o(gpio_data)
    );
endmodule
