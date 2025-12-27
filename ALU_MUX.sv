module ALU_MUX //(ARTHIMETIC, SHIFT,  LOGICAL, sel, mux_out);
(
input logic [31:0] ARTHIMETIC, SHIFT,  LOGICAL,
input logic [1:0] sel,
output reg [31:0] mux_out);

always_comb begin
    case (sel)
        2'b00: mux_out = ARTHIMETIC;
        2'b01: mux_out = SHIFT;
        2'b10: mux_out = LOGICAL;
        default: mux_out = 32'b0;
    endcase
end

endmodule
