module MEM_reg (
    input  logic        clk,
    input  logic        reset,
    input  logic        flush,
    input  logic        stall,
    input  logic        i_ctrl_MEM,
    input  logic        i_insn_vld_MEM,
    input  logic [31:0] i_instruction_MEM,
    input  logic        i_RegWen_MEM   ,
    input  logic        i_mispred_MEM  ,
    input  logic [31:0] i_mem_foward_MEM,
    input  logic [1:0]  i_wb_select_MEM,
    input  logic [31:0] i_ld_data_MEM,
    input  logic [31:0] i_pc_MEM,
    output logic [31:0] o_pc_MEM,
    output logic [31:0] o_ld_data_MEM,
    output logic [1:0]  o_wb_select_MEM,
    output logic [31:0] o_mem_foward_MEM, 
    output logic        o_mispred_MEM  ,
    output logic        o_RegWen_MEM   ,
    output logic  o_ctrl_MEM,
    output logic        o_insn_vld_MEM,
    output logic [31:0] o_instruction_MEM
);

always_ff @(posedge clk or negedge reset) begin
    if(!reset)  begin
        o_ctrl_MEM          <= 1'b0;
        o_insn_vld_MEM      <= 1'b0;
        o_instruction_MEM   <= 32'b0;
        o_RegWen_MEM        <= 1'b0;
        o_mispred_MEM       <= 1'b0;
        o_wb_select_MEM     <= 2'b0;
        o_ld_data_MEM       <= 32'b0;
        o_mem_foward_MEM    <= 32'b0;
        o_pc_MEM            <= 32'b0;
    end else if (stall) begin
        o_ctrl_MEM          <=  o_ctrl_MEM       ;
        o_insn_vld_MEM      <=  o_insn_vld_MEM   ;
        o_instruction_MEM   <=  o_instruction_MEM;
        o_RegWen_MEM        <=  o_RegWen_MEM     ;
        o_mispred_MEM       <=  o_mispred_MEM    ;
        o_wb_select_MEM     <=  o_wb_select_MEM  ;
        o_ld_data_MEM       <=  o_ld_data_MEM    ;
        o_mem_foward_MEM    <=  o_mem_foward_MEM ;
        o_pc_MEM            <=  o_pc_MEM         ;
    end 
    else begin 
        o_ctrl_MEM          <= flush ? 1'b0  : i_ctrl_MEM;
        o_insn_vld_MEM      <= flush ? 1'b0  : i_insn_vld_MEM;
        o_instruction_MEM   <= flush ? 32'b0 : i_instruction_MEM;
        o_RegWen_MEM        <= flush ? 1'b0  : i_RegWen_MEM;
        o_mispred_MEM       <= flush ? 1'b0 : i_mispred_MEM;
        o_wb_select_MEM     <= flush ? 2'b0 : i_wb_select_MEM;
        o_ld_data_MEM       <= flush ? 32'b0 : i_ld_data_MEM;
        o_mem_foward_MEM    <= flush ? 32'b0 : i_mem_foward_MEM;
        o_pc_MEM            <= flush ? 32'b0 : i_pc_MEM;
    end
end

endmodule