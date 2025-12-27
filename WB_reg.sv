module WB_reg (
    input logic i_clk,
    input logic i_rst,
    //input logic flush,
    input logic [31:0] i_pc_WB,
    input logic [31:0] i_instruction_WB,
    input logic [31:0] i_wb_foward_WB,
    output logic [31:0] o_wb_foward_WB,
    input logic        i_insn_vld_WB,
    input logic i_RegWen_WB,
    output logic o_RegWen_WB,
    output logic        o_insn_vld_WB,
    output logic [31:0] o_instruction_WB,
    output logic [31:0] o_pc_WB
    );

    always_ff @(posedge i_clk or negedge i_rst) begin
        if (!i_rst) begin
            o_instruction_WB <= 32'b0;
            o_pc_WB <= 32'b0;
            o_insn_vld_WB <= 1'b0;
            o_RegWen_WB <= 1'b0;
            o_wb_foward_WB <= 32'b0;
        end else begin
            o_instruction_WB <=  i_instruction_WB;
            o_pc_WB <=           i_pc_WB;
            o_insn_vld_WB <=     i_insn_vld_WB;
            o_RegWen_WB <=       i_RegWen_WB;
            o_wb_foward_WB <=   i_wb_foward_WB;
        end
    end

endmodule 