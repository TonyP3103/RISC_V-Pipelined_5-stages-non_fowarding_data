module EX_reg (
    input  logic        clk,
    input  logic        reset,              // async active-low reset
    input  logic        flush,              // synchronous flush (e.g. branch mispredict)
    input  logic        stall,              // stall: hold current outputs
    input  logic [31:0] i_pc_plus4_EX,
    input  logic [31:0] i_mux_out_EX,
    input  logic [31:0] i_rs2_data_EX,
    input  logic        i_ctrl_EX,
    input  logic        i_insn_vld_EX,
    input  logic [31:0] i_instruction_EX,
    input  logic        i_RegWen_EX,
    input  logic        i_MemRW_EX,
    input  logic [1:0]  i_wb_select_EX,
    input  logic [31:0] i_imm_EX,
    input  logic [31:0] i_pc_EX,
    output logic [31:0] o_pc_EX,
    output logic [31:0] o_imm_EX,
    output logic [1:0]  o_wb_select_EX,
    output logic        o_MemRW_EX,
    output logic        o_mispred_EX,           // misprediction counter
    output logic        o_ctrl_EX,
    output logic [31:0] o_pc_plus4_EX,
    output logic [31:0] o_mux_out_EX,
    output logic [31:0] o_rs2_data_EX,
    output logic        o_insn_vld_EX,
    output logic [31:0] o_instruction_EX,
    output logic        o_RegWen_EX
);


    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            // asynchronous reset: clear all pipeline registers and counter
            o_pc_plus4_EX    <= 32'b0;
            o_mux_out_EX     <= 32'b0;
            o_rs2_data_EX    <= 32'b0;
            o_ctrl_EX        <= 1'b0;
            o_insn_vld_EX    <= 1'b0;
            o_instruction_EX <= 32'b0;
            o_RegWen_EX      <= 1'b0;
            o_MemRW_EX       <= 1'b0;
            o_wb_select_EX   <= 2'b0;
            o_imm_EX         <= 32'b0;
            o_pc_EX          <= 32'b0;
            o_mispred_EX     <= 1'b0;
        end else if (stall) begin
            o_pc_plus4_EX    <= o_pc_plus4_EX;
            o_mux_out_EX     <= o_mux_out_EX;
            o_rs2_data_EX    <= o_rs2_data_EX;
            o_ctrl_EX        <= o_ctrl_EX;
            o_insn_vld_EX    <= o_insn_vld_EX;
            o_instruction_EX <= o_instruction_EX;
            o_RegWen_EX      <= o_RegWen_EX;
            o_MemRW_EX       <= o_MemRW_EX;
            o_wb_select_EX   <= o_wb_select_EX;
            o_imm_EX         <= o_imm_EX;
            o_pc_EX          <= o_pc_EX;
            o_mispred_EX     <= o_mispred_EX;
        end else begin
            o_pc_plus4_EX    <= /*flush ? 32'b0 :*/ i_pc_plus4_EX;
            o_mux_out_EX     <= /*flush ? 32'b0 :*/ i_mux_out_EX;
            o_rs2_data_EX    <= /*flush ? 32'b0 :*/ i_rs2_data_EX;
            o_ctrl_EX        <= /*flush ? 1'b0  :*/ i_ctrl_EX;
            o_insn_vld_EX    <= /*flush ? 1'b0  :*/ i_insn_vld_EX;
            o_instruction_EX <= /*flush ? 32'b0 :*/ i_instruction_EX;
            o_RegWen_EX      <= /*flush ? 1'b0  :*/ i_RegWen_EX;
            o_MemRW_EX       <= /*flush ? 1'b0  :*/ i_MemRW_EX;
            o_wb_select_EX   <= /*flush ? 2'b0  :*/ i_wb_select_EX;
            o_imm_EX         <= /*flush ? 32'b0 :*/ i_imm_EX;
            o_pc_EX          <= flush ? 1'b0 : i_pc_EX;
            o_mispred_EX     <= flush ;
        end
        end
 

endmodule
