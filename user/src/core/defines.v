`define         INST_ADDR_BUS   31:0            
`define         INST_BUS        31:0            
`define         HOLD_FLAG_BUS   2:0             
`define         MEM_ADDR_BUS    31:0            
`define         MEM_BUS         31:0            
`define         REG_ADDR_BUS    4:0             
`define         REG_BUS         31:0            
`define         BYTE_BUS        7:0             
`define         FUNCT7_BUS      6:0             
`define         OPCODE_BUS      6:0             
`define         FUNCT3_BUS      2:0             

//define the size of the memory and register file
`define         REG_NUM         32              
`define         ROM_SIZE        4096            
`define         MEM_SIZE        4096            

`define         RST             1'b1            
`define         RSTN            1'b0            
`define         WRITE_ENABLE    1'b1            
`define         WRITE_DISABLE   1'b0            


`define         JUMP_YES        1'b1            
`define         JUMP_NO         1'b0            

`define         ZERO_WORD       32'h0           
`define         ZERO_REG        5'b00000        
`define         PC_RST_ADDR     32'h0           

`define         HOLD_NONE       3'b000          
`define         HOLD_PC         3'b001          
`define         HOLD_IF         3'b010          
`define         HOLD_ID         3'b011          


`define         INST_NOP        32'h00000013    
//GPIO
`define         OUTPUT          2'01            
`define         INPUT           2'10            
`define         HIGH_INPEDANCE  2'00            

//I type instructions
`define         INST_TYPE_I     7'b0010011      
`define         INST_ADDI       3'b000          
`define         INST_SLTI       3'b010          
`define         INST_SLTIU      3'b011          
`define         INST_XORI       3'b100          
`define         INST_ORI        3'b110          
`define         INST_ANDI       3'b111          
`define         INST_SLLI       3'b001          
`define         INST_SRI        3'b101          

// L type inst
`define         INST_TYPE_L     7'b0000011      
`define         INST_LB         3'b000          
`define         INST_LH         3'b001          
`define         INST_LW         3'b010          
`define         INST_LBU        3'b100          
`define         INST_LHU        3'b101          

// S type inst
`define         INST_TYPE_S     7'b0100011      
`define         INST_SB         3'b000          
`define         INST_SH         3'b001          
`define         INST_SW         3'b010          

// R type inst
`define         INST_TYPE_R     7'b0110011      
`define         INST_ADD        3'b000          
`define         INST_SLL        3'b001          
`define         INST_SLT        3'b010          
`define         INST_SLTU       3'b011          
`define         INST_XOR        3'b100          
`define         INST_SR         3'b101          
`define         INST_OR         3'b110          
`define         INST_AND        3'b111          

// J type inst
`define         INST_JAL        7'b1101111      
`define         INST_JALR       7'b1100111      

`define         INST_LUI        7'b0110111      
`define         INST_AUIPC      7'b0010111      
`define         INST_MRET       32'h30200073    
`define         INST_RET        32'h00008067    

`define         INST_FENCE      7'b0001111      
`define         INST_NOP_OP     7'b0000001      
`define         INST_ECALL      32'h73          
`define         INST_EBREAK     32'h00100073    

// B type inst
`define         INST_TYPE_B     7'b1100011      
`define         INST_BEQ        3'b000          
`define         INST_BNE        3'b001          
`define         INST_BLT        3'b100          
`define         INST_BGE        3'b101          
`define         INST_BLTU       3'b110          
`define         INST_BGEU       3'b111          
