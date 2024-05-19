`include "../core/defines.v"

module rom(
    input   wire                        clk                                         ,                   
    input   wire                        rst                                         ,                   
    input   wire    [`MEM_ADDR_BUS]     addr_i                                      ,                   
    output  reg     [`INST_BUS]         inst_o                                                          
);
    reg     [`BYTE_BUS]                 _rom                        [`MEM_SIZE-1:0] ;                               
    reg     [7:0]                       i                                           ;                               
    initial begin
        $readmemh("/home/joknem/workspace/joknem_rv32/user/data/test.mem", _rom, 0, 127);
    end
    always @(*)begin
        if(rst == `RST)begin
            inst_o = `INST_NOP;
        end else begin
            inst_o = {{_rom[{addr_i[31:2], 2'b00}]},
                {_rom[{addr_i[31:2], 2'b01}]},
                {_rom[{addr_i[31:2], 2'b10}]}, 
                {_rom[{addr_i[31:2], 2'b11}]}};
        end
    end 
endmodule //rom
