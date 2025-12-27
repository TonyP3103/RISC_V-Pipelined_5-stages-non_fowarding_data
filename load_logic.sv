module load_logic //(funct3, i_wback_data, o_wback_data,opcode);

(input logic [2:0] funct3,                   //funct3[2] use for sign select, funct3[1:0] use for byte/halfword/word select
input logic [6:0] opcode,
input logic [31:0] i_wback_data,
output logic [31:0] o_wback_data);

localparam R_type = 7'b0110011;
localparam I_type_ALU = 7'b0010011;
localparam I_type_load = 7'b0000011;
localparam S_type = 7'b0100011;
localparam B_type = 7'b1100011;
localparam J_type = 7'b1101111; // JAL
localparam I_type_JALR = 7'b1100111;
localparam U_type_AUIPC = 7'b0010111;
localparam U_type_LUI = 7'b0110111;

logic wb_select;

always_comb begin
    wb_select = 1'b0;
    case (opcode)
    R_type: wb_select = 1'b0;

    I_type_ALU:  wb_select = 1'b0;

    I_type_load: wb_select = !funct3[1];

    S_type:  wb_select = 1'b0;

    B_type:  wb_select = 1'b1;

    J_type:  wb_select = 1'b0;

    I_type_JALR:   wb_select = 1'b0;

    U_type_AUIPC:  wb_select = 1'b0;

    U_type_LUI:  wb_select = 1'b0;

    default:  wb_select = 1'b0;
    endcase
end 
                                                      //use mask
logic [31:0] mask, masked_data;
logic [31:0] signed_extend;

assign mask = (funct3[1]) ? 32'hFFFFFFFF : ((funct3[0]) ? 32'h0000FFFF : 32'h000000FF); //word, halfword, byte
assign signed_extend = (funct3[2]) ?  32'h00000000 : ((funct3[0]) ? (i_wback_data[15] ? 32'hFFFF0000 : 32'h00000000 ):(i_wback_data[7] ? 32'hFFFFFF00 : 32'h00000000) ); //sign extend or zero extend

assign masked_data = i_wback_data & mask;

assign o_wback_data = (wb_select) ? (masked_data | signed_extend) : i_wback_data ;

endmodule 