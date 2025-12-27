module LOGICAL //(i_operand_a, i_operand_b, i_alu_op, o_result);
(input logic [31:0] i_operand_a, i_operand_b,
input logic [1:0] i_alu_op, //00 AND, 01 OR, 10 XOR
output logic [31:0] o_result);

always_comb begin
    case (i_alu_op)
        2'b00: o_result = i_operand_a & i_operand_b; // AND
        2'b01: o_result = i_operand_a | i_operand_b; // OR
        2'b10: o_result = i_operand_a ^ i_operand_b; // XOR
        default: o_result = 32'b0;
    endcase
end

endmodule