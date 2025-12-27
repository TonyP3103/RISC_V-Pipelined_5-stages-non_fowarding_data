module ID_reg (
    input   logic        clk,
    input   logic        reset,      // async active-low reset
    input   logic        flush,      // synchronous flush
    input   logic        stall,      // freeze outputs if 1

    // ---- Inputs from ID stage ----
    input   logic [31:0] i_pc_ID,
    input   logic [31:0] i_instruction_ID,
    input   logic [31:0] i_pc_plus4_ID,
    input   logic        i_insn_vld_ID,

    input   logic        i_RegWen_ID,
    input   logic        i_Asel_ID,
    input   logic        i_Bsel_ID,
    input   logic        i_MemRW_ID,
    input   logic [3:0]  i_ALU_sel_ID,
    input   logic [1:0]  i_wb_select_ID,
    input   logic        i_o_br_un_ID,

    input   logic [31:0] i_rs1_data_ID,
    input   logic [31:0] i_rs2_data_ID,
    input   logic [4:0]  i_rs1_addr_ID,
    input   logic [4:0]  i_rs2_addr_ID,

    input   logic [31:0] i_imm_ID,
    input   logic        i_ctrl_ID,

    // ---- Outputs to EX stage ----
    output  logic        o_ctrl_ID,
    output  logic [31:0] o_imm_ID,
    output  logic [31:0] o_pc_plus4_ID,
    output  logic [31:0] o_pc_ID,
    output  logic [31:0] o_instruction_ID,
    output  logic        o_insn_vld_ID,
    output  logic [31:0] o_rs1_data_ID,
    output  logic [31:0] o_rs2_data_ID,
    output  logic [4:0]  o_rs1_addr_ID,
    output  logic [4:0]  o_rs2_addr_ID,
    output  logic        o_RegWen_ID,
    output  logic        o_Asel_ID,
    output  logic        o_Bsel_ID,
    output  logic        o_MemRW_ID,
    output  logic [3:0]  o_ALU_sel_ID,
    output  logic [1:0]  o_wb_select_ID,
    output  logic        o_br_un_ID
);


    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            // ---- Asynchronous reset ----
            o_pc_ID           <= 32'b0;
            o_instruction_ID  <= 32'b0;
            o_pc_plus4_ID     <= 32'b0;
            o_RegWen_ID       <= 1'b0;
            o_Asel_ID         <= 1'b0;
            o_Bsel_ID         <= 1'b0;
            o_MemRW_ID        <= 1'b0;
            o_ALU_sel_ID      <= 4'b0;
            o_wb_select_ID    <= 2'b0;
            o_br_un_ID        <= 1'b0;
            o_rs1_data_ID     <= 32'b0;
            o_rs2_data_ID     <= 32'b0;
            o_imm_ID          <= 32'b0;
            o_rs1_addr_ID     <= 5'b0;
            o_rs2_addr_ID     <= 5'b0;
            o_ctrl_ID         <= 1'b0;
            o_insn_vld_ID     <= 1'b0; 
        
        end else if (flush) begin

              o_pc_ID           <= 32'b0;
            o_instruction_ID  <= 32'b0;
            o_pc_plus4_ID     <= 32'b0;
            o_RegWen_ID       <= 1'b0;
            o_Asel_ID         <= 1'b0;
            o_Bsel_ID         <= 1'b0;
            o_MemRW_ID        <= 1'b0;
            o_ALU_sel_ID      <= 4'b0;
            o_wb_select_ID    <= 2'b0;
            o_br_un_ID        <= 1'b0;
            o_rs1_data_ID     <= 32'b0;
            o_rs2_data_ID     <= 32'b0;
            o_imm_ID          <= 32'b0;
            o_rs1_addr_ID     <= 5'b0;
            o_rs2_addr_ID     <= 5'b0;
            o_ctrl_ID         <= 1'b0;
            o_insn_vld_ID     <= 1'b0; 

        end else begin
            // ---- Normal pipeline update ----
            o_pc_ID           <= !stall ? i_pc_ID       :o_pc_ID;
            o_instruction_ID  <= !stall ? i_instruction_ID       :o_instruction_ID;
            o_pc_plus4_ID     <= !stall ? i_pc_plus4_ID       :o_pc_plus4_ID;
            o_RegWen_ID       <= !stall ? i_RegWen_ID       :o_RegWen_ID;
            o_Asel_ID         <= !stall ? i_Asel_ID       :o_Asel_ID;
            o_Bsel_ID         <= !stall ? i_Bsel_ID       :o_Bsel_ID;
            o_MemRW_ID        <= !stall ? i_MemRW_ID       :o_MemRW_ID;
            o_ALU_sel_ID      <= !stall ? i_ALU_sel_ID       :o_ALU_sel_ID;
            o_wb_select_ID    <= !stall ? i_wb_select_ID       :o_wb_select_ID;
            o_br_un_ID        <= !stall ? i_o_br_un_ID       :o_br_un_ID;
            o_rs1_data_ID     <= !stall ? i_rs1_data_ID       :o_rs1_data_ID;
            o_rs2_data_ID     <= !stall ? i_rs2_data_ID       :o_rs2_data_ID;
            o_rs1_addr_ID     <= !stall ? i_rs1_addr_ID       :o_rs1_addr_ID;
            o_rs2_addr_ID     <= !stall ? i_rs2_addr_ID       :o_rs2_addr_ID;
            o_imm_ID          <= !stall ? i_imm_ID       :o_imm_ID;
            o_ctrl_ID         <= !stall ? i_ctrl_ID       :o_ctrl_ID;
            o_insn_vld_ID     <= !stall ? i_insn_vld_ID       : o_insn_vld_ID;

        end
        end


