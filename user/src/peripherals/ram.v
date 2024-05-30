`include "../core/defines.v"

module ram (
    input   wire                        clk                                         ,                   
    input   wire                        rst                                         ,                   
    input   wire                        we_i                                        ,                   
    input   wire    [`MEM_BUS]          wdata_i                                     ,                   
    input   wire    [`MEM_ADDR_BUS]     waddr_i                                     ,                   
    input   wire    [`MEM_ADDR_BUS]     raddr_i                                     ,                   
    output  reg     [`MEM_BUS]          rdata_o                                                         
);
    reg     [`MEM_BUS]                  ram                         [0:`MEM_SIZE-1] ;                               
    initial begin : ram_init
        integer i;
        for(i = 0; i < `MEM_SIZE - 1; i++) begin
            ram[i] = `ZERO_WORD;
        end
    end


    always @(posedge clk)begin
        if(rst == `RST)begin
            rdata_o <= `ZERO_WORD;
        end
        rdata_o <= ram[{raddr_i[31:2], 2'b0}];
    end

    always @(*)begin
        if(we_i == `WRITE_ENABLE) begin
            ram[{waddr_i[31:2], 2'b0}] = wdata_i;
        end
    end

endmodule
