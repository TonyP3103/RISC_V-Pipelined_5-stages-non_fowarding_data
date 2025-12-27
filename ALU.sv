module ALU
(input logic [31:0] i_operand_a, i_operand_b,
input logic [3:0] i_alu_op,
output logic [31:0] mux_out);
 
logic [31:0] ARTHIMETIC, SHIFT, LOGICAL;


ARITHMETIC ARITHMETIC_DUT (	.i_operand_a(i_operand_a),
                                        .i_operand_b(i_operand_b),
                                        .op(i_alu_op[1:0]),
                                        .ARITHMETIC_result(ARTHIMETIC)
                                        );
                                
LOGICAL LOGICAL_DUT (	.i_operand_a(i_operand_a),
                                        .i_operand_b(i_operand_b),  
                                        .i_alu_op(i_alu_op[1:0]),
                                        .o_result(LOGICAL)
                                        );


shifter shifter_DUT (	.i_data(i_operand_a),
                        .i_shamt(i_operand_b[4:0]),
                        .i_type(i_alu_op[1:0]),
                        .o_result(SHIFT)
                        );


ALU_MUX  MUX (  .ARTHIMETIC(ARTHIMETIC), 
                .SHIFT(SHIFT),  
                .LOGICAL(LOGICAL), 
                .sel(i_alu_op[3:2]), 
                .mux_out(mux_out));

endmodule 