//assign o_insn_vld_ID  = flush ? 1'b0 : i_insn_vld_ID;
  

endmodule



/*
module ID_reg (
input   logic clk,
input   logic reset,
input   logic flush,  
input   logic stall,
input   logic [31:0] i_pc,
input   logic [31:0] i_instruction,            // seperate instruction fields
input   logic [31:0] i_pc_plus4,
input   logic i_RegWen_ID,
input   logic i_Asel_ID,
input   logic i_Bsel_ID,
input   logic i_MemRW_ID,
input   logic [3:0] i_ALU_sel_ID,
input   logic [1:0] i_wb_select_ID,
input   logic i_o_br_un_ID,
input   logic [31:0] i_rs1_data_ID,
input   logic [31:0] i_rs2_data_ID,
input   logic [4:0] i_rs1_addr_ID,
input   logic [4:0] i_rs2_addr_ID,
input   logic [31:0] i_imm_ID,
input   logic        i_ctrl_ID,

output  logic        o_ctrl_ID,
output  logic [31:0] o_imm_ID,
output  logic [31:0] o_pc_plus4,
output  logic [31:0] o_pc,
output  logic [31:0] o_instruction,
output  logic o_insn_vld_ID,
output  logic [31:0] o_rs1_data_ID,
output  logic [31:0] o_rs2_data_ID,
output  logic [4:0] o_rs1_addr_ID,
output  logic [4:0] o_rs2_addr_ID,
output  logic o_RegWen_ID,
output  logic o_Asel_ID,
output  logic o_Bsel_ID,
output  logic o_MemRW_ID,
output  logic [3:0] o_ALU_sel_ID,
output  logic [1:0] o_wb_select_ID,
output  logic o_br_un_ID

);

always_ff @(posedge clk or negedge reset) begin
    if(!reset | flush)  begin
        o_pc            = 32'b0;
        o_instruction   = 32'b0;
        o_pc_plus4      = 32'b0;
        o_RegWen_ID     = 1'b0;
        o_Asel_ID       = 1'b0;
        o_Bsel_ID       = 1'b0;
        o_MemRW_ID      = 1'b0;
        o_ALU_sel_ID    = 4'b0;
        o_wb_select_ID  = 2'b0;
        o_br_un_ID      = 1'b0;
        o_rs1_data_ID   = 32'b0;
        o_rs2_data_ID   = 32'b0;
        o_imm_ID        = 32'b0;
        o_rs1_addr_ID   = 4'b0;
        o_rs2_addr_ID   = 4'b0;
        o_ctrl_ID       = 1'b0;

    end
    else begin 
        o_pc            <=  stall ? o_pc             : i_pc;
        o_instruction   <=  stall ? o_instruction    : i_instruction;
        o_pc_plus4      <=  stall ? o_pc_plus4       : i_pc_plus4;
        o_RegWen_ID     <=  stall ? o_RegWen_ID      : i_RegWen_ID;
        o_Asel_ID       <=  stall ? o_Asel_ID        : i_Asel_ID;
        o_Bsel_ID       <=  stall ? o_Bsel_ID        : i_Bsel_ID;
        o_MemRW_ID      <=  stall ? o_MemRW_ID       : i_MemRW_ID;
        o_ALU_sel_ID    <=  stall ? o_ALU_sel_ID     : i_ALU_sel_ID;
        o_wb_select_ID  <=  stall ? o_wb_select_ID   : i_wb_select_ID;
        o_br_un_ID      <=  stall ? o_br_un_ID       : i_o_br_un_ID;
        o_rs1_data_ID   <=  stall ? o_rs1_data_ID    : i_rs1_data_ID;
        o_rs2_data_ID   <=  stall ? o_rs2_data_ID    : i_rs2_data_ID;
        o_imm_ID        <=  stall ? o_imm_ID         : i_imm_ID;
        o_rs1_addr_ID   <=  stall ? o_rs1_addr_ID    : i_rs1_addr_ID;
        o_rs2_addr_ID   <=  stall ? o_rs2_addr_ID    : i_rs2_addr_ID;
        o_ctrl_ID       <=  stall ? o_ctrl_ID        : i_ctrl_ID;
    end
end 

assign o_insn_vld_ID = (flush) ? 1'b0 : 1'b1;


endmodule */

