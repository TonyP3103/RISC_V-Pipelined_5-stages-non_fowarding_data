module LSU_MUX //(data_data, io_data, lsu_sel, lsu_data_out);
(input logic [31:0] data_data, io_data,
output logic [31:0] lsu_data_out,
input logic [1:0] lsu_sel);

always_comb begin
  case (lsu_sel)
    2'b01: lsu_data_out = data_data;
    2'b10: lsu_data_out = io_data;
    default: lsu_data_out = 32'd10;
  endcase
end

endmodule