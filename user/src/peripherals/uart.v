`include "../core/defines.v"
    
module uart (
    input wire clk,
    input wire rst,
    input wire[`UART_BUS] data_i,
    output wire data_o
);

endmodule