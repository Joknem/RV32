`include "../core/defines.v"

module ram (
    input   wire                        clk                                         ,                   
    input   wire                        rst                                         ,                   
    input   wire                        we_i                                        ,                   
    input   wire    [`MEM_BUS]          wdata_i                                     ,                   
    input   wire    [`MEM_ADDR_BUS]     addr_i                                      ,                   
    //tests below
    output  reg     [`MEM_BUS]          rdata_o                                                         
);
    reg     [`MEM_BUS]                  ram                         [0:`MEM_SIZE-1] ;                               
    initial begin : ram_init
        integer i;
        for(i = 0; i < `MEM_SIZE; i++) begin
            ram[i] = `ZERO_WORD;
        end
    end


    always @(*)begin
        if(rst == `RST)begin
            rdata_o = `ZERO_WORD;
        end
        else begin
            rdata_o = ram[{4'b0000, addr_i[27:2], 2'b0}];
        end
    end

    always @(posedge clk)begin
        if(we_i == `WRITE_ENABLE) begin
            ram[{4'b0000, addr_i[27:2], 2'b0}] <= wdata_i;
        end
        else begin
        end
    end
endmodule
