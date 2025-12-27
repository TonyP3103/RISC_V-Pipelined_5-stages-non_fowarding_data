module PC //(i_clk, i_rst, o_pc, o_pc_plus4, PCsel, mux_out);
(input logic i_clk, i_rst, PCsel,
input logic  stall,
input logic [31:0] i_pc,
output logic [31:0] o_pc
);

logic [31:0] o_pc_plus4;

logic wait_bit;

always_ff @(posedge i_clk or negedge i_rst) begin
    if (!i_rst) begin
        o_pc <= 32'd0; // Reset PC to address 0x00000000
        wait_bit <= 1'b1;
    end else if (wait_bit) begin
        o_pc <= 32'b0;
        wait_bit <= 1'b0;
    end else begin
        o_pc <=stall? o_pc: o_pc_plus4;
        wait_bit <= 1'b0;
    end
end


adder_32_bit adder_32bit_inst   (  .a(i_pc),
                                    .b(32'd4),
                                    .cin(1'b0),
                                    .sum(o_pc_plus4),
                                    .G(),
                                    .P(),
                                    .cout(),
                                    .overflow());

endmodule 
