module imm_gen 
(input logic [24:0] i_imm,
input logic [6:0] i_sel,            // opcode
output logic [31:0] o_imm);

logic [2:0] flag;

imm_flag flag_inst (.opcode(i_sel),
                    .flag (flag)
                    );


always_comb begin
    case (flag)
        3'b000: o_imm = {{20{i_imm[24]}}, i_imm[24:13]}; // I-type 

        3'b001: o_imm = {{20{i_imm[24]}}, i_imm[24:18], i_imm[4:0]}; // S-type 

        3'b010: o_imm = {{19{i_imm[24]}}, i_imm[24], i_imm[0], i_imm[23:18], i_imm[4:1], 1'b0}; // B-type branch

        3'b011: o_imm = {i_imm[24:5], 12'b0}; // U-type 
        
        3'b100: o_imm = {{11{i_imm[24]}}, i_imm[24], i_imm[12:5], i_imm[13], i_imm[23:14], 1'b0}; // J-type JAL
       
        default:    o_imm = 32'b0;
    endcase
    end 
endmodule 