`include "defines.v"

module ctrl(
    input wire bus_hold_flag_i,
    input wire ex_hold_flag_i,
    input wire jump_flag_i,
    input wire [`MEM_ADDR_BUS] jump_addr_i,
    output reg jump_flag_o,
    output reg[`MEM_ADDR_BUS] jump_addr_o,
    output reg [`HOLD_FLAG_BUS] hold_flag_o
);

    always@(*)begin
        jump_flag_o = jump_addr_i;
        jump_addr_o = jump_addr_i;
        hold_flag_o = `HOLD_NONE;
        if() 
    end
endmodule