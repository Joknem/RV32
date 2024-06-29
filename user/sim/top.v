`timescale 1ns/1ns

`include "../src/core/defines.v"
`include "../src/soc/riscv_soc.v"
`include "../src/core/core.v"
`include "../src/core/pc_reg.v"
`include "../src/core/if_id.v"
`include "../src/core/regs.v"
`include "../src/core/id.v"
`include "../src/core/id_ex.v"
`include "../src/core/ex.v"
`include "../src/core/bus.v"
`include "../src/peripherals/ram.v"
`include "../src/peripherals/rom.v"
`include "../src/peripherals/gpio.v"
`include "../src/utils/gen_dff.v"

module top();
    reg clk;
    reg rst;
    riscv_soc riscv_soc_inst(
        .clk(clk),
        .rst(rst)
    );
    always #10 clk = ~clk;
    initial begin
        $dumpfile("./wave.vcd");
        $dumpvars(0, riscv_soc_inst);
        clk = 0;
        rst = `RSTN;
        #10 rst = `RST;
        #10 rst = `RSTN;
    end

    initial begin
        #5000 $finish;
        // `ifdef TEST_PROG
        //         wait(x26 == 32'b1)   // wait sim end, when x26 == 1
        //         #100
        //         if (x27 == 32'b1) begin
        //             $display("~~~~~~~~~~~~~~~~~~~ TEST_PASS ~~~~~~~~~~~~~~~~~~~");
        //             $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        //             $display("~~~~~~~~~ #####     ##     ####    #### ~~~~~~~~~");
        //             $display("~~~~~~~~~ #    #   #  #   #       #     ~~~~~~~~~");
        //             $display("~~~~~~~~~ #    #  #    #   ####    #### ~~~~~~~~~");
        //             $display("~~~~~~~~~ #####   ######       #       #~~~~~~~~~");
        //             $display("~~~~~~~~~ #       #    #  #    #  #    #~~~~~~~~~");
        //             $display("~~~~~~~~~ #       #    #   ####    #### ~~~~~~~~~");
        //             $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        //         end else begin
        //             $display("~~~~~~~~~~~~~~~~~~~ TEST_FAIL ~~~~~~~~~~~~~~~~~~~~");
        //             $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        //             $display("~~~~~~~~~~######    ##       #    #     ~~~~~~~~~~");
        //             $display("~~~~~~~~~~#        #  #      #    #     ~~~~~~~~~~");
        //             $display("~~~~~~~~~~#####   #    #     #    #     ~~~~~~~~~~");
        //             $display("~~~~~~~~~~#       ######     #    #     ~~~~~~~~~~");
        //             $display("~~~~~~~~~~#       #    #     #    #     ~~~~~~~~~~");
        //             $display("~~~~~~~~~~#       #    #     #    ######~~~~~~~~~~");
        //             $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        //             $display("fail testnum = %2d", x3);
        //             for (r = 0; r < 32; r = r + 1)
        //                 $display("x%2d = 0x%x", r, tinyriscv_soc_top_0.u_tinyriscv.u_regs.regs[r]);
        //     end
        // `endif

    end
endmodule