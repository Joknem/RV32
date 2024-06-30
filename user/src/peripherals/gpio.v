`include "../core/defines.v"

module gpio (
    input   wire                        clk                                         ,                   
    input   wire                        rst                                         ,                   
    input   wire                        we_i                                        ,                   
    input   wire    [`MEM_ADDR_BUS]     addr_i                                      ,                   
    input   wire    [`MEM_BUS]          wdata_i                                     ,                   
    output  reg     [`REG_BUS]          rdata_o                                     ,                   
    input   wire    [`IO_NUM_BUS]       io_pin_i                                    ,                   
    output  wire    [`REG_BUS]          reg_ctrl_o                                  ,                   
    output  wire    [`REG_BUS]          reg_data_o                                                      
);

    localparam  GPIO_CTRL           =               4                           'h0;    
    localparam  GPIO_DATA           =               4                           'h4;    

//NOTE:每两位控制一个GPIO引脚,0:高阻，1:输出,2:输入
    reg     [`REG_BUS]                  gpio_ctrl                                   ;                               
    reg     [`REG_BUS]                  gpio_data                                   ;                               
    assign reg_ctrl_o = gpio_ctrl;
    assign reg_data_o = gpio_data;

//write gpio reg
always @(posedge clk)begin
    if(rst == `RSTN)begin
        gpio_ctrl <= `ZERO_WORD;
        gpio_data <= `ZERO_WORD;
    end
    else begin
        if(we_i == `WRITE_ENABLE)begin
            case(addr_i[3:0])
                GPIO_CTRL:begin
                    gpio_ctrl <= wdata_i;
                end
                GPIO_DATA:begin
                    gpio_data <= wdata_i;
                end
                default:begin
                    gpio_ctrl <= `ZERO_WORD;
                    gpio_data <= `ZERO_WORD;
                end
            endcase
        end
        else begin
            if(gpio_ctrl[1:0] == `INPUT)begin
                gpio_data[0] <= io_pin_i[0];
            end
            if(gpio_ctrl[3:2] == `INPUT)begin
                gpio_data[1] <= io_pin_i[1];
            end
        end
    end
end
//read gpio reg
always @(*)begin
    if(rst == `RSTN)begin
        rdata_o = `ZERO_WORD;
        rdata_o = `ZERO_WORD;
    end
    else begin
        case(addr_i[3:0])
            GPIO_CTRL:begin
                rdata_o = gpio_ctrl;
            end
            GPIO_DATA:begin
                rdata_o = gpio_data;
            end
            default:begin
                rdata_o = `ZERO_WORD;
            end
        endcase
    end
end
endmodule
