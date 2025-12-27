module IF_reg (
    input  logic clk,
    input  logic reset,
    input  logic stall,
    input  logic flush,
    input  logic [31:0] i_pc_IF,
    output  logic        o_insn_vld_IF,
    input  logic        PCsel,
    input  logic [31:0] mux_out,
    input  logic [31:0] i_pc_plus4_IF,
    input  logic [31:0] i_instruction_IF,
    output logic [31:0] o_pc_IF,
    output logic [31:0] o_pc_plus4_IF,
    output logic [31:0] o_instruction_IF
);

//logic [31:0] i_pc ;
//assign i_pc = PCsel ? mux_out : i_pc_IF;
//logic [31:0] pc_plus4;
//assign pc_plus4 = mux_out + 4;
//logic [31:0] o_pc_plus4;
//assign o_pc_plus4 = PCsel ? pc_plus4 : i_pc_plus4_IF;




always_ff @(posedge clk or negedge reset) begin
    if (!reset) begin
        o_pc_IF          <= 32'd0; // Reset PC to 0
        o_pc_plus4_IF    <= 32'd0; // Reset PC to 0
        o_instruction_IF <= 32'd0;        
    end else if (stall) begin
        o_pc_IF             <=           o_pc_IF        ;
        o_pc_plus4_IF       <=     o_pc_plus4_IF        ;
        o_instruction_IF    <=  o_instruction_IF        ;
    end else begin 
        o_pc_IF             <=  flush ? 32'd0  :     i_pc_IF                 ;
        o_pc_plus4_IF       <=  flush ? 32'd0  :     o_pc_plus4_IF           ;
        o_instruction_IF    <=  flush ? 32'd0  :     i_instruction_IF     ;
    end
end


assign o_insn_vld_IF = flush ? 1'b0 : 1'b1;

endmodule 