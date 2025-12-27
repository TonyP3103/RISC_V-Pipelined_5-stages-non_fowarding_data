module ARITHMETIC //(i_operand_a, i_operand_b, op, ARITHMETIC_result);
(input logic [31:0] i_operand_a, i_operand_b,
input logic [1:0] op,
output logic  [31:0] ARITHMETIC_result);

logic cout,signed_set;
logic [31:0] cin_32bit;

logic[31:0] add_sub;
logic [31:0] SET;

logic select;
assign select = op[1] | op[0];

logic cin;
assign cin = op[1] ? 1'b1 : op[0];

always_comb begin
    if (select) begin
        if (op[0]) begin
            SET = {31'd0, signed_set};
            cin_32bit = 32'hFFFFFFFF; 
        end else begin
            SET = {31'd0, !cout};
            cin_32bit = 32'hFFFFFFFF; 
        end
    end else begin
        cin_32bit = 32'h00000000;
				SET = 32'd0;
    end
end

assign signed_set = !i_operand_b[31] & add_sub[31] | i_operand_a[31] & add_sub[31] | i_operand_a[31] & !i_operand_b[31];

adder_32_bit adder32bit_ARITHMETIC (	.a(i_operand_a),
                                        .b(i_operand_b ^ cin_32bit),
                                        .cin(cin),
                                        .sum(add_sub),
                                        .G(),
                                        .P(),
                                        .cout(cout),
                                        .overflow()
                                        );


assign ARITHMETIC_result = (op[1]) ? SET : add_sub;
endmodule