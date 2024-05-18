module pc_reg (
    input   wire                        clk                                         ,                   
    input   wire                        rst                                         ,                   
    input   wire                        jump_flag                                   ,                   
    input   wire    [31:0]              jump_addr                                   ,                   
    output  reg     [31:0]              pc_out                                                          
);
    always @(posedge clk)begin
        if(rst == 1'b1)begin
            pc_out <= 32'b0;
        end
        else if(jump_flag == 1'b1)begin
            pc_out <= jump_addr;
        end
        else begin
            pc_out <= pc_out + 4'h4;
        end
    end
endmodule //pc_reg